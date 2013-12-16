module WebPay::Mock::FakeEntity
  class Card < Base
    def object_name
      'card'
    end

    def basic_attributes
      { exp_year: 2014,
        exp_month: 11,
        fingerprint: fake_fingerprint,
        name: "KEI KUBO",
        country: "JP",
        type: "Visa",
        cvc_check: "pass",
        last4: "4242" }
    end

    def copy_attributes
      [:exp_month, :exp_year, :name]
    end

    def conversion(key, value)
      case key
      when 'number'
        { last4: value[-4..-1] }
      end
    end
  end
end
