require 'digest/md5'
require 'base64'
require 'open-uri'

module Kelkoo
  class Request

    attr_accessor :request_params, :partner_id, :partner_key, :market

    def initialize(options = {})
      self.partner_id = options.delete(:partner_id) || Kelkoo.config.partner_id
      self.partner_key = options.delete(:partner_key) || Kelkoo.config.partner_key
      self.market = options.delete(:market) || Kelkoo.config.market
      self.request_params = options
      unless self.partner_id || self.partner_key || self.market
        raise ArgumentError, 'Missing Kelkoo credentials'
      end
    end

    def api_domain
      Kelkoo.config.base_url % market
    end

    def serialized_params
      request_params.reject { |k, v| v.nil? || v.to_s.empty? }
    end

    def url
      querystring = URI.encode_www_form(serialized_params)
      url_signer(api_domain, "/#{Kelkoo.config.version}/productSearch?#{querystring}", partner_id, partner_key)
    end

    def execute
      Kelkoo.logger.info("GET: #{url}")
      res = open(url)
      res.read
    end

    def url_signer (url_domain, url_path, partner, key)
      url_sig = "hash"
      # replace " " by "+"
      url_path.gsub(' ','+')
      # format URL
      url = url_path + "&aid=" + partner + "&timestamp=" + Time.now.to_i.to_s
      # URL needed to create the tokken
      s = url + key;
      md5_str_tokken = Digest::MD5.digest(s)
      md5_byte_tokken = md5_str_tokken.unpack('H*')
      base64_tokken = Base64.encode64(md5_str_tokken);
      base64_tokken.gsub!('+','.')
      base64_tokken.gsub!('/','_')
      base64_tokken.gsub!('=','-')
      url = url_domain + url + "&hash=" + base64_tokken
    end

  end
end
