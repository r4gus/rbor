# The Concise Binary Object Representation (CBOR) is a data format whose 
# design goals include the possibility of extremely small code size, fairly 
# small message size, and extensibility without the need for version negotiation 
# (RFC8949). It is used in different protocols like the Client to Authenticator 
# Protocol CTAP2 which is a essential part of FIDO2 authenticators/ Passkeys.

module Cbor

end

require_relative 'rbor/integer.rb'
require_relative 'rbor/string.rb'
require_relative 'rbor/array.rb'
require_relative 'rbor/hash.rb'
require_relative 'rbor/bool.rb'
require_relative 'rbor/streaming.rb'
