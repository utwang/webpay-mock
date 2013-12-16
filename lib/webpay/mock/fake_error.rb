module WebPay::Mock::FakeError
  include WebPay::Mock::Util

  def bad_request(overrides = {})
    {
      status: 400,
      body: { error: {
          'type' => 'invalid_request_error',
          'message' => "can't save charge: Amount can't be blank",
          'param' => 'amount'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def unauthorized(overrides = {})
    {
      status: 401,
      body: { error: {
          'message' => "You did not provide an API key. You need to provide your API key in the Authorization header, using Bearer auth (e.g. 'Authorization: Bearer YOUR_SECRET_KEY')."
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def card_error(overrides = {})
    {
      status: 402,
      body: { error: {
          'type' => 'card_error',
          'message' => 'This card cannot be used.',
          'code' => 'card_declined'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def not_found(overrides = {})
    {
      status: 404,
      body: { error: {
          'type' => 'invalid_request_error',
          'message' => 'No such charge: ch_bBM4IJ0XF2VIch8',
          'param' => 'id'
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end

  def internal_server_error(overrides = {})
    {
      status: 500,
      body: { error: {
          'type' => 'api_error',
          'message' => 'Unkown error occured',
        }.merge(stringify_keys(overrides)) }.to_json
    }
  end
end
