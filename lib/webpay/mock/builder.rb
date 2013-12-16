class WebPay::Mock::Builder
  include WebPay::Mock::Util
  PREFIX = {
    charge: 'ch',
    customer: 'cus',
    token: 'tok',
    event: 'evt',
    account: 'acct'
  }.freeze
  ID_LETTERS = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

  attr_reader :hash

  def initialize(object)
    @hash = {}
    @hash['object'] = object.to_s
    return if @hash['object'] == 'card'
    @hash['id'] = PREFIX[object.to_sym] + '_' + 15.times.map { ID_LETTERS[rand(ID_LETTERS.length)] }.join
    return if @hash['object'] == 'account'
    @hash['livemode'] = false
    @hash['created'] = Time.now.to_i
  end

  def []=(key, value)
    @hash[key.to_s] = value
  end

  def set_from(hash, *allowed_keys)
    allowed_string_keys = allowed_keys.map(&:to_s)
    hash.each do |k, v|
      @hash[k.to_s] = v if allowed_string_keys.empty? || allowed_string_keys.include?(k.to_s)
    end
    self
  end

  def build
    stringify_keys(@hash)
  end
end
