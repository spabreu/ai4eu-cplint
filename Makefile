IMAGES=$(shell ls -1 */Dockerfile | sed -e s:/Dockerfile::)
COPY=save.pl
LGTVERS=3.39.0-1
LGTDEB=logtalk_$(LGTVERS)_all.deb
DATA=data
WORKDIR=/root

all: cplint

.PHONY: prolog logtalk cplint clean

prolog:
	docker build $@ --tag $@:latest

logtalk: logtalk.deb prolog
	cp logtalk.deb $@
	cp save.pl $@
	docker build $@ --tag $@:latest

cplint: logtalk
	cp save.pl $@
	docker build $@ --tag $@:latest

run-%::
	docker run -ti \
		-v $(PWD)/$(DATA):$(WORKDIR)/$(DATA) \
		$(subst run-,,$@):latest

logtalk.deb::
	[ -e $(LGTDEB) ] || wget -q https://logtalk.org/files/$(LGTDEB)
	ln -sf $(LGTDEB) logtalk.deb

clean:
	rm -f $(DATA)/*
	docker container prune -f
	docker image prune -f
	docker image rm -f $(IMAGES)
