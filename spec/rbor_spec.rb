require 'rbor'

RSpec.describe Cbor, "serialize" do
  context "with an Integer" do
    it "serializes unsigned integers" do
      expect(0.cbor_serialize).to eq "\x00"
      expect(1.cbor_serialize).to eq "\x01"
      expect(10.cbor_serialize).to eq "\x0a"
      expect(23.cbor_serialize).to eq "\x17"
      expect(24.cbor_serialize).to eq "\x18\x18"
      expect(25.cbor_serialize).to eq "\x18\x19"
      expect(100.cbor_serialize).to eq "\x18\x64"
      expect(1000.cbor_serialize).to eq String.new("\x19\x03\xe8", encoding: "BINARY")
      expect(1000000.cbor_serialize).to eq String.new("\x1a\x00\x0f\x42\x40", encoding: "BINARY")
      expect(1000000000000.cbor_serialize).to eq String.new("\x1b\x00\x00\x00\xe8\xd4\xa5\x10\x00", encoding: "BINARY")
      expect(18446744073709551615.cbor_serialize).to eq String.new("\x1b\xff\xff\xff\xff\xff\xff\xff\xff", encoding: "BINARY")
    end 

    it "serializes negative integers" do
      expect(-1.cbor_serialize).to eq String.new("\x20", encoding: "BINARY")
      expect(-18446744073709551616.cbor_serialize).to eq String.new("\x3b\xff\xff\xff\xff\xff\xff\xff\xff", encoding: "BINARY")
      expect(-10.cbor_serialize).to eq String.new("\x29", encoding: "BINARY")
      expect(-100.cbor_serialize).to eq String.new("\x38\x63", encoding: "BINARY")
      expect(-1000.cbor_serialize).to eq String.new("\x39\x03\xe7", encoding: "BINARY")
    end
  end

  context "with a String" do
    it "serializes UTF-8 Strings as CBOR text strings" do
      expect("".cbor_serialize).to eq String.new("\x60", encoding: "BINARY")
      expect("a".cbor_serialize).to eq String.new("\x61\x61", encoding: "BINARY")
      expect("IETF".cbor_serialize).to eq String.new("\x64\x49\x45\x54\x46", encoding: "BINARY")
      expect("\"\\".cbor_serialize).to eq String.new("\x62\x22\x5c", encoding: "BINARY")
      expect("\u00fc".cbor_serialize).to eq String.new("\x62\xc3\xbc", encoding: "BINARY")
      expect("\u6c34".cbor_serialize).to eq String.new("\x63\xe6\xb0\xb4", encoding: "BINARY")
    end

    it "serializes BINARY Strings as CBOR binary strings" do
      expect(String.new("", encoding: "BINARY").cbor_serialize).to eq String.new("\x40", encoding: "BINARY")
      expect(String.new("\x01\x02\x03\x04", encoding: "BINARY").cbor_serialize).to eq String.new("\x44\x01\x02\x03\x04", encoding: "BINARY")
    end
  end

  context "with a Array" do
    it "serializes to a CBOR array" do
      expect([].cbor_serialize).to eq String.new("\x80", encoding: "BINARY")
      expect([1, 2, 3].cbor_serialize).to eq String.new("\x83\x01\x02\x03", encoding: "BINARY")
      expect([1, [2, 3], [4, 5]].cbor_serialize).to eq String.new("\x83\x01\x82\x02\x03\x82\x04\x05", encoding: "BINARY")
      expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25].cbor_serialize).to eq String.new("\x98\x19\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x18\x18\x19", encoding: "BINARY")
    end
  end

  context "with a Hash" do
    it "serializes to a CBOR map" do
      expect({}.cbor_serialize).to eq String.new("\xa0", encoding: "BINARY")
      expect({1 => 2, 3 => 4}.cbor_serialize).to eq String.new("\xa2\x01\x02\x03\x04", encoding: "BINARY")
      expect({"a" => 1, "b" => [2, 3]}.cbor_serialize).to eq String.new("\xa2\x61\x61\x01\x61\x62\x82\x02\x03", encoding: "BINARY")
      expect(["a", {"b" => "c"}].cbor_serialize).to eq String.new("\x82\x61\x61\xa1\x61\x62\x61\x63", encoding: "BINARY")
      expect({"a" => "A", "b" => "B", "c" => "C", "d" => "D", "e" => "E"}.cbor_serialize).to eq String.new("\xa5\x61\x61\x61\x41\x61\x62\x61\x42\x61\x63\x61\x43\x61\x64\x61\x44\x61\x65\x61\x45", encoding: "BINARY")
    end

    it "sorts keys in the right order" do
      expect({"e" => "E", "b" => "B", "c" => "C", "a" => "A", "d" => "D"}.cbor_serialize).to eq String.new("\xa5\x61\x61\x61\x41\x61\x62\x61\x42\x61\x63\x61\x43\x61\x64\x61\x44\x61\x65\x61\x45", encoding: "BINARY")
      expect({"b" => [2, 3], "a" => 1}.cbor_serialize).to eq String.new("\xa2\x61\x61\x01\x61\x62\x82\x02\x03", encoding: "BINARY")
      expect({1 => 2, "hello" => "c", "hell" => [1, 2], 3 => 4}.cbor_serialize).to eq String.new("\xA4\x01\x02\x03\x04\x64\x68\x65\x6C\x6C\x82\x01\x02\x65\x68\x65\x6C\x6C\x6F\x61\x63", encoding: "BINARY")
    end
  end

  context "with a FalseClass, TrueClass, or NilClass" do
    it "serializes to a CBOR simple value" do
      expect(false.cbor_serialize).to eq String.new("\xf4", encoding: "BINARY")
      expect(true.cbor_serialize).to eq String.new("\xf5", encoding: "BINARY")
      expect(nil.cbor_serialize).to eq String.new("\xf6", encoding: "BINARY")
    end
  end
