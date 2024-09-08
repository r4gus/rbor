class String

  # Treat the object as CBOR `BINARY` data and deserialize it into a Ruby object.
  # 
  # Depending on the major type of the CBOR data, this method will return
  # a object of one of the following types:
  # - major type 0: Integer
  # - major type 1: Integer
  # - major type 2: String
  # - major type 3: String
  # - major type 4: Array
  # - major type 5: Hash
  # - major type 7: FalseClass, TrueClass, NilClass
  #
  # @author David P. Sugar (r4gus)
  def cbor_deserialize
    return self.bytes.cbor_deserialize
  end
  
  # Serialize a String into a CBOR string.
  #
  # If the `encoding` is of type `UTF-8`, the object will be serialized
  # to a text string (major type 3). Otherwise, the obejct will be
  # serialized to a byte string (major type 2).
  #
  # @author David P. Sugar (r4gus)
  # @param options [Hash] the serialization options.
  # @return [String] the object serialized to CBOR.
  def cbor_serialize(options = {})
    len = self.bytesize.cbor_serialize.bytes
    mt = 2
    if self.encoding.to_s == "UTF-8"
      mt = 3
    end
    len[0] = mt << 5 | len[0]
    return len.pack('C*') + String.new(self, encoding: "BINARY")
  end
end
