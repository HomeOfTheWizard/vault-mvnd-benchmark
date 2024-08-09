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

CMD ["mvnd"]