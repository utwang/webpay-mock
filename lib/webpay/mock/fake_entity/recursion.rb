module WebPay::Mock::FakeEntity
  class Recursion < Base
    def object_name
      'recursion'
    end

    def basic_attributes
      {
        amount: 400,
        currency: 'jpy',
        period: 'month',
        customer: 'cus_XXXXXXXXX',
        last_executed: Time.now.to_i,
        next_scheduled: Time.now.to_i + 30 * 24 * 60 * 60,
        status: 'active'
      }
    end

    def copy_attributes
      [:amount, :currency, :customer, :description, :period]
    end

    def conversion(key, value)
      case key
      when 'first_scheduled'
        if value
          {
            last_executed: nil,
            next_scheduled: value
          }
        end
      end
    end
  end
end
