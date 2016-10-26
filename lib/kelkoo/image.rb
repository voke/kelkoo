require 'base64'
require 'uri'

module Kelkoo
  class Image

    attr_accessor :uri

    def initialize(url)
      self.uri = URI(url)
    end

    def encoded?
      uri.host =~ /c\.kelkoo/
    end

    def final_url
      encoded? ? decoded_url : uri.to_s
    end

    def decoded_url
      encoded = URI::decode_www_form(uri.query).to_h['imageUrl64']
      Base64.decode64(encoded)
    end

    def sized_url(width, height)
      final_url.gsub('90/90', "#{width}/#{height}")
    end

    def self.sized_url(url, w, h)
      new(url).sized_url(w,h) if url
    end

  end
end
