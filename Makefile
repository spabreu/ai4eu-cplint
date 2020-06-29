IMAGES=$(shell ls -1 */Dockerfile | sed -e s:/Dockerfile::)
COPY=save.pl
LGTVERS=3.39.0-1
LGTDEB=logtalk_$(LGTVERS)_all.deb

all: $(IMAGES)

.PHONY: swi-prolog logtalk cplint clean

prolog:
	docker build $@ --tag $@:latest

logtalk: logtalk.deb swi-prolog
	cp logtalk.deb $@
	cp save.pl $@
	docker build $@ --tag $@:latest

cplint: logtalk
	cp save.pl $@
	docker build $@ --tag $@:latest

run-%::
	docker run -ti $<:latest

logtalk.deb::
	[ -e $(LGTDEB) ] || wget -q https://logtalk.org/files/$(LGTDEB)
	ln -sf $(LGTDEB) logtalk.deb

clean:
	docker container prune -f
	docker image prune -f
	docker image rm -f $(IMAGES)
