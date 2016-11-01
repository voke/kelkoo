module Kelkoo
  class Configuration

    attr_accessor :partner_id, :partner_key, :base_url, :market,
      :default_limit

    def initialize
      self.partner_id = ENV['KELKOO_ID']
      self.partner_key = ENV['KELKOO_KEY']
      self.base_url = 'http://%s.shoppingapis.kelkoo.com'
      self.default_limit = 20
      self.market = ENV['KELKOO_MARKET']
    end

  end
end
