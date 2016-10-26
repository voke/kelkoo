module Kelkoo
  class Resource

    include Enumerable

    def initialize
      @params = { results: Kelkoo.config.default_limit }
    end

    def result
      response.entries
    end

    def response
      @response ||= self.class.parse(Kelkoo::Request.new(@params).execute,
        @params)
    end

    def each
      result.each do |entry|
        yield entry
      end
    end

    def per_page(value = nil)
      if value.nil? then limit_value
      else limit(value)
      end
    end

    def limit_value
      @params[:results]
    end

    def page(page_number)
      where(start: calculate_offset(page_number))
    end

    def limit(value)
      where(results: value)
    end

    def offset(value)
      where(start: value)
    end

    def where(params = {})
      @params.merge!(params)
      self
    end

    def self.where(params = {})
      new.where(params)
    end

    protected

    def calculate_offset(page_number)
      (page_number - 1) * per_page + 1
    end

  end
end
