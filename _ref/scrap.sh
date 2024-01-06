
_custom_qemu() {
	_start
	
	_messagePlain_nominal '_custom: qemu'
	
	! _prepareBootdisc && _messageFAIL
	
	cp "$scriptAbsoluteLocation" "$hostToGuestFiles"/
	"$scriptBin"/.ubrgbin.sh _ubrgbin_cpA "$scriptBin" "$hostToGuestFiles"/_bin
	
	
	echo '#!/usr/bin/env bash' >> "$hostToGuestFiles"/cmd.sh
	
	#echo '[[ ! -e /FW-done ]] && cd /home/user/.ubcore/ubiquitous_bash ; ./ubiquitous_bash.sh _cfgFW-terminal | sudo -n tee /cfgFW.log ; cd' >> "$hostToGuestFiles"/cmd.sh
	
	#echo '[[ ! -e /FW-done ]] && cd /home/user/.ubcore/ubiquitous_bash ; ./ubiquitous_bash.sh _cfgFW-terminal | sudo -n tee /cfgFW.log ; cd' >> "$hostToGuestFiles"/cmd.sh
	
	echo 'echo | sudo -n tee -a /FW-done' >> "$hostToGuestFiles"/cmd.sh
	echo 'sudo -n poweroff' >> "$hostToGuestFiles"/cmd.sh
	
	! _writeBootdisc && _messageFAIL
	
	
	
	qemuArgs+=(-nographic)
	
	qemuArgs+=(-usb)
	
	local hostThreadCount
	hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l | tr -dc '0-9')
	qemuArgs+=(-smp "$hostThreadCount")
	
	qemuUserArgs+=(-drive format=raw,file="$scriptLocal"/vm.img)
	
	[[ -e "$hostToGuestISO" ]] && qemuUserArgs+=(-drive file="$hostToGuestISO",media=cdrom)
	
	# Boot from whichever emulated disk connected ('-boot c' for emulated disc 'cdrom')
	qemuUserArgs+=(-boot d)
	
	qemuUserArgs+=(-m "1664")
	
	[[ "$qemuUserArgs_netRestrict" == "" ]] && qemuUserArgs_netRestrict="n"
	qemuUserArgs+=(-net nic,model=rtl8139 -net user,restrict="$qemuUserArgs_netRestrict")
	#,smb="$sharedHostProjectDir"
	
	qemuArgs+=(-device usb-tablet)
	
	if [[ $(_qemu_system_x86_64 -version | grep version | sed 's/.*version\ //' | sed 's/\ .*//' | cut -f1 -d\. | tr -dc '0-9') -lt "6" ]]
	then
		qemuArgs+=(-show-cursor)
	fi
	
	qemuArgs+=(-device qxl-vga)
	
	# hardware vt
	if _testQEMU_hostArch_x64_hardwarevt
	then
		# Apparently, qemu kvm, can be unreliable if nested (eg. within VMWare Workstation VM).
		#[[ "$qemuHeadless" == "true" ]] || 
		_messagePlain_good 'found: kvm'
		if [[ "$qemuNoKVM" == "true" ]] || [[ "$qemuNoKVM" != "false" ]]
		then
			_messagePlain_good 'ignored: kvm'
		else
			qemuArgs+=(-machine accel=kvm)
		fi
	else
		_messagePlain_warn 'missing: kvm'
	fi
	
	# https://www.kraxel.org/repos/jenkins/edk2/
	# https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-20200515.1447.g317d84abe3.noarch.rpm
	if [[ -e "$HOME"/core/installations/ovmf/OVMF_CODE-pure-efi.fd ]] && [[ -e "$HOME"/core/installations/ovmf/OVMF_VARS-pure-efi.fd ]]
	then
		qemuArgs+=(-drive if=pflash,format=raw,readonly,file="$HOME"/core/installations/ovmf/OVMF_CODE-pure-efi.fd -drive if=pflash,format=raw,file="$HOME"/core/installations/ovmf/OVMF_VARS-pure-efi.fd)
	elif [[ -e /usr/share/OVMF/OVMF_CODE.fd ]]
	then
		qemuArgs+=(-bios /usr/share/OVMF/OVMF_CODE.fd)
	fi
	
	qemuArgs+=("${qemuSpecialArgs[@]}" "${qemuUserArgs[@]}")
	
	_messagePlain_probe _qemu_system_x86_64 "${qemuArgs[@]}"
	
	local currentExitStatus
	
	ls -l /dev/kvm

	if [[ "$qemuHeadless" != "true" ]]
	then
		_qemu_system_x86_64 "${qemuArgs[@]}"
		currentExitStatus="$?"
	else
		_qemu_system_x86_64 "${qemuArgs[@]}" | tr -dc 'a-zA-Z0-9\n'
		currentExitStatus=${PIPESTATUS[0]}
		#currentExitStatus="$?"
	fi
	
	
	
	
	if [[ -e "$instancedVirtDir" ]] && ! _safeRMR "$instancedVirtDir"
	then
		_messageFAIL
	fi
	
	_messagePlain_nominal '_custom: qemu: done'
	
	_stop "$currentExitStatus"
}


 
