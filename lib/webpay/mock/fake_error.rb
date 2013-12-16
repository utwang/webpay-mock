module Webpay::Mock::FakeError
  include Util

  def card_error(attributes = {})
    {
      status: 402,
      body: { error: {
          "type" => "card_error",
          "message" => "This card cannot be used.",
          "code" => "card_declined"
        }.merge(stringify_keys(attributes)) }.to_json
    }
  end
end
