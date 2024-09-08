class Array

  # Serialize an Array into a CBOR array.
  #
  # @author David P. Sugar (r4gus)
  # @return [String] the object serialized to CBOR.
  def cbor_serialize(options = {})
    len = self.length.cbor_serialize.bytes
    len[0] |= 4 << 5
    out = len.pack('C*')
    self.each do |elem|
      out += elem.cbor_serialize
    end
    return out
  end

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
    raise "empty" if self.empty?
    case self[0]
    when 0x00..0x3b
      v = nil 
    
      case self[0] & 0x1f
      when 0x00..0x17
        v = self[0] & 0x1f, self[1..]
      when 0x18
        v = self[1], self[2..]
      when 0x19
        v = self[1..2].pack("C*").unpack("S>")[0], self[3..]
      when 0x1a
        v = self[1..4].pack("C*").unpack("L>")[0], self[5..]
      when 0x1b
        v = self[1..8].pack("C*").unpack("Q>")[0], self[9..]
      else
        raise "invalid additional information"
      end

      if self[0] & 1 << 5 != 0
        v[0] = -v[0] - 1
      end

      return v
    when 0x40..0x5b
      old = self[0] & 0b11100000
      self[0] &= 0x1f
      len, rem = self.cbor_deserialize
      self[0] |= old
      return String.new(rem[0..len - 1].pack('C*'), encoding: "BINARY"), rem[len..]
    when 0x60..0x7b
      old = self[0] & 0b11100000
      self[0] &= 0x1f
      len, rem = self.cbor_deserialize
      self[0] |= old
      return String.new(rem[0..len - 1].pack('C*'), encoding: "UTF-8"), rem[len..]
    when 0x80..0x9b
      old = self[0] & 0b11100000
      self[0] &= 0x1f
      len, rem = self.cbor_deserialize
      self[0] |= old
      out = []
      len.times do |n|
        obj, rem = rem.cbor_deserialize
        out.append obj
      end
      return out, rem
    when 0xa0..0xbb
      old = self[0] & 0b11100000
      self[0] &= 0x1f
      len, rem = self.cbor_deserialize
      self[0] |= old
      out = {}
      len.times do |n|
        k, rem = rem.cbor_deserialize
        v, rem = rem.cbor_deserialize
        out[k] = v
      end
      return out, rem
    when 0xf4
      return false, self[1..]
    when 0xf5
      return true, self[1..]
    when 0xf6
      return nil, self[1..]
    else
      raise "undefined major type"
    end
  end
end
