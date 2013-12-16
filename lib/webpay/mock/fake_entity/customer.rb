module WebPay::Mock::FakeEntity
  class Customer < Base
    def object_name
      'customer'
    end

    def basic_attributes
      { email: nil, description: nil, active_card: nil }
    end

    def copy_attributes
      [:email, :description]
    end

    def conversion(key, value)
      if key == 'card'
        { active_card: value.is_a?(Hash) ? card_from(value) : fake_card }
      end
    end
  end
end
