module WebPay::Mock::FakeEntity
  class Event < Base
    def object_name
      'event'
    end

    def basic_attributes
      { data: {'object' => Charge.new.build}, pending_webhooks: 0, type: 'charge.created' }
    end

    def copy_attributes
      []
    end

    def conversion(key, value)
    end
  end
end
