class Integer

  # Serialize an Integer into a CBOR string.
  #
  # @author David P. Sugar (r4gus)
  # @return [String] the object serialized to CBOR.
  def cbor_serialize
    v = self
    mt = 0

    if v < 0 and v >= -2**64
      v = -1 - v
      mt = 1
    end

    case v
    when 0x00..0x17
      return [mt << 5 | v].pack('C')
    when 0x18..0xff
      return [mt << 5 | 24, v].pack('C*')
    when 0x0100..0xffff
      return [mt << 5 | 0x19].pack('C') + [v].pack("S>")
    when 0x00010000..0xffffffff
      return [mt << 5 | 0x1a].pack('C') + [v].pack("L>")
    when 0x0000000100000000..0xffffffffffffffff
      return [mt << 5 | 0x1b].pack('C') + [v].pack("Q>")
    end
  end
end
