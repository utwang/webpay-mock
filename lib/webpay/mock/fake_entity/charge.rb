module WebPay::Mock::FakeEntity
  class Charge < Base
    def object_name
      'charge'
    end

    def basic_attributes
      { amount: 1000, currency: 'jpy', amount_refunded: 0, paid: true, refunded: false, failure_message: nil, captured: true, expire_time: nil, card: fake_card }
    end

    def copy_attributes
      [:amount, :currency, :description]
    end

    def conversion(key, value)
      case key
      when 'card'
        { card: value.is_a?(Hash) ? card_from(value) : fake_card }
      when 'customer'
        { card: fake_card, customer: value }
      when 'capture'
        if value == false
          {
            captured:  false,
            paid: false,
            expire_time: Time.now.to_i + 60 * 60 * 24 * 7
          }
        end
      end
    end
  end
end
