FROM wodby/varnish:6.0

ENV VARNISH_IMPORT_MODULES=geoip,digest,cookie,vsthrottle,header,softpurge,tcp,xkeys

COPY default.vcl /etc/varnish/default.vcl
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY templates/varnishd.init.d.tmpl /etc/gotpl/varnishd.init.d.tmpl

EXPOSE 80 81 8443

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/etc/init.d/varnishd"]