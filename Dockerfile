FROM openjdk:8-jre-alpine

ARG NRS_TYPE=nxt
ARG NRS_VERSION=1.11.11
LABEL maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>" nrs_type="${NRS_TYPE}" nrs_version="${NRS_VERSION}"

# wget already included is deprecated in regards to TLS latest security minimals
RUN apk add --no-cache \
 wget \
 gpgme

WORKDIR /opt/${NRS_TYPE}
COPY resources/docker-entrypoint.sh resources/import-letsencrypt-java.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/import-letsencrypt-java.sh \
 && wget --no-check-certificate "https://bitbucket.org/Jelurida/${NRS_TYPE}/downloads/${NRS_TYPE}-client-${NRS_VERSION}.zip" \
 && wget --no-check-certificate "https://bitbucket.org/Jelurida/${NRS_TYPE}/downloads/${NRS_TYPE}-client-${NRS_VERSION}.zip.asc" \
 && gpg --keyserver pgpkeys.mit.edu --recv-key 0xC654D7FCFF18FD55 \
 && gpg --verify ${NRS_TYPE}-client-${NRS_VERSION}.zip.asc \
 && unzip ${NRS_TYPE}-client-${NRS_VERSION}.zip -d /opt \
 && rm ${NRS_TYPE}-client-${NRS_VERSION}.zip ${NRS_TYPE}-client-${NRS_VERSION}.zip.asc

# install let'sencrypt CA
RUN /usr/local/bin/import-letsencrypt-java.sh

ENV NRS_ADDRESS= \
 NRS_HALLMARK= \
 NRS_ALLOWED_BOT_HOSTS=* \
 NRS_ALLOWED_USER_HOSTS=* \
 NRS_ADMIN_PASSWORD= \
 NRS_MAX_INBOUND=250 \
 NRS_MAX_OUTBOUND=50 \
 NRS_MAX_PUBLIC_PEERS=20

VOLUME /opt/${NRS_TYPE}/nxt_db
VOLUME /opt/${NRS_TYPE}/nxt_test_db
EXPOSE 6874 6876 7874 7876 26874 26876 27874 27876


ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD java -cp classes:lib/*:conf:addons/classes:addons/lib/* nxt.Nxt