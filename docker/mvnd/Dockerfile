FROM ubuntu:24.10

RUN apt-get update && apt-get install -y wget unzip curl

ARG MVND_VERSION=1.0.1

ARG MVND_DOWNLOAD_URL=https://downloads.apache.org/maven/mvnd/${MVND_VERSION}/maven-mvnd-${MVND_VERSION}-linux-amd64.zip

RUN curl -fsSL -o mvnd.zip ${MVND_DOWNLOAD_URL}

RUN mkdir -p /tmp/zip \
    && unzip mvnd.zip -d /tmp/zip \
    && mv /tmp/zip/`ls /tmp/zip | head -n 1` /tmp/mvnd

RUN rm -rf /var/cache/apt/* && rm -rf /tmp/zip

FROM openjdk:21-jdk AS jdk21

COPY --from=0 /tmp/mvnd /usr/local/mvnd

ENV MVND_HOME=/usr/local/mvnd

ENV PATH=.:$MVND_HOME/bin:$PATH

RUN microdnf install procps

ENTRYPOINT /usr/java/openjdk-21/bin/java -classpath /usr/local/mvnd/mvn/boot/plexus-classworlds-2.8.0.jar \
    -javaagent:/usr/local/mvnd/mvn/lib/mvnd/mvnd-agent-1.0.1.jar \
    -Dmvnd.home=/usr/local/mvnd -Dmaven.home=/usr/local/mvnd/mvn \
    -Dmaven.conf=/usr/local/mvnd/mvn/conf -Dclassworlds.conf=/usr/local/mvnd/bin/mvnd-daemon.conf \
    -Dorg.slf4j.simpleLogger.logFile=/root/.m2/mvnd/registry/1.0.1/daemon-cd850559.log -Dmvnd.java.home=/usr/java/openjdk-21 \
    -Dmvnd.id=cd850559 -Dmvnd.daemonStorage=/root/.m2/mvnd/registry/1.0.1 -Dmvnd.registry=/root/.m2/mvnd/registry/1.0.1/registry.bin \
    -Dmvnd.socketFamily=inet -Dmvnd.home=/usr/local/mvnd \
    -Djdk.java.options="--add-opens java.base/java.io=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.jar=ALL-UNNAMED --add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
    -Dmvnd.noDaemon=false -Dmvnd.debug=false -Dmvnd.debug.address=8000 -Dmvnd.idleTimeout=3h -Dmvnd.keepAlive=100ms \
    -Dmvnd.extClasspath= -Dmvnd.coreExtensions= -Dmvnd.enableAssertions=false -Dmvnd.expirationCheckDelay=10s \
    -Dmvnd.duplicateDaemonGracePeriod=10s -Dmvnd.socketFamily=inet \
    org.codehaus.plexus.classworlds.launcher.Launcher