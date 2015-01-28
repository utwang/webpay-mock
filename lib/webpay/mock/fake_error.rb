module WebPay::Mock::FakeError
  include WebPay::Mock::Util

  def bad_request(overrides = {})
    {
      status: 400,
      body: { error: {
          'message'   => 'Missing required param: amount',
          'caused_by' => 'insufficient',
          'param'     => 'amount',
          'type'      => 'invalid_request_error'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def unauthorized(overrides = {})
    {
      status: 401,
      body: { error: {
          'message'   => "You did not provide an API key. You need to provide your API key in the Authorization header, using Bearer auth (e.g. 'Authorization: Bearer YOUR_SECRET_KEY').",
          'caused_by' => 'insufficient',
          'type'      => 'unauthorized'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def card_error(overrides = {})
    {
      status: 402,
      body: { error: {
          'message'   => 'The card number is invalid. Make sure the number entered matches your credit card.',
          'caused_by' => 'buyer',
          'param'     => 'number',
          'type'      => 'card_error',
          'code'      => 'incorrect_number'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def not_found(overrides = {})
    {
      status: 404,
      body: { error: {
          'message'   => 'No such charge',
          'caused_by' => 'missing',
          'param'     => 'id',
          'type'      => 'invalid_request_error'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def internal_server_error(overrides = {})
    {
      status: 500,
      body: { error: {
          'type'      => 'api_error',
          'message'   => 'Unkown error occured',
          'caused_by' => 'service'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end
end
