#FROM logtalk
FROM prolog

LABEL maintainer="spa@debian.org"

ENV SAVEDIR=/data
ENV WORKDIR=/root
ENV SAVE_DIR=${WORKDIR}${SAVEDIR}
ENV LOGTALKUSER=${WORKDIR}/logtalk

ENV PATH=\
$PATH:\
${WORKDIR}${SAVEDIR}:\
${LOGTALKHOME}/tools/diagrams:\
${LOGTALKHOME}/tools/lgtdoc/xml:\
${LOGTALKHOME}/scripts:${LOGTALKHOME}/integration:

ENV MANPATH=${MANPATH}:${LOGTALKHOME}/man

WORKDIR ${WORKDIR}

COPY save.pl ${WORKDIR}/

RUN apt-get update; apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    	    swi-prolog-nox \
	    wget \
	gawk git \
	autoconf automake \
	make gcc g++ \
	ca-certificates

RUN swipl -g 'pack_install(cplint, [interactive(false)])'

RUN mkdir -p ${WORKDIR}${SAVEDIR}

#RUN logtalk \
RUN swipl \
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

CMD cplint
#CMD cplint-LATEST -t prolog --tty
#CMD sh
#CMD bash
