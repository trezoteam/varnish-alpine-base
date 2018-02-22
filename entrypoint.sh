#!/bin/bash

if [ -f /etc/opt/nginx_hosts ];then
  #Remove any previous 'varnish' entries from /etc/opt/nginx_hosts
  sed -i '/\(\t\| \)varnish$/d' /etc/opt/nginx_hosts
  
  #Add current IP into /etc/opt/nginx_hosts
  IP=$(ifconfig eth0 | grep 'inet addr' | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1)
  echo "$IP varnish" >> /etc/opt/nginx_hosts
fi


>/etc/varnish/startup.log
while ! ping -c1 nginx 1>/dev/null 2>/dev/null ;do
	echo "Unable to resolve 'nginx'. Trying again in 5s" >> /etc/varnish/startup.log
	sleep 5
done

exec usr/sbin/varnishd -F -a :6081 -T localhost:6082 -f /etc/varnish/default.vcl -S none -s malloc,256m -p vcc_allow_inline_c=on -p vsl_reclen=4084 -p feature=+esi_disable_xml_check,+esi_ignore_other_elements -p cli_buffer=16384
