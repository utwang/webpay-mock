require 'securerandom'

module WebPay::Mock::FakeEntity
  include WebPay::Mock::Util

  def customer_from(params, overrides = {}, base = {})
    Customer.new(base).set_params(params).override(overrides).build
  end

  def charge_from(params, overrides = {}, base = {})
    Charge.new(base).set_params(params).override(overrides).build
  end

  def token_from(params, overrides = {})
    Token.new.set_params(params).override(overrides).build
  end

  def fake_event(overrides = {})
    Event.new.override(overrides).build
  end

  def fake_account(overrides = {})
    Account.new.override(overrides).build
  end

  def fake_list(path, proc)
    {
      'object' => 'list',
      'url' => '/v1' + path,
      'count' => 3,
      'data' => [proc.call, proc.call, proc.call]
    }
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
require 'webpay/mock/fake_entity/token'
require 'webpay/mock/fake_entity/event'
require 'webpay/mock/fake_entity/account'
