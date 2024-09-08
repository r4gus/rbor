# Ruby-cBOR

The Concise Binary Object Representation (CBOR) is a data format whose 
design goals include the possibility of extremely small code size, fairly 
small message size, and extensibility without the need for version negotiation 
(RFC8949). It is used in different protocols like the Client to Authenticator 
Protocol CTAP2 which is a essential part of FIDO2 authenticators/ Passkeys.

This gem implements de-/serialization for the following Ruby classes:

- `Integer`
- `String`
- `Array`
- `Hash`
- `FalseClass`
- `TrueClass`
- `NilClass`

Furthermore, serialization adheres to the [CTAP2 canonical CBOR encoding form](https://fidoalliance.org/specs/fido-v2.0-ps-20190130/fido-client-to-authenticator-protocol-v2.0-ps-20190130.html#ctap2-canonical-cbor-encoding-form), i.e.:

- Integers are encoded as small as possible.
- The expression of lengths is encoded as small as possible.
- No support for indefinite-length items.
- Keys of Hashes/Maps are sorted lowest value to highest. Sorting rules are:
    - If the major types are different, the one with the lower value in numerical order sorts earlier.
    - If two keys have different lengths, the shorter one sorts earlier.
    - If two keys have the same length, the one with the lower value in (byte-wise) lexical order sorts earlier.

## Build

### Build gem

```bash
gem build rbor.gemspec
gem push rbor-x.y.z.gem
```

## Docs

The project uses Yard to build the documentation. You can install it using
the `gem` command.

```bash
gem install yard
```

To build the documentation run:

```
yard
```

## Testing

You can run tests with [rspec](https://rspec.info/):

```bash
rspec --format doc
```
