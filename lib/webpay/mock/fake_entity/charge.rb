module WebPay::Mock::FakeEntity
  class Charge < Base
    def object_name
      'charge'
    end

    def basic_attributes
      {
        amount: 1000,
        card: fake_card,
        currency: 'jpy',
        paid: true,
        captured: true,
        refunded: false,
        amount_refunded: 0,
        customer: nil,
        shop: nil,
        recursion: nil,
        description: nil,
        failure_message: nil,
        expire_time: nil,
        fees: [{
            object: 'fee',
            transaction_type: 'payment',
            transaction_fee: 0,
            rate: 3.25,
            amount: 33,
            created: Time.now.to_i
          }]
      }
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
