FROM docker.io/parrotsec/core
RUN DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get update && \
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get dist-upgrade -y && \
  # missing urh, gr-lora_sdr nrsc5
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install --no-install-recommends aircrack-ng asleap freeradius-wpe hostapd-wpe iw kismet mdk3 mdk4 pixiewps reaver wifi-honey wifite tshark wireshark termshark vim mlocate man pciutils hashcat wpasupplicant less bash-completion ssh supervisor novnc xvfb x11vnc parrot-xfce dbus-x11 dialog tmux tcpdump nmap curl gnuradio gqrx-sdr gr-osmosdr fldigi qsstv wsjtx -y && \
  # dpkg -P --force-depends xfce4-power-manager-plugins && \
  # rm -f /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml && \
  # sed -i '/power-manager-plugin/d' /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml && \
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install --no-install-recommends -y equivs && \
  equivs-control xfce4-power-manager-plugins && \
  sed -i "s/Package:.*/Package: xfce4-power-manager-plugins/" xfce4-power-manager-plugins && \
  sed -i "s/^# Version:.*/Version: 1:4.16.0-1/" xfce4-power-manager-plugins && \
  equivs-build xfce4-power-manager-plugins && \
  mv ./xfce4-power-manager-plugins_4.16.0-1_all.deb /tmp/ && \
  chmod 666 /tmp/xfce4-power-manager-plugins_4.16.0-1_all.deb && \
  apt-get install -y /tmp/xfce4-power-manager-plugins_4.16.0-1_all.deb && \
  rm /tmp/xfce4-power-manager-plugins_4.16.0-1_all.deb && \
  apt-get purge -y equivs && \
  apt-get autoremove --purge -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -f /etc/ssh/ssh_host_* && \
  cd /etc/freeradius-wpe/3.0/certs && \
  make clean && \
  cd /etc/hostapd-wpe/certs && \
  make clean

EXPOSE 22/tcp
EXPOSE 8080/tcp
ENV DISPLAY=:0

WORKDIR /root/
COPY files/wigle.words /root/wigle.words
COPY files/supervisord-debianish.conf /etc/supervisord/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord/supervisord.conf", "--pidfile", "/run/supervisord.pid"]
ENTRYPOINT []
