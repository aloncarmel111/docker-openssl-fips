FROM alpine:3.9 AS build

ARG OPENSSL_FIPS_VER=2.0.16
ARG OPENSSL_VER=1.0.2o
ARG OPENSSL_PGP_FINGERPRINT=D9C4D26D0E604491

ADD test_fips.c openssl-fips-${OPENSSL_FIPS_VER}.tar.gz /tmp/build/

RUN set -x; \
  cd /tmp/build \
  && apk add --no-cache zlib \
  && apk add --no-cache --virtual .build-deps \
      wget \
      gcc \
      gzip \
      tar \
      libc-dev \
      ca-certificates \
      perl \
      make \
      coreutils \
      gnupg \
      linux-headers \
      zlib-dev \
  && wget --quiet https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz \
  && wget --quiet https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz.asc \
  && gpg --recv $OPENSSL_PGP_FINGERPRINT \
  && gpg --verify openssl-$OPENSSL_VER.tar.gz.asc \
  && tar -xzf openssl-$OPENSSL_VER.tar.gz \
  && cd openssl-fips-$OPENSSL_FIPS_VER \
  && ./config \
  && make \
  && make install \
  && cd .. \
  && cd openssl-$OPENSSL_VER \
  && perl ./Configure linux-x86_64 \
    --prefix=/usr \
    --libdir=lib \
    --openssldir=/etc/ssl \
    -DOPENSSL_NO_BUF_FREELISTS \
    -Wa,--noexecstack \
    fips shared zlib enable-ec_nistp_64_gcc_128 enable-ssl2 \
  && make \
  && make INSTALL_PREFIX=/tmp/root install_sw \
  && cd ..
  && gcc test_fips.c -I/tmp/root/usr/include -L/tmp/root/usr/lib -lssl -lcrypto -otest_fips \
  && chmod +x test_fips \
  && rm -rf /tmp/build ~/.gnupg \
  && LD_LIBRARY_PATH=/tmp/root/usr/lib ./test_fips \
  && apk del .build-deps

FROM alpine:3.9
COPY --from=build /tmp/root /
