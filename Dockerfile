FROM ubuntu:16.04

USER root

COPY install-cs2.sh .

RUN apt-get update && \
    apt-get -y install net-tools

RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    dpkg --add-architecture i386 && \
    apt-get -q -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
      lib32gcc1 steamcmd ca-certificates gosu && \
    ln -sf /usr/games/steamcmd /usr/bin/steamcmd && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -q -y && \
    rm -rf /var/lib/apt/lists/* \
    && mkdir /root/cs2

RUN chmod +x ./install-cs2.sh \ 
    && ./install-cs2.sh

RUN cd /root/.steam \
    && mkdir sdk32 \
    && ln -s /root/.steam/steamcmd/linux32/steamclient.so /root/.steam/sdk32/

COPY start.sh .
CMD ["bash", "start.sh"]

EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27020/udp

VOLUME /cs2

# ENTRYPOINT ["tail", "-f", "/dev/null"]