#!/bin/bash
if [[ "$EUID" -ne 0 ]]; then
	echo "This installer needs to be run with superuser privileges."
	exit
fi

#-- Clean up installation mess -------------------------------------------------------------------#
USER="$(grep "user-setup: Adding user" /var/log/installer/syslog|head -n1|awk '{print $7}'|sed "s/[\'\`]//g")"
userdel -rf ${USER}

#-- Prepare system -------------------------------------------------------------------------------#
apt -y purge openssh*

apt-get -yq update;
apt-get -yq upgrade;
apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common sudo -qy;
apt -qy install sysvinit-core sysvinit-utils inetutils-syslogd dropbear;

	# Enable net.ipv4.ip_forward for the system
		echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/30-route48-forward.conf
	# Enable net.ipv6.conf.all.forwarding for the system
		echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/30-route48-forward.conf
	# Enable net.ipv6.conf.all.forwarding for the system
		echo "net.ipv6.conf.all.accept_ra=2" >> /etc/sysctl.d/30-route48-ra.conf
	
apt-get update -yq && \
apt-get -yq install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  htop \
  iftop \
  vnstat \
  sudo \
  vnstat \
  curl \
  git \
  nano \
  wget \
  bird \
  figlet \
  jq \
  lolcat \
  wireguard \
  python3-pip \
  snmpd && \
  apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
  
 cd /opt/;
 git clone https://github.com/Cloudie-Networks/R48.git
 git clone https://github.com/busyloop/lolcat.git
 cd lolcat/bin && gem install lolcat;
 pip3 install flask;
 cd /opt;

 
 mkdir -p /root/.ssh;
 cat /opt/R48/root/root/.ssh/authorized_keys >> /root/.ssh/authorized_keys;
 chmod 0600 /root/.ssh
 chmod 0600 /root/.ssh/authorized_keys
 
 cat /opt/R48/root/root/.bash_profile >> /root/.bash_profile;
 
 mv /opt/R48/root/root/opt/route48/ /opt/route48/;
 chmod +x /opt/R48/root/root/usr/bin/*;
 mv /opt/R48/root/root/usr/bin/ /usr/bin/;
 mv /opt/R48/root/root/var/lib/zerotier-one/local.conf /var/lib/zerotier-one/local.conf;
 rm -rf /opt/R48;
 rm -rf /opt/lolcat;
 
 rm -rf /etc/bird/bird.conf;
 rm -rf /etc/bird/bird6.conf;
 ln -s /opt/route48/bird/bird.conf /etc/bird/bird.conf
 ln -s /opt/route48/bird/bird6.conf /etc/bird/bird6.conf
 
 #Install ZeroTier
curl -L -o /tmp/zerotier-install.sh https://install.zerotier.com/ && \
	bash /tmp/zerotier-install.sh || exit 0
	
/usr/sbin/zerotier-cli join ;
/usr/sbin/zerotier-cli set allowGlobal=true;

(crontab -l 2>/dev/null; echo "@reboot sleep 90 && /usr/bin/nohup /usr/bin/python3 /opt/route48/bird-lg/lgproxy.py &") | crontab -;
(crontab -l 2>/dev/null; echo "@reboot sleep 90 && /bin/bash /opt/route48/tunnels/scripts/reconnect_tunnel.sh") | crontab -;
  
 wget https://raw.githubusercontent.com/thugcrowd/gangshit/master/gangshit1.flf -O /usr/share/figlet/gangshit1.flf
 wget https://raw.githubusercontent.com/thugcrowd/gangshit/master/gangshit2.flf -O /usr/share/figlet/gangshit2.flf
 wget https://raw.githubusercontent.com/xero/figlet-fonts/master/3D-ASCII.flf  -O /usr/share/figlet/3D-ASCII.flf
 wget https://raw.githubusercontent.com/xero/figlet-fonts/master/3-D.flf -O /usr/share/figlet/3-D.flf 
 wget https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf -O /usr/share/figlet/3d.flf
 wget https://raw.githubusercontent.com/xero/figlet-fonts/master/amcslash.flf -O /usr/share/figlet/amcslash.flf
 wget https://raw.githubusercontent.com/xero/figlet-fonts/master/AMC%20Slider.flf -O /usr/share/figlet/amcslider.flf
 wget https://raw.githubusercontent.com/xero/figlet-fonts/master/Banner3-D.flf -O /usr/share/figlet/Banner3-D.flf
 
 UUID=$(cat /proc/sys/kernel/random/uuid) 
 echo $UUID > /opt/route48/api.key
 
cat > /etc/default/dropbear << "EOF"
# the TCP port that Dropbear listens on
DROPBEAR_PORT=9092

# any additional arguments for Dropbear
DROPBEAR_EXTRA_ARGS=-s

# specify an optional banner file containing a message to be
# sent to clients before they connect, such as "/etc/issue.net"
DROPBEAR_BANNER=""

# RSA hostkey file (default: /etc/dropbear/dropbear_rsa_host_key)
#DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"

# DSS hostkey file (default: /etc/dropbear/dropbear_dss_host_key)
#DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"

# ECDSA hostkey file (default: /etc/dropbear/dropbear_ecdsa_host_key)
#DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"

# Receive window size - this is a tradeoff between memory and
# network performance
DROPBEAR_RECEIVE_WINDOW=65536
EOF

cat > /etc/rc.local << "EOF"
#!/bin/sh
[ -d /etc/boot.d ] && run-parts /etc/boot.d
exit 0
EOF
chmod +x /etc/rc.local
mkdir -p /etc/boot.d
cat > /etc/boot.d/udev << "EOF"
#!/bin/sh
service udev stop
EOF
chmod +x /etc/boot.d/udev

cat > /etc/boot.d/autoclean << "EOF"
#!/bin/sh
for pkg in rsyslog* systemd* apparmor* vim-* xxd xkb-data os-prober discover* dmidecode cryptsetup* laptop-detect kbd keyboard-configuration tasksel*; do
	apt -y purge ${pkg}
done
#apt -y purge rsyslog* systemd* apparmor*
apt -y autoremove --purge
rm -rf /etc/boot.d/autoclean; reboot
EOF
chmod +x /etc/boot.d/autoclean

sed '/^[23456789]:/s/^/#/' -i /etc/inittab
reboot
