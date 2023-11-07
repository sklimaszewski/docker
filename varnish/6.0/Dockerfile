FROM wodby/varnish:6.0

ENV VARNISH_IMPORT_MODULES=geoip,digest,cookie,vsthrottle,header,softpurge,tcp,xkeys
COPY default.vcl /etc/varnish/default.vcl

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/etc/init.d/varnishd"]