module WebPay::Mock::FakeEntity
  class Account < Base
    def object_name
      'account'
    end

    def basic_attributes
      { statement_descriptor: nil, details_submitted: false, charge_enabled: false, currencies_supported: ["jpy"], email: 'test@example.com' }
    end

    def copy_attributes
      []
    end

    def conversion(key, value)
    end
  end
end
