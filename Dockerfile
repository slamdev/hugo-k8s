FROM alpine:latest

ENV GLIBC_VERSION 2.30-r0
ENV HUGO_VERSION 0.59.1
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz

# warnings appears in log because of https://github.com/sgerrand/alpine-pkg-glibc/issues/80
RUN apk --no-cache add libstdc++ ca-certificates wget \
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
 && apk add glibc-2.30-r0.apk glibc-bin-2.30-r0.apk glibc-i18n-2.30-r0.apk \
 && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
 && rm -f glibc-* \
 && wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} \
 && tar xzf ${HUGO_BINARY} \
 && rm -r ${HUGO_BINARY} \
 && mv hugo /usr/bin \
 && apk del wget ca-certificates

VOLUME /opt/cache
VOLUME /opt/content
VOLUME /opt/destination
VOLUME /opt/source

EXPOSE 8080

ENTRYPOINT ["hugo",\
           "server",\
           "--cacheDir", "/opt/cache",\
           "--destination", "/opt/destination",\
           "--contentDir", "/opt/content",\
           "--source", "/opt/source",\
           "--minify",\
           "--bind", "0.0.0.0",\
           "--port", "8080"\
]