end

RSpec.describe Cbor, "deserialize" do
  context "with an Integer" do
    it "deserializes unsigned integers" do
      expect("\x00".cbor_deserialize).to eq [0, []]
      expect("\x01".cbor_deserialize).to eq [1, []]
      expect("\x0a".cbor_deserialize).to eq [10, []]
      expect("\x17".cbor_deserialize).to eq [23, []]
      expect("\x18\x18".cbor_deserialize).to eq [24, []]
      expect("\x18\x19".cbor_deserialize).to eq [25, []]
      expect("\x18\x64".cbor_deserialize).to eq [100, []]
      expect("\x19\x03\xe8".cbor_deserialize).to eq [1000, []]
      expect("\x1a\x00\x0f\x42\x40".cbor_deserialize).to eq [1000000, []]
      expect("\x1b\x00\x00\x00\xe8\xd4\xa5\x10\x00".cbor_deserialize).to eq [1000000000000, []]
      expect("\x1b\xff\xff\xff\xff\xff\xff\xff\xff".cbor_deserialize).to eq [18446744073709551615, []]
    end 

    it "deserializes negative integers" do
      expect("\x20".cbor_deserialize).to eq [-1, []]
      expect("\x3b\xff\xff\xff\xff\xff\xff\xff\xff".cbor_deserialize).to eq [-18446744073709551616, []]
      expect("\x29".cbor_deserialize).to eq [-10, []]
      expect("\x38\x63".cbor_deserialize).to eq [-100, []]
      expect("\x39\x03\xe7".cbor_deserialize).to eq [-1000, []]
    end
  end

  context "with a String" do
    it "deserializes a CBOR text string into a UTF-8 String" do
      expect("\x60".cbor_deserialize).to eq [String.new("", encoding: "UTF-8"), []]
      expect("\x61\x61".cbor_deserialize).to eq [String.new("a", encoding: "UTF-8"), []]
      expect("\x64\x49\x45\x54\x46".cbor_deserialize).to eq [String.new("IETF", encoding: "UTF-8"), []]
      expect("\x62\x22\x5c".cbor_deserialize).to eq [String.new("\"\\", encoding: "UTF-8"), []]
      expect("\x63\xe6\xb0\xb4".cbor_deserialize).to eq [String.new("\u6c34", encoding: "UTF-8"), []]
    end

    it "deserializes a CBOR byte string into a BINARY String" do
      expect("\x40".cbor_deserialize).to eq [String.new("", encoding: "BINARY"), []]
      expect("\x44\x01\x02\x03\x04".cbor_deserialize).to eq [String.new("\x01\x02\x03\x04", encoding: "BINARY"), []]
    end
  end

  context "with a CBOR array" do
    it "deserializes to a Array" do
      expect("\x80".cbor_deserialize).to eq [[], []]
      expect("\x83\x01\x02\x03".cbor_deserialize).to eq [[1, 2, 3], []]
      expect("\x83\x01\x82\x02\x03\x82\x04\x05".cbor_deserialize).to eq [[1, [2, 3], [4, 5]], []]
      expect("\x98\x19\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x18\x18\x19".cbor_deserialize).to eq [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], []]
    end
  end

  context "with a CBOR map" do
    it "deserializes to a Hash" do
      expect("\xa0".cbor_deserialize).to eq [{}, []]
      expect("\xa2\x01\x02\x03\x04".cbor_deserialize).to eq [{1 => 2, 3 => 4}, []]
      expect("\xa2\x61\x61\x01\x61\x62\x82\x02\x03".cbor_deserialize).to eq [{"a" => 1, "b" => [2, 3]}, []]
      expect("\x82\x61\x61\xa1\x61\x62\x61\x63".cbor_deserialize).to eq [["a", {"b" => "c"}], []]
      expect("\xa5\x61\x61\x61\x41\x61\x62\x61\x42\x61\x63\x61\x43\x61\x64\x61\x44\x61\x65\x61\x45".cbor_deserialize).to eq [{"a" => "A", "b" => "B", "c" => "C", "d" => "D", "e" => "E"}, []]
    end
  end

  context "with a simple value" do
    it "serializes to true, false or nil" do
      expect("\xf4".cbor_deserialize).to eq [false, []]
      expect("\xf5".cbor_deserialize).to eq [true, []]
      expect("\xf6".cbor_deserialize).to eq [nil, []]
    end
  end
end
