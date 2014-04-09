# WebPay::Mock

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
require 'webpay-mock'

RSpec.configure do |c|
  c.include WebPay::Mock::WebMockWrapper
end
```

In your spec file,

```ruby
let(:params) { { amount: 1000, currency: 'jpy', card: 'tok_xxxxxxxxx', description: 'test charge' } }
let!(:response) { webpay_stub(:charges, :create, params: params) }

specify { expect(WebPay::Charge.create(params).id).to eq response['id'] }
```

See [our test cases](https://github.com/tomykaira/webpay-mock/blob/master/spec/webmock_wrapper_spec.rb) for more examples.

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
