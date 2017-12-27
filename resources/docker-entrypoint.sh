#!/bin/sh
set -eo pipefail

NRS_PLATFORM="Linux amd64"

echo "nxt.apiServerHost=0.0.0.0" > conf/nxt.properties
echo "nxt.uiServerHost=0.0.0.0" >> conf/nxt.properties
PLATFORM_OS=`uname -o` PLATFORM_ARCH=`uname -m` echo "nxt.myPlatform=${PLATFORM_OS} ${PLATFORM_ARCH}" >> conf/nxt.properties

echo "nxt.myAddress=${NRS_ADDRESS}" >> conf/nxt.properties
echo "nxt.myHallmark=${NRS_HALLMARK}" >> conf/nxt.properties
echo "nxt.adminPassword=${NRS_ADMIN_PASSWORD}" >> conf/nxt.properties
echo "nxt.allowedBotHosts=${NRS_ALLOWED_BOT_HOSTS}" >> conf/nxt.properties
echo "nxt.allowedUserHosts=${NRS_ALLOWED_USER_HOSTS}" >> conf/nxt.properties
echo "nxt.maxNumberOfInboundConnections=${NRS_MAX_INBOUND}" >> conf/nxt.properties
echo "nxt.maxNumberOfOutboundConnections=${NRS_MAX_OUTBOUND}" >> conf/nxt.properties
echo "nxt.maxNumberOfConnectedPublicPeers=${NRS_MAX_PUBLIC_PEERS}" >> conf/nxt.properties

exec "$@"