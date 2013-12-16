module WebPay::Mock::Util
  def stringify_keys(hash)
    Hash[hash.map { |k, v| [k.to_s, v] }]
  end
end
