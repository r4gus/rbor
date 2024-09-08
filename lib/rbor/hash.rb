class Hash

  # Serialize a Hash into a CBOR map.
  #
  # @author David P. Sugar (r4gus)
  # @return [String] the object serialized to CBOR.
  def cbor_serialize(options = {})
    len = self.length.cbor_serialize.bytes
    len[0] |= 5 << 5
    out = len.pack('C*')
    tmp = self.sort do |a, b| 
      if a[0].is_a? Integer and b[0].is_a? Integer
        if a[0] >= 0 and b[0] >= 0 or a[0] < 0 and b[0] < 0
          a[0] <=> b[0]
        elsif a[0] >= 0
          -1
        else 
          1
        end
      elsif a[0].is_a? Integer and b[0].is_a? String
        -1
      elsif a[0].is_a? String and b[0].is_a? Integer
        1
      elsif a[0].is_a? String and b[0].is_a? String
        a[0] <=> b[0]
      else
        0
      end
    end
    tmp.each do |k, v|
      out += k.cbor_serialize
      out += v.cbor_serialize
    end
    return out
  end
end
