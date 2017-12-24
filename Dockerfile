FROM openjdk:8-jre-alpine

ENV NRS_TYPE=nxt NRS_VERSION=1.11.10
LABEL maintainer="Alexandre Buisine <alexandrejabuisine@gmail.com>" version="${NRS_VERSION}-2"

# wget already included is deprecated in regards to TLS latest security minimals
RUN apk add --no-cache \
 wget \
 gpgme

WORKDIR /opt/nxt
RUN wget --no-check-certificate "https://bitbucket.org/Jelurida/${NRS_TYPE}/downloads/${NRS_TYPE}-client-${NRS_VERSION}.zip" \
 && wget --no-check-certificate "https://bitbucket.org/Jelurida/${NRS_TYPE}/downloads/${NRS_TYPE}-client-${NRS_VERSION}.zip.asc" \
 && gpg --keyserver pgpkeys.mit.edu --recv-key 0xC654D7FCFF18FD55 \
 && gpg --verify ${NRS_TYPE}-client-${NRS_VERSION}.zip.asc \
 && unzip ${NRS_TYPE}-client-${NRS_VERSION}.zip -d /opt \
 && rm ${NRS_TYPE}-client-${NRS_VERSION}.zip ${NRS_TYPE}-client-${NRS_VERSION}.zip.asc

ADD https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux /usr/local/bin/ep
RUN chmod +x /usr/local/bin/ep \
 && sed -i \
  -e 's/nxt.apiServerHost=.*/nxt.apiServerHost=0.0.0.0/' \
  -e 's/nxt.uiServerHost=.*/nxt.uiServerHost=0.0.0.0/' \
  -e 's/nxt.myAddress=.*/nxt.myAddress=${NRS_ADDRESS}/' \
  -e 's/nxt.myPlatform=.*/nxt.myPlatform=${NRS_PLATFORM}/' \
  -e 's/nxt.myHallmark=.*/nxt.myHallmark=${NRS_HALLMARK}/' \
  -e 's/nxt.allowedBotHosts=.*/nxt.allowedBotHosts=${NRS_ALLOWED_BOT_HOSTS}/' \
  -e 's/nxt.allowedUserHosts=.*/nxt.allowedUserHosts=${NRS_ALLOWED_USER_HOSTS}/' \
  -e 's/nxt.adminPassword=.*/nxt.adminPassword=${NRS_ADMIN_PASSWORD}/' \
  conf/nxt-default.properties

ENV NRS_PLATFORM="Linux amd64" \
 NRS_ADDRESS= \
 NRS_HALLMARK= \
 NRS_ALLOWED_BOT_HOSTS="127.0.0.1; localhost; [0:0:0:0:0:0:0:1];" \
 NRS_ALLOWED_USER_HOSTS="127.0.0.1; localhost; [0:0:0:0:0:0:0:1];" \
 NRS_ADMIN_PASSWORD=

VOLUME /opt/nxt/nxt_db
EXPOSE 7874 7876

ENTRYPOINT ["/usr/local/bin/ep", "-v", "/opt/nxt/conf/nxt-default.properties", "--"]
CMD java -cp classes:lib/*:conf:addons/classes:addons/lib/* nxt.Nxt