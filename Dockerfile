FROM debian:stretch

WORKDIR /opt/src

RUN apt-get -yqq update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get -yqq --no-install-recommends install \
         wget dnsutils openssl ca-certificates kmod \
         iproute gawk grep sed net-tools iptables \
         bsdmainutils libcurl3-nss \
	 nano strongswan rsyslog ppp libpcap0.8

RUN DEBIAN_FRONTEND=noninteractive \
       apt-get -yqq --no-install-recommends install \
         ssh vim telnet curl python

RUN adduser --disabled-password --gecos "" mbvpn \
    && mkdir /home/mbvpn/.ssh \
    && chown mbvpn /home/mbvpn/.ssh \
    && chmod 700 /home/mbvpn/.ssh

COPY ./run.sh /opt/src/run.sh
RUN chmod 755 /opt/src/run.sh

COPY ./xl2tpd_1.3.11-1_amd64.deb /opt/src/xl2tpd_1.3.11-1_amd64.deb
RUN dpkg -i /opt/src/xl2tpd_1.3.11-1_amd64.deb

VOLUME ["/lib/modules"]
VOLUME ["/home/mbvpn/.ssh/authorized_keys"]

CMD ["/opt/src/run.sh"]

EXPOSE 22
