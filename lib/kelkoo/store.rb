module Kelkoo
  class Store

    attr_accessor :name, :id, :image_url

    def initialize(attributes = {})
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def self.from_payload(payload)
      new(
        name: payload['Name'],
        image_url: payload.fetch('Logo', {})['Url'],
        id: payload['id']
      )
    end

  end
end
