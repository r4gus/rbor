module Cbor
  def self.cbor_streaming_read
    raw = [yield]
    case raw[0]
    when 0x18, 0x38, 0x58, 0x78, 0x98, 0xb8
      raw.append yield
    when 0x19, 0x39, 0x59, 0x79, 0x99, 0xb9
      2.times { raw.append yield } 
    when 0x1a, 0x3a, 0x5a, 0x7a, 0x9a, 0xba
      4.times { raw.append yield } 
    when 0x1b, 0x3b, 0x5b, 0x7b, 0x9b, 0xbb
      8.times { raw.append yield } 
    when 0xf4
      return false
    when 0xf5
      return true
    when 0xf6
      return nil
    end
    
    case raw[0]
    when 0x00..0x1b, 0x20..0x3b
      return raw.cbor_deserialize
    when 0x40..0x5b
      raw[0] &= 0x1f
      data = []
      len, rem = raw.cbor_deserialize
      len.times { data.append yield } 
      return String.new(data.pack('C*'), encoding: "BINARY")
    when 0x60..0x7b
      raw[0] &= 0x1f
      data = []
      len, rem = raw.cbor_deserialize
      len.times { data.append yield } 
      return String.new(data.pack('C*'), encoding: "UTF-8")
    when 0x80..0x9b
      raw[0] &= 0x1f
      data = []
      len, rem = raw.cbor_deserialize
      len.times do
        data.append cbor_streaming_read { yield }
      end
      return data
    when 0xa0..0xbb
      raw[0] &= 0x1f
      data = {}
      len, rem = raw.cbor_deserialize
      len.times do
        k = cbor_streaming_read { yield }
        v = cbor_streaming_read { yield }
        data[k] = v
      end
      return data
    else
      raise "unsupported data item"
    end
    
  end
end

class File
  def cbor_deserialize
    Cbor.cbor_streaming_read { self.readbyte }
  end
end
