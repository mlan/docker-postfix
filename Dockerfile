ARG	DIST=alpine
ARG	REL=latest


#
#
# target: base
#
# postfix only
#
#

FROM	$DIST:$REL AS base
LABEL	maintainer=mlan

ENV	SVDIR=/etc/service \
	DOCKER_PERSIST_DIR=/srv \
	DOCKER_BIN_DIR=/usr/local/bin \
	DOCKER_ENTRY_DIR=/etc/docker/entry.d \
	DOCKER_SSL_DIR=/etc/ssl \
	DOCKER_SPOOL_DIR=/var/spool/postfix \
	DOCKER_CONF_DIR=/etc/postfix \
	DOCKER_DIST_DIR=/etc/postfix.dist \
	DOCKER_IMAP_DIR=/etc/dovecot \
	DOCKER_IMAPDIST_DIR=/etc/dovecot.dist \
	DOCKER_UNLOCK_FILE=/srv/etc/.docker.unlock \
	DOCKER_APPL_RUNAS=postfix \
	DOCKER_IMAP_RUNAS=dovecot \
	ACME_POSTHOOK="postfix reload" \
	SYSLOG_LEVEL=5 \
	SYSLOG_OPTIONS=-SDt
ENV	DOCKER_ACME_SSL_DIR=$DOCKER_SSL_DIR/acme \
	DOCKER_APPL_SSL_DIR=$DOCKER_SSL_DIR/postfix \
	DOCKER_IMAP_PASSDB_FILE=$DOCKER_IMAP_DIR/virt-passwd

#
# Copy utility scripts including docker-entrypoint.sh to image
#

COPY	src/*/bin $DOCKER_BIN_DIR/
COPY	src/*/entry.d $DOCKER_ENTRY_DIR/

#
# Install
#
# Arrange persistent directories at /srv.
# Configure Runit, a process manager.
# Make postfix trust smtp clients on the same subnet,
# i.e., containers on the same network.
#

RUN	source docker-common.sh \
	&& source docker-config.sh \
	&& dc_persist_dirs \
	$DOCKER_APPL_SSL_DIR \
	$DOCKER_AV_DIR \
	$DOCKER_AV_LIB \
	$DOCKER_CONF_DIR \
	$DOCKER_IMAP_DIR \
	$DOCKER_MILT_DIR \
	$DOCKER_MILT_LIB \
	$DOCKER_DB_DIR \
	$DOCKER_DB_LIB \
	$DOCKER_SPOOL_DIR \
	&& mkdir -p $DOCKER_ACME_SSL_DIR \
	&& apk --no-cache --update add \
	runit \
	postfix \
	postfix-ldap \
	postfix-mysql \
	postsrsd \
	cyrus-sasl-login \
	&& cp -rlL $DOCKER_CONF_DIR $DOCKER_DIST_DIR \
	&& docker-service.sh \
	"syslogd -nO- -l$SYSLOG_LEVEL $SYSLOG_OPTIONS" \
	"crond -f -c /etc/crontabs" \
	"postfix start-fg" \
	&& mv $DOCKER_CONF_DIR/aliases $DOCKER_CONF_DIR/aliases.dist \
	&& postconf -e mynetworks_style=subnet \
	&& echo "This file unlocks the configuration, so it will be deleted after initialization." > $DOCKER_UNLOCK_FILE

#
# state standard smtp, smtps and submission ports
#

EXPOSE 25 465 587

#
# Rudimentary healthcheck
#

HEALTHCHECK CMD sv status ${SVDIR}/* && postfix status

#
# Entrypoint, how container is run
#

ENTRYPOINT ["docker-entrypoint.sh"]

#
# Have runit's runsvdir start all services
#

CMD	runsvdir -P ${SVDIR}


#
#
# target: full
#
# Install dovecot, a IMAP server
#
#

FROM	base AS full

#
# Install
#
# Remove private key that dovecot creates.
#

RUN	apk --no-cache --update add \
	dovecot \
	dovecot-ldap \
	dovecot-mysql \
	dovecot-lmtpd \
	dovecot-pop3d \
	jq \
	&& docker-service.sh "dovecot -F" \
	&& rm -f /etc/ssl/dovecot/* \
	&& mkdir -p $DOCKER_IMAPDIST_DIR \
	&& mv -f $DOCKER_IMAP_DIR/* $DOCKER_IMAPDIST_DIR \
	&& addgroup $DOCKER_APPL_RUNAS $DOCKER_IMAP_RUNAS \
	&& addgroup $DOCKER_IMAP_RUNAS $DOCKER_APPL_RUNAS
