VERSION=$(shell git describe --tags --long )

build:
	GOOS=linux GOARCH=amd64 go build -o statsdaemon/statsdaemon statsdaemon/main.go

all:

deb: build
	install -d debian/usr/bin debian/etc
	install statsdaemon.ini debian/etc/statsdaemon.ini
	install statsdaemon/statsdaemon debian/usr/bin
	fpm \
		-s dir \
		-t deb \
		-n statsdaemon \
		-v $(VERSION) \
		-a amd64 \
		--config-files etc/statsdaemon.ini \
		--deb-upstart statsdaemon.upstart \
		-m "Dieter Plaetinck <dieter@raintank.io>" \
		--description "Metrics aggregation daemon like statsd" \
		--license BSD \
		--url https://github.com/nejec/statsdaemon \
		-C debian .
	rm -rf debian

clean:
	rm -f statsdaemon/statsdaemon
	rm -f statsdaemon_*.deb

.PHONY: all deb clean
