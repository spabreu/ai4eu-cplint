FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get upgrade -y && \
#   apt-get install -y --no-install-recommends \
#   	    swi-prolog-core \
#	    swi-prolog-core-packages
    apt-get install -y --no-install-recommends swi-prolog-nox

CMD swipl
