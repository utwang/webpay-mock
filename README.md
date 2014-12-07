# WebPay::Mock [![Build Status](https://travis-ci.org/webpay/webpay-mock.svg)](https://travis-ci.org/webpay/webpay-mock)

WebPay::Mock helps development of WebPay client applications.

This generates a response object from request parameters, and wraps WebMock gem for easy end-to-end testing against webpay API server.

## Installation

Add this line to your application's Gemfile:

    gem 'webpay-mock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webpay-mock

## Usage

### RSpec

In `spec_helper.rb`,

```ruby
require 'webpay/mock'

RSpec.configure do |c|
  c.include WebPay::Mock::WebMockWrapper
end
```

In your spec file,

```ruby
let(:params) { { amount: 1000, currency: 'jpy', card: 'tok_xxxxxxxxx', description: 'test charge' } }
let!(:response) { webpay_stub(:charges, :create, params: params) }

specify { expect(webpay.charge.create(params).id).to eq response['id'] }
```

See [our test cases](https://github.com/webpay/webpay-mock/blob/master/spec/webmock_wrapper_spec.rb) for more examples.

### Testing error responses

Just return an error by type.

```ruby
webpay_stub(:charges, :create, error: :card_error, params: params)
```

Error kinds are:

- bad_request (400)
- unauthorized (401)
- card_error (402)
- not_found (404)
- internal_server_error (500)

Specify all fields to test a specific error.

```ruby
webpay_stub(:charges, :create, params: params, response: card_error(
    message: "You must provide the card which is not expired",
    caused_by: "buyer",
    param: "exp_month",
    code: "invalid_expiry_month"
    ))
```

For up-to-date details about error structure, see [API error document](https://webpay.jp/docs/api_errors) on our website.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Fixed bugs and new features must be tested.

## License

[The MIT License (MIT)](http://opensource.org/licenses/mit-license.html)

Copyright (c) 2013- WebPay, Inc.
