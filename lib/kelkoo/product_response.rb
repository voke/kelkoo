require 'crack/xml'

module Kelkoo
  class ProductResponse

    attr_accessor :refinements, :products, :payload, :request_params

     def initialize(payload, request_params)
       self.payload = Crack::XML.parse(payload)
       self.refinements = []
       self.products = []
       self.request_params = request_params
       parse
     end

     def entries
       self.products
     end

     def total_count
       Integer(payload['ProductSearch']['Products']['totalResultsAvailable'])
     end

     def total_pages
       (total_count.to_f / per_page).ceil
     end

     def per_page
       request_params[:results]
     end

     def count
       Integer(payload['ProductSearch']['Products']['totalResultsReturned'])
     end

     def current_page
       (position / per_page) + 1
     end

     def position
       Integer(payload['ProductSearch']['Products']['firstResultPosition'])
     end

     def next_page
       current_page + 1 unless last_page? || out_of_range?
     end

     def out_of_range?
       current_page > total_pages
     end

     def last_page?
       current_page == total_pages
     end

     def warnings
       Array(data['ProductSearch']['Warnings']['Warning'])
     end

     def parse
       if total_count > 0
         self.products = Product.map_to_products(payload)
         self.refinements = Refinement.map_to_refinements(payload)
       end
     end

  end
end
