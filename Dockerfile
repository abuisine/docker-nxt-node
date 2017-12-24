FROM openjdk:8-jre-alpine

ENV NRS_PLATFORM=nxt NRS_VERSION=1.11.10
LABEL maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>" version="${NRS_VERSION}-1"

# wget already included is deprecated in regards to TLS latest security minimals
RUN apk add --no-cache \
 wget \
 gpgme

WORKDIR /opt/nxt
RUN wget --no-check-certificate "https://bitbucket.org/Jelurida/${NRS_PLATFORM}/downloads/${NRS_PLATFORM}-client-${NRS_VERSION}.zip" \
 && wget --no-check-certificate "https://bitbucket.org/Jelurida/${NRS_PLATFORM}/downloads/${NRS_PLATFORM}-client-${NRS_VERSION}.zip.asc" \
 && gpg --keyserver pgpkeys.mit.edu --recv-key 0xC654D7FCFF18FD55 \
 && gpg --verify ${NRS_PLATFORM}-client-${NRS_VERSION}.zip.asc \
 && unzip ${NRS_PLATFORM}-client-${NRS_VERSION}.zip -d /opt \
 && rm ${NRS_PLATFORM}-client-${NRS_VERSION}.zip ${NRS_PLATFORM}-client-${NRS_VERSION}.zip.asc

VOLUME /opt/nxt/nxt_db
EXPOSE 7874 7876

CMD java -cp classes:lib/*:conf:addons/classes:addons/lib/* nxt.Nxt