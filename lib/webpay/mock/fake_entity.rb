require 'securerandom'

module WebPay::Mock::FakeEntity
  include Util

  def customer_from(params, overrides = {})
    params = stringify_keys(params)
    builder = Builder.new('customer')
      .set_from(email: nil, description: nil, active_card: nil)
      .set_from(params, :email, :description)
    card = params['card']
    case card
    when Hash
      builder[:active_card] = card_builder_from(card).hash
    when String
      builder[:active_card] = fake_card
    end
    builder.set_from(overrides).build
  end

  def charge_from(params, overrides = {})
    params = stringify_keys(params)
    builder = Builder.new('charge')
      .set_from(amount_refunded: 0, paid: true, refunded: false, failure_message: nil, captured: true, expire_time: nil)
      .set_from(params, :amount, :currency, :description)
    card = params['card']
    case card
    when Hash
      builder[:card] = card_builder_from(card).hash
    when String
      builder[:card] = fake_card
    end
    if customer = params['customer']
      builder[:card] = fake_card
      builder[:customer] = customer
    end
    if params['capture'] == false
      builder[:captured] = builder[:paid] = false
      builder[:expire_time] = Time.now.to_i + 60 * 60 * 24 * 7
    end
    builder.set_from(overrides).build
  end

  def card_builder_from(params)
    params = stringify_keys(params)
    number = params['number']
    Builder.new('card')
      .set_from(params, :exp_month, :exp_year, :name)
      .set_from(
      fingerprint: fake_fingerprint,
      country: 'JP',
      type: 'Visa',
      cvc_check: 'pass',
      last4: number[-4..-1]
      )
  end

  def fake_card
    { "object"=>"card",
      "exp_year"=>2014,
      "exp_month"=>11,
      "fingerprint"=>fake_fingerprint,
      "name"=>"KEI KUBO",
      "country"=>"JP",
      "type"=>"Visa",
      "cvc_check"=>"pass",
      "last4"=>"4242" }
  end

  def fake_fingerprint
    SecureRandom.hex(20).length
  end
end
