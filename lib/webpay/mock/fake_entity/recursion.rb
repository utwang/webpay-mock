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
        next_executed: Time.now.to_i + 60 * 60 * 24 * 30,
        status: 'active'
      }
    end

    def copy_attributes
      [:amount, :currency, :customer, :description]
    end

    def conversion(key, value)
      case key
      when 'period'
        if value == 'year' && builder.hash['last_executed']
          {
            next_executed: (Time.now.to_i + 60 * 60 * 24 * 365)
          }
        end
      when 'first_scheduled'
        if value.to_i > Time.now.to_i
          {
            last_executed: nil,
            next_executed: value
          }
        end
      end
    end
  end
end
