Gem::Specification.new do |s|
  s.name        = "rbor"
  s.version     = "0.1.0"
  s.summary     = "Concise Binary Object Representation"
  s.description = "The Concise Binary Object Representation (CBOR) is a data format whose design goals include the possibility of extremely small code size, fairly small message size, and extensibility without the need for version negotiation (RFC8949). It is used in different protocols like the Client to Authenticator Protocol CTAP2 which is a essential part of FIDO2 authenticators/ Passkeys."
  s.authors     = ["David P. Sugar"]
  s.email       = "david@thesugar.de"
  s.files       = ["lib/rbor.rb", "lib/rbor/integer.rb", "lib/rbor/string.rb", "lib/rbor/array.rb", "lib/rbor/bool.rb", "lib/rbor/hash.rb"]
  s.homepage    =
    "https://rubygems.org/gems/rbor"
  s.license       = "MIT"
end
