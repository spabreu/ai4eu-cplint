FROM logtalk
LABEL maintainer="spa@debian.org"

# -- public ports -------------------------------------------------------------

## EXPOSE 80/tcp

# -- environment variables ----------------------------------------------------

ENV WORKDIR=/root

WORKDIR ${WORKDIR}

ENV SAVEDIR=${WORKDIR}/data

ENV LOGTALKHOME=/usr/share/logtalk
ENV LOGTALKUSER=${WORKDIR}/logtalk

ENV PATH=\
$PATH:\
${SAVEDIR}:\
${SAVEDIR}.init:\
${LOGTALKHOME}/tools/diagrams:\
${LOGTALKHOME}/tools/lgtdoc/xml:\
${LOGTALKHOME}/scripts:${LOGTALKHOME}/integration:

ENV MANPATH=${MANPATH}:${LOGTALKHOME}/man

# -- go -----------------------------------------------------------------------

RUN mkdir -p ${SAVEDIR}
RUN mkdir -p ${SAVEDIR}.init

COPY save.pl ${WORKDIR}

RUN apt-get update; apt-get upgrade -y

# -- could simplify this, as we don't need to rebuild shared lib after all ----
RUN apt-get install -y --no-install-recommends \
    	    swi-prolog-nox \
	    wget \
	gawk git \
	autoconf automake \
	make gcc g++ \
	ca-certificates

RUN swipl -g 'pack_install(cplint, [interactive(false)])'

RUN mkdir -p ${WORKDIR}${SAVEDIR}

#RUN swipl \
RUN logtalk \
 	-g '[save]' \
	-g 'current_op(X,Y,(?)) -> asserta(qwes_op(X,Y)), op(0,Y,(?)) ; true' \
 	-g 'ensure_loaded(library(bddem))' \
 	-g 'ensure_loaded(library(pita))' \
 	-g 'ensure_loaded(library(mcintyre))' \
 	-g 'ensure_loaded(library(lemur))' \
 	-g 'ensure_loaded(library(slipcover))' \
 	-g 'retract(qwes_op(X,Y)) -> op(X,Y,(?)) ; true' \
 	-g 'save(cplint)'

# 	-g 'pack_rebuild(bddem)'

RUN mv ${SAVEDIR}/* ${SAVEDIR}.init/

CMD cplint
#CMD cplint-LATEST -t prolog --tty
#CMD sh
#CMD bash
