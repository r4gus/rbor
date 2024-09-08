class FalseClass

  # Serialize false into a CBOR string.
  #
  # @author David P. Sugar (r4gus)
  # @return [String] the object serialized to CBOR.
  def cbor_serialize
    return String.new("\xf4", encoding: "BINARY")
  end
end

class TrueClass

  # Serialize true into a CBOR string.
  #
  # @author David P. Sugar (r4gus)
  # @return [String] the object serialized to CBOR.
  def cbor_serialize
    return String.new("\xf5", encoding: "BINARY")
  end
end

class NilClass

  # Serialize nil into a CBOR string.
  #
  # @author David P. Sugar (r4gus)
  # @return [String] the object serialized to CBOR.
  def cbor_serialize
    return String.new("\xf6", encoding: "BINARY")
  end
end
