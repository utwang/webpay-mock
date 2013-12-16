require 'securerandom'

module WebPay::Mock::FakeEntity
  include WebPay::Mock::Util

  def customer_from(params, overrides = {})
    Customer.new.set_params(params).override(overrides).build
  end

  def charge_from(params, overrides = {})
    Charge.new.set_params(params).override(overrides).build
  end

  def card_from(params, overrides = {})
    Card.new.set_params(params).override(overrides).build
  end

  def fake_card
    Card.new.build
  end

  def fake_fingerprint
    SecureRandom.hex(20)[0...40]
  end
end

require 'webpay/mock/fake_entity/base'
require 'webpay/mock/fake_entity/card'
require 'webpay/mock/fake_entity/charge'
require 'webpay/mock/fake_entity/customer'
