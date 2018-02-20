#!/bin/bash
>/etc/varnish/startup.log
while ! ping -c1 nginx 1>/dev/null 2>/dev/null ;do
	echo "Unable to resolve 'nginx'. Trying again in 5s" >> /etc/varnish/startup.log
	sleep 5
done

exec usr/sbin/varnishd -F -a :6081 -T localhost:6082 -f /etc/varnish/default.vcl -S none -s malloc,256m -p vcc_allow_inline_c=on -p vsl_reclen=4084 -p feature=+esi_disable_xml_check,+esi_ignore_other_elements -p cli_buffer=16384
