FROM debian:stretch

WORKDIR /opt/src

RUN apt-get -yqq update \
    && DEBIAN_FRONTEND=noninteractive \
      apt-get -yqq --no-install-recommends install \
        wget dnsutils openssl ca-certificates kmod \
        iproute gawk grep sed net-tools iptables \
        bsdmainutils libcurl3-nss \
	      strongswan rsyslog ppp libpcap0.8

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq --no-install-recommends install \
      ssh vim telnet curl python sudo

RUN adduser --disabled-password --gecos "" uvpn \
    && mkdir /home/uvpn/.ssh \
    && chown uvpn /home/uvpn/.ssh \
    && chmod 700 /home/uvpn/.ssh \
    && echo "/home/uvpn/.on_logout" >>  /home/uvpn/.bash_logout

COPY .ssh_rc /home/uvpn/.ssh/rc
COPY .on_logout /home/uvpn/.on_logout
RUN chmod 755 /home/uvpn/.on_logout /home/uvpn/.ssh/rc

COPY sudo_vpn /etc/sudoers.d/sudo_vpn
COPY vpn_up /opt/src/vpn_up
COPY vpn_down /opt/src/vpn_down
COPY ./run.sh /opt/src/run.sh
RUN chmod 755 /opt/src/run.sh /etc/sudoers.d/sudo_vpn /opt/src/vpn_up /opt/src/vpn_down

COPY ./xl2tpd_1.3.11-1_amd64.deb /opt/src/xl2tpd_1.3.11-1_amd64.deb
RUN dpkg -i /opt/src/xl2tpd_1.3.11-1_amd64.deb

VOLUME ["/lib/modules"]
VOLUME ["/home/uvpn/.ssh/authorized_keys"]

CMD ["/opt/src/run.sh"]

EXPOSE 22
