FROM prolog

LABEL maintainer="spa@debian.org"

#VOLUME ["/root"]

# -- public ports --------------------------------------------------------------

## EXPOSE 80/tcp

# -- some environment variables ------------------------------------------------

ENV LOGTALKHOME=/usr/share/logtalk

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

RUN mkdir -p ${WORKDIR}${SAVEDIR}

WORKDIR ${WORKDIR}

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

#WORKDIR ${WORKDIR}

#ENTRYPOINT [/root/swipl2]
#CMD bash
#CMD /root/swipl2
#CMD /root/swilgt -t prolog --tty

CMD logtalk --tty
CMD logtalk-LATEST --tty
CMD swipl -x ${WORKDIR}${SAVEDIR}/logtalk-LATEST --tty
