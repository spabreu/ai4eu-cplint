FROM prolog
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

COPY save.pl ${WORKDIR}/
COPY logtalk.deb ${WORKDIR}/

RUN apt-get install -y --no-install-recommends \
    	    swi-prolog-nox \
	    wget
RUN dpkg -i ${WORKDIR}/logtalk.deb
RUN rm -f ${WORKDIR}/logtalk.deb
# RUN apt-get purge -y wget ca-certificates libpsl5 openssl publicsuffix

RUN swilgt \
    -g '[save]' \
    -g 'save(logtalk)'

RUN mv ${SAVEDIR}/* ${SAVEDIR}.init/

#CMD logtalk --tty
CMD logtalk
