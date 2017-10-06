# CLD3 Python bindings
These are Python bindings for [cld3](https://github.com/Google/cld3), a
language classifying library used in Google Chrome.

Included are Python bindings (via Cython). Building the extension does not
require the chromium repository, instead only these libraries need to
be installed:

- Cython
- Protobuf (with headers and protoc)

To install the extension, just run `pip install` on the repository URL, or use
`pip install cld3`.
