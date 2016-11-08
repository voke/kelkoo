module Kelkoo
  class Refinement

    class RefinementValue < Struct.new(:name, :hits, :value)
    end

    attr_accessor :label, :name, :options

    def initialize(attributes = {})
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def opt_any_value?(values)
      (options.map(&:value) & values).empty?
    end

    def self.from_payload(payload)
      payload['ProductSearch']['Refinements']['Refinement'].map do |entry|
        refinement = new(label: entry['label'], name: entry['name'])
        refinement.options = []
        [entry['RefineValue']].flatten.each do |data|
          refinement.options << RefinementValue.new(
            data['Title'],
            data['NumberOfProducts'].to_i,
            data['Value']
          )
        end
        refinement
      end
    end

  end
end
