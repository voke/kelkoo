# Kelkoo

A small wrapper around Kelkoo API. This is **work in progress!**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kelkoo', github: 'voke/kelkoo'
```

## Usage

#### Configure
```ruby
Kelkoo.configure do |config|
  config.partner_id = "123"
  config.partner_key = "abc123"
  config.market = "se"
end
```

You don't have to use the configure block. Default credentials are loaded
automatically from env variables: `ENV['KELKOO_ID']`, `ENV['KELKOO_KEY']`
and `ENV['KELKOO_MARKET']`.

#### Products
Build request object using chainable scopes.
```ruby
products = Kelkoo::Product.where(query: 'iphone', brandName: 'apple').limit(10)

if merchant_id
  products = products.where(merchantId: merchant_id)
end

products.each do |product|

  p product.name
  p product.price
  p product.brand_name
  p product.image_url
  p product.url
  p product.shipping_cost
  p product.discount
  p product.regular_price
  p product.description

  p product.store.name
  p product.store.image_url

end

products.any?
products.count
products.total_count
products.next_page
products.current_page
products.last_page?

```
**NOTE:** Be aware of the case-sensitive param naming.
http://developer.kelkoo.com/shopping-services/product-search-v3/

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/voke/kelkoo.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
