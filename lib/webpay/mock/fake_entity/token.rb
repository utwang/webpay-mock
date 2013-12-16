module WebPay::Mock::FakeEntity
  class Token < Base
    def object_name
      'token'
    end

    def basic_attributes
      { card: fake_card, used: false }
    end

    def copy_attributes
      []
    end

    def conversion(key, value)
      if key == 'card'
        { card: card_from(value) }
      end
    end
  end
end
