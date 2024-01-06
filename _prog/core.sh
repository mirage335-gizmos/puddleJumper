##### Core


_install-remove() {
	_chroot sudo -n systemctl disable docker
	_chroot systemctl disable docker.service
	_chroot sudo -n systemctl mask docker
	_chroot systemctl mask docker.service
	_chroot sudo -n systemctl stop docker
	_chroot systemctl stop docker.service
	
	
	_chroot sudo -n systemctl disable vboxadd
	_chroot systemctl disable vboxadd.service
	_chroot sudo -n systemctl mask vboxadd
	_chroot systemctl mask vboxadd.service
	_chroot sudo -n systemctl stop vboxadd
	_chroot systemctl stop vboxadd.service
	
	
	_chroot sudo -n systemctl disable vboxadd-service
	_chroot systemctl disable vboxadd-service.service
	_chroot sudo -n systemctl mask vboxadd-service
	_chroot systemctl mask vboxadd-service.service
	_chroot sudo -n systemctl stop vboxadd-service
	_chroot systemctl stop vboxadd-service.service
	
	
	_chroot sudo -n systemctl disable vboxautostart
	_chroot systemctl disable vboxautostart.service
	_chroot sudo -n systemctl mask vboxautostart
	_chroot systemctl mask vboxautostart.service
	_chroot sudo -n systemctl stop vboxautostart
	_chroot systemctl stop vboxautostart.service
	
	
	_chroot sudo -n systemctl disable vboxautostart-service
	_chroot systemctl disable vboxautostart-service.service
	_chroot sudo -n systemctl mask vboxautostart-service
	_chroot systemctl mask vboxautostart-service.service
	_chroot sudo -n systemctl stop vboxautostart-service
	_chroot systemctl stop vboxautostart-service.service
	
	
	_chroot sudo -n systemctl disable vboxdrv
	_chroot systemctl disable vboxdrv.service
	_chroot sudo -n systemctl mask vboxdrv
	_chroot systemctl mask vboxdrv.service
	_chroot sudo -n systemctl stop vboxdrv
	_chroot systemctl stop vboxdrv.service
	
	
	_chroot sudo -n systemctl disable vboxweb
	_chroot systemctl disable vboxweb.service
	_chroot sudo -n systemctl mask vboxweb
	_chroot systemctl mask vboxweb.service
	_chroot sudo -n systemctl stop vboxweb
	_chroot systemctl stop vboxweb.service
	
	
	_chroot sudo -n systemctl disable vboxweb-service
	_chroot systemctl disable vboxweb-service.service
	_chroot sudo -n systemctl mask vboxweb-service
	_chroot systemctl mask vboxweb-service.service
	_chroot sudo -n systemctl stop vboxweb-service
	_chroot systemctl stop vboxweb-service.service
	
	
	
	
	
	
	
	
	#_chroot sudo -n systemctl disable cups
	#_chroot systemctl disable cups.service
	#_chroot sudo -n systemctl mask cups
	#_chroot systemctl mask cups.service
	#_chroot sudo -n systemctl stop cups
	#_chroot systemctl stop cups.service
	
	
	
	
	
	sudo -n apt-get -y remove 'virtualbox*'
	
	sudo -n apt-get -y remove 'docker*'
	
	
}





_install-vsftpd() {
	
	sudo -n mkdir /etc/ssl/private
	sudo -n chmod 710 /etc/ssl/private
	sudo -n openssl req -x509 -nodes -days 12775 -newkey rsa:4096 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt -subj "/C=US/ST=NY/L=NYC/O=organization/CN=commonName.local/emailAddress=user@email.com"
	
	sudo -n chown root:ftp /etc/ssl/private/vsftpd.key
	sudo -n chmod 710 /etc/ssl/private/vsftpd.key
	
	
	
	! sudo -n grep '/bin/false' /etc/shells > /dev/null && echo /bin/false | sudo -n tee -a /etc/shells > /dev/null
	
	sudo -n useradd -m -s /bin/false brig
	
	sudo -n usermod -s /bin/false brig
	
	sudo -n cp -f "$scriptLib"/vsftpd_cfg/vsftpd.conf /etc/vsftpd.conf ; sudo -n cp -f "$scriptLib"/vsftpd_cfg/vsftpd.userlist /etc/vsftpd.userlist ; sudo -n cp -f "$scriptLib"/vsftpd_cfg/vsftpd.chroot_list /etc/vsftpd.chroot_list
	
	echo -n brig':'$(cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | head -c 12 ) | sudo -n chpasswd
	echo -n brig':'$(cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | head -c 32 ) | sudo -n chpasswd
	
	if ! sudo -n crontab -l | grep brig_passwd > /dev/null
	then
	(
		sudo -n crontab -l
		cat << 'CZXWXcRMTo8EmM8i4d'
@reboot bash -c "cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c 8 | sudo -n tee /brig_passwd > /dev/null ; sudo -n chmod 500 /brig_passwd ; echo -n brig':' | cat - /brig_passwd | sudo -n chpasswd"
CZXWXcRMTo8EmM8i4d
	) | sudo -n crontab -
	fi
	
	sudo -n mkdir -p /home/brig/ftp
	#-u brig
	sudo -n mkdir -p /home/brig/ftp/Downloads
	
	sudo -n chown brig:brig /home/brig/ftp/Downloads
	sudo -n chmod 750 /home/brig/ftp/Downloads
	
	sudo -n chown root:brig /home/brig
	sudo -n chown root:brig /home/brig/ftp
	
	sudo -n chmod 550 /home/brig
	sudo -n chmod 550 /home/brig/ftp
	
	
	
	
	
	_chroot sudo -n systemctl enable vsftpd
	_chroot systemctl enable vsftpd.service
	_chroot sudo -n systemctl unmask vsftpd
	_chroot systemctl unmask vsftpd.service
	_chroot sudo -n systemctl restart vsftpd
	_chroot systemctl restart vsftpd.service
	
	
}
















_install() {
	_install-remove
	
	_install-vsftpd
}





_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_install
}

