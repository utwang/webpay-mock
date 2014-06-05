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
        last_executed: nil,
        next_scheduled: Time.now.to_i,
        status: 'active'
      }
    end

    def copy_attributes
      [:amount, :currency, :customer, :description]
    end

    def conversion(key, value)
      case key
      when 'first_scheduled'
        if value
          {
            next_scheduled: value
          }
        end
      end
    end
  end
end
