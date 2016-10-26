require 'base64'
require 'forwardable'

module Kelkoo
  class Product < Kelkoo::Resource

    attr_accessor :id, :name, :price, :brand_name, :store, :image_url, :url,
      :shipping_cost, :discount, :regular_price

    extend Forwardable
    def_delegators :response, :total_count, :total_pages, :current_page,
      :next_page, :last_page?, :refinements

    def initialize(attributes = {})
      super()
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def base64_url
      Base64.urlsafe_encode64(self.url)
    end

    def refine(*values)
      where(refinement: Array(values).join(','))
    end

    def self.parse(payload, request_params)
      Kelkoo::ProductResponse.new(payload, request_params)
    end

    def self.api_path
      '/V3/productSearch'
    end

    def self.map_to_products(payload)
      payload['ProductSearch']['Products']['Product'].map do |entry|
        offer = entry.is_a?(Hash) ? entry['Offer'] : entry.last
        new(
          id: offer['id'],
          name: offer['Title'],
          url: offer['Url'],
          price: offer['Price']['Price'],
          shipping_cost: offer['Price']['DeliveryCost'],
          store: Store.from_payload(offer['Merchant']),
          brand_name: offer['Brand'],
          image_url: Kelkoo::Image.sized_url(offer['Images'].fetch('Image', {})['Url'], 300, 300),
          discount: offer['Price']['Rebate'],
          regular_price: offer['Price']['PriceWithoutRebate']
        )
      end
    end

  end
end
