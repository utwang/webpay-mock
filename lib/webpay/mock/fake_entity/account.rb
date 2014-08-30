module WebPay::Mock::FakeEntity
  class Account < Base
    def object_name
      'account'
    end

    def basic_attributes
      {
        charge_enabled: false,
        currencies_supported: ["jpy"],
        details_submitted: false,
        email: 'test@example.com',
        statement_descriptor: nil,
        card_types_supported: ["Visa", "American Express", "MasterCard", "JCB", "Diners Club"],
      }
    end

    def copy_attributes
      []
    end

    def conversion(key, value)
    end
  end
end
