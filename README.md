# openssl-fips - Alpine Linux with FIPS 140-2 OpenSSL

`openssl-fips` combines a [base Alpine 3.9 image](https://hub.docker.com/_/alpine/) with
[FIPS 140-2 enabled OpenSSL](https://www.openssl.org/docs/fips.html).

## Disclaimer

Neither this document nor `Dockerfile` consitute legal advice.

There is no warranty for the program, to the extent permitted by applicable law. Except when otherwise stated in writing
the copyright holders and/or other parties provide the program "as is" without warranty of any kind, either expressed or
implied, including, but not limited to, the implied warranties of merchantability and fitness for a particular purpose.
The entire risk as to the quality and performance of the program is with you. Should the program prove defective, you
assume the cost of all necessary servicing, repair or correction.

In no event unless required by applicable law or agreed to in writing will any copyright holder be liable to you for
damages, including any general, special, incidental or consequential damages arising out of the use or inability to use
the program (including but not limited to loss of data or data being rendered inaccurate or losses sustained by you or
third parties or a failure of the program to operate with any other programs), even if such holder or other party has
been advised of the possibility of such damages.

## Build steps

The `Dockerfile` builds the FIPS canister per the requirements in "OpenSSL FIPS 140-2 Security Policy Version 2.0.16." 
It also verifies the SHA256 hash and PGP signature of the OpenSSL source based on OpenSSL's best practices
recommendations.

## Compliance

Use your FIPS-validated tools to validate the FIPS Module archive. Then place it in current directory prior to building
this image. According to the [Security
Policy](https://csrc.nist.gov/CSRC/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp2398.pdf)
p. 26:

> this verification can be performed on any convenient system and not necessarily on the specific build or target
system.
