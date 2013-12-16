class WebPay::Mock::FakeEntity::Base
  include WebPay::Mock::Util
  include WebPay::Mock::FakeEntity

  attr_reader :builder

  def initialize(base = {})
    @builder = WebPay::Mock::Builder.new(object_name)
      .set_from(basic_attributes)
      .set_from(base)
  end

  def set_params(params = {})
    params = stringify_keys(params)
    @builder.set_from(params, *copy_attributes)
    params.each do |k, v|
      response = conversion(k, v)
      @builder.set_from(response) if response
    end
    self
  end

  def override(overrides = {})
    @builder.set_from(overrides)
    self
  end

  def build
    @builder.build
  end
end
