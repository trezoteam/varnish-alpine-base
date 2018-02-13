FROM thiagofigueiro/varnish-alpine-docker

CMD usr/sbin/varnishd -j unix,user=vcache -F -a :6081 -T localhost:6082 -f /etc/varnish/default.vcl -S "" -s malloc,256m -p vcc_allow_inline_c=on -p vsl_reclen=4084 -p feature=+esi_disable_xml_check,+esi_ignore_other_elements -p cli_buffer=16384
