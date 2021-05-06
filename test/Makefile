# Makefile
#
# test
#

-include    *.mk

TST_REPO ?= mlan/postfix-amavis
TST_VER  ?= latest
_ver      = $(if $(findstring latest,$(1)),$(2),$(2)-$(1))

MTA_LIST ?= srv cli
CNT_LIST ?= $(MTA_LIST) auth db
TST_NAME ?= test

NET_NAME ?= $(TST_NAME)-net
NET_ENV  ?= --network $(NET_NAME)

AD_DOM   ?= example.com
AD_BASE  ?= $(call ad_sub_dc,$(AD_DOM))
AD_DC    ?= $(call ad_cut_dot, 1, 1, $(AD_DOM))
AD_ROOT_CN ?= admin
AD_ROOT_PW ?= secret
AD_GRP_OU ?= groups
AD_USR_OB ?= inetOrgPerson
AD_USR_OU ?= users
AD_USR_CN ?= receiver
AD_USR_PW ?= secret
AD_USR_AD ?= $(AD_USR_CN)@$(AD_DOM)
AD_USR_BX ?= $(AD_USR_CN)
AD_USR_AL ?= my-alias
AD_MX_CN ?= office1
AD_MX_PW ?= password1
AD_FLT_US ?= "(&(objectclass=$(AD_USR_OB))(mail=%s))"
AD_FLT_PW ?= "(&(objectclass=$(AD_USR_OB))(uid=%u))"
AD_ATT_PW ?= uid=user

SQL_DB   ?= postfix
SQL_TAB  ?= users
SQL_ROOT_PW ?= secret
SQL_BD_CN ?= admin
SQL_BD_PW ?= secret
SQL_Q_CN ?= "select mail from $(SQL_TAB) where mail='%s' limit 1;"
SQL_Q_PW ?= "select password, userid as user from $(SQL_TAB) where userid = '%u'"

EX_DOM   ?= my-domain.org
EX_USR_CN ?= sender
EX_MX_CN ?= office2
EX_MX_PW ?= password2
AD_SND_AD ?= $(EX_USR_CN)@$(AD_DOM)
EX_USR_AD ?= $(AD_USR_CN)@$(EX_DOM)
EX_USR_BX ?= $(EX_DOM)/$(AD_USR_CN)

MAIL_SUB ?= ~~~test~subject~~~
MAIL_MSG ?= ~~~test~message~~~

TST_SLOG ?= 7
TST_ALOG ?= 6
TST_SBUG ?= 0
TST_STAG ?= -99

AUT_NAME ?= $(TST_NAME)-auth
AUT_IMG  ?= mlan/openldap:2
AUT_FQDN ?= $(AUT_NAME).$(AD_DOM)
AUT_VOL  ?=
AUT_ENV  ?= $(NET_ENV) \
--name $(AUT_NAME) \
--hostname $(AUT_FQDN) \
-e LDAPBASE=$(AD_BASE) \
-e LDAPROOT_CN=$(AD_ROOT_CN) \
-e LDAPROOT_PW=$(AD_ROOT_PW)

DB_NAME ?= $(TST_NAME)-db
DB_IMG  ?= mariadb
DB_FQDN ?= $(DB_NAME).$(AD_DOM)
DB_VOL  ?=
SQL_ENV ?= \
-e MYSQL_ROOT_PASSWORD=$(SQL_ROOT_PW) \
-e MYSQL_DATABASE=$(SQL_DB) \
-e MYSQL_USER=$(SQL_BD_CN) \
-e MYSQL_PASSWORD=$(SQL_BD_PW)
DB_ENV  ?= $(NET_ENV) $(SQL_ENV) \
--name $(DB_NAME) \
--hostname $(DB_FQDN)

TST_ENV  ?= $(NET_ENV) \
-e MYORIGIN=$(AD_DOM) \
-e SYSLOG_LEVEL=$(TST_SLOG) \
-e SA_TAG_LEVEL_DEFLT=$(TST_STAG) \
-e SA_DEBUG=$(TST_SBUG) \
-e LOG_LEVEL=$(TST_ALOG)

CLT_NAME ?= $(TST_NAME)-cli
CLT_FQDN ?= $(CLT_NAME).$(AD_DOM)
CLT_ENV  ?= $(TST_ENV) \
--name $(CLT_NAME) \
--hostname $(CLT_FQDN)
CLTV_ENV ?= -v $(CLT_NAME):/srv
SRV_NAME ?= $(TST_NAME)-srv
SRV_FQDN ?= $(SRV_NAME).$(AD_DOM)
SRV_CERT ?= ssl/$(SRV_FQDN).crt
SRV_KEY  ?= ssl/$(SRV_FQDN).key
SRV_ENV  ?= $(TST_ENV) \
--name $(SRV_NAME) \
--hostname $(SRV_FQDN)
SRVV_ENV ?= -v $(SRV_NAME):/srv
ADBA_ENV ?= \
-e LDAP_HOST=$(AUT_NAME) \
-e LDAP_USER_BASE=ou=$(AD_USR_OU),$(AD_BASE)
ADLU_ENV ?= $(ADBA_ENV) \
-e LDAP_QUERY_FILTER_USER=$(AD_FLT_US)
ADAU_ENV ?= $(ADBA_ENV) \
-e LDAP_QUERY_ATTRS_PASS=$(AD_ATT_PW) \
-e LDAP_QUERY_FILTER_PASS=$(AD_FLT_PW)
ADAL_ENV ?= $(ADLU_ENV) \
-e LDAP_QUERY_ATTRS_PASS=$(AD_ATT_PW)
DBLU_ENV ?= $(SQL_ENV) \
-e MYSQL_HOST=$(DB_NAME) \
-e MYSQL_QUERY_USER=$(SQL_Q_CN) \
-e MYSQL_QUERY_PASS=$(SQL_Q_PW)

DOVE_ENV ?= \
-e VIRTUAL_TRANSPORT=lmtp:unix:private/transport \
-e DOVECOT_AUTH_USERNAME_FORMAT=%Ln
#-e DOVECOT_DISABLE_PLAINTEXT_AUTH=no \

TLS_ENV  ?= \
-v $(shell pwd)/ssl:/etc/ssl/postfix \
-e SMTPD_TLS_CERT_FILE=/etc/ssl/postfix/$(notdir $(SRV_CERT)) \
-e SMTPD_TLS_KEY_FILE=/etc/ssl/postfix/$(notdir $(SRV_KEY))
ACME_ENV ?= \
-v $(shell pwd)/acme:/acme \
-e ACME_FILE=/acme/acme.json

IMAP_ENV ?= \
-e VIRTUAL_TRANSPORT=lmtp:unix:private/transport

TST_BOX  ?= $(AD_USR_AD):$(AD_USR_BX) $(AD_SND_AD)
TST_BOX2 ?= $(AD_USR_AD):$(AD_USR_BX) $(EX_USR_AD):$(EX_USR_BX)
TST_ALS  ?= $(AD_USR_AL):$(AD_USR_AD) postmaster:$(AD_USR_AD),$(AD_USR_CN)
TST_DK_S ?= default

CURL_OPT ?= -s -v
CURL_IMG ?= curlimages/curl
CURL_ENV ?= $(NET_ENV) \
-i --rm

GREP_ENV ?=

TST_W8S1 ?= 1
TST_W8AU ?= 3
TST_W8DB ?= 40
TST_W8S2 ?= 80
TST_W8L1 ?= 20
TST_W8L2 ?= 120

export define LDIF_ADD_DATA
dn: $(AD_BASE)
objectClass: organization
objectClass: dcObject
dc: $(AD_DC)
o: $(AD_DOM)

dn: ou=$(AD_USR_OU),$(AD_BASE)
objectClass: organizationalUnit
ou: $(AD_USR_OU)

dn: ou=$(AD_GRP_OU),$(AD_BASE)
objectClass: organizationalUnit
ou: $(AD_GRP_OU)

dn: uid=$(AD_USR_CN),ou=$(AD_USR_OU),$(AD_BASE)
objectClass: $(AD_USR_OB)
cn: $(AD_USR_CN)
sn: $(AD_USR_CN)
uid: $(AD_USR_CN)
mail: $(AD_USR_AD)
userPassword: $(AD_USR_PW)

dn: uid=$(AD_MX_CN),ou=$(AD_USR_OU),$(AD_BASE)
objectClass: $(AD_USR_OB)
cn: $(AD_MX_CN)
sn: $(AD_MX_CN)
uid: $(AD_MX_CN)
userPassword: $(AD_MX_PW)
endef

export define SQL_ADD_DATA
create table $(SQL_TAB)(
	id int not null auto_increment,
	userid varchar(128) not null,
	password varchar(64) not null,
	mail varchar(128),
	primary key ( id )
);
insert into $(SQL_TAB) (userid, password, mail) values ("$(AD_USR_CN)", concat("{PLAIN-MD5}",md5("$(AD_USR_PW)")), "$(AD_USR_AD)");
insert into $(SQL_TAB) (userid, password) values ("$(AD_MX_CN)", concat("{PLAIN-MD5}",md5("$(AD_MX_PW)")));
endef

variables:
	make -pn | grep -A1 "^# makefile"| grep -v "^#\|^--" | sort | uniq

ps:
	docker ps -a

test-all: test-up_0 $(addprefix test_,1 2 3 4 5 6 7 8 9)
	

test_%: test-up_% test-waitl_% test-logs_% test-mail_% test-down_%
	

test-up_0:
	#
	#
	#
	# test (0) run without envvars (is there smoke?)
	#
	# run containers see if there are logs and stop.
	#
	#
	docker run -d --name $(SRV_NAME) $(TST_REPO):$(call _ver,$(TST_VER),mini)
	sleep $(TST_W8L1)
	docker container logs $(SRV_NAME) | grep 'docker-entrypoint.sh'
	docker rm -f $(SRV_NAME)
	sleep $(TST_W8S1)
	docker run -d --name $(SRV_NAME) $(TST_REPO):$(call _ver,$(TST_VER),base)
	sleep $(TST_W8L1)
	docker container logs $(SRV_NAME) | grep 'docker-entrypoint.sh'
	docker rm -f $(SRV_NAME)
	sleep $(TST_W8S1)
	docker run -d --name $(SRV_NAME) $(TST_REPO):$(call _ver,$(TST_VER),full)
	sleep $(TST_W8L1)
	docker container logs $(SRV_NAME) | grep 'docker-entrypoint.sh'
	docker rm -f $(SRV_NAME)
	sleep $(TST_W8S1)
	#
	#
	# test (0) success ☺
	#
	#
	#

test-up_1: test-up-net
	#
	#
	#
	# test (1) basic mta function and virtual alias lookup
	#
	# send: curl smtp://clt -> clt smtp://srv -> srv postfix mbox:$(AD_USR_BX)
	# recv: cat srv mbox:$(AD_USR_BX)
	#
	#
	docker run -d $(SRV_ENV) \
		-e MAIL_BOXES="$(TST_BOX)" -e MAIL_ALIASES="$(TST_ALS)" \
		$(TST_REPO):$(call _ver,$(TST_VER),mini)
	docker run -d $(CLT_ENV) \
		-e RELAYHOST=[$(SRV_NAME)] -e MYDESTINATION= \
		$(TST_REPO):$(call _ver,$(TST_VER),mini)

test-up_2: test-up-net test-up-auth_2
	#
	#
	#
	# test (2) basic mta function and ldap lookup
	#
	# send: curl smtp://clt -> clt smtp://srv -> srv postfix mbox:$(AD_USR_AD)
	# recv: cat srv mbox:$(AD_USR_AD)
	#
	#
	docker run -d $(SRV_ENV) $(ADLU_ENV) \
		$(TST_REPO):$(call _ver,$(TST_VER),mini)
	docker run -d $(CLT_ENV) -e RELAYHOST=[$(SRV_NAME)] -e MYDESTINATION= \
		$(TST_REPO):$(call _ver,$(TST_VER),mini)

test-up_3: test-up-net test-up-db_3 acme/acme.json
	#
	#
	#
	# test (3) basic mta function and mysql lookup and imap
	#
	# send: curl smtp://clt -> clt smtp://srv -> srv dovecot mbox
	# recv: imaps://srv/inbox
	#
	#
	docker run -d $(SRV_ENV) $(DBLU_ENV) $(TLS_ENV) $(DOVE_ENV) \
		$(TST_REPO):$(call _ver,$(TST_VER),base)
	docker run -d $(CLT_ENV) -e RELAYHOST=[$(SRV_NAME)] -e MYDESTINATION= \
		$(TST_REPO):$(call _ver,$(TST_VER),mini)

test-up_4: test-up-net test-up-auth_4 acme/acme.json
	#
	#
	#
	# test (4) ldap sasl, basic and selfsigned tls over smtps, subm w ldap lookup
	#
	# send: curl smtps://clt -> clt smtps://srv:587 -> srv dovecot mbox
	# recv: imaps://srv/inbox
	#
	#
	docker run -d $(SRV_ENV) $(ADAL_ENV) $(TLS_ENV) $(DOVE_ENV) \
		$(TST_REPO):$(call _ver,$(TST_VER),base)
	docker run -d $(CLT_ENV) $(ADAU_ENV) -e SMTPD_USE_TLS=yes \
		-e SMTP_RELAY_HOSTAUTH="[$(SRV_NAME)]:587 $(AD_MX_CN):$(AD_MX_PW)" \
		-e MYDESTINATION= -e SMTP_TLS_SECURITY_LEVEL=encrypt \
		$(TST_REPO):$(call _ver,$(TST_VER),base)

test-up_5: test-up-net acme/acme.json
	#
	#
	#
	# test (5) passwd-file sasl and acme tls over subm
	#
	# send: curl smtp://clt -> clt smtps://srv:587 -> srv postfix mbox:$(AD_USR_BX)
	# recv: cat srv mbox:$(AD_USR_BX)
	#
	#
	docker run -d $(SRV_ENV) $(ACME_ENV) \
		-e MAIL_BOXES="$(TST_BOX)" \
		-e SMTPD_SASL_CLIENTAUTH="$(AD_USR_CN):{plain}$(AD_USR_PW) $(EX_MX_CN):{plain}$(EX_MX_PW)" \
		$(TST_REPO):$(call _ver,$(TST_VER),base)
	docker run -d $(CLT_ENV) \
		-e SMTP_RELAY_HOSTAUTH="[$(SRV_NAME)]:587 $(EX_MX_CN):$(EX_MX_PW)" \
		-e MYDESTINATION= -e SMTP_TLS_SECURITY_LEVEL=encrypt \
		$(TST_REPO):$(call _ver,$(TST_VER),mini)

test-up_6: test-up-net
	#
	#
	#
	# test (6) basic milter function and selfsigned tls
	#
	# send: curl smtp://clt -> clt smtp://srv -> srv postfix mbox:$(AD_USR_BX)
	# recv: cat srv mbox:$(AD_USR_BX)
	#
	#
	docker run -d $(SRV_ENV) \
		-e MAIL_BOXES="$(TST_BOX)" -e SMTPD_USE_TLS=yes \
		$(TST_REPO):$(call _ver,$(TST_VER),full)
	docker run -d $(CLT_ENV) -e RELAYHOST=[$(SRV_NAME)] \
		-e MYDESTINATION= -e LOG_LEVEL=$(TST_ALOG) \
		$(TST_REPO):$(call _ver,$(TST_VER),full)

test-up_7: test-down-vol test-up-net
	#
	#
	#
	# test (7) dkim and multiple domains
	#
	# send: curl smtp://clt -> clt smtp://srv -> srv postfix mbox:$(EX_USR_BX)
	# recv: cat srv mbox:$(EX_USR_BX)
	#
	#
	docker run -d $(SRV_ENV) $(SRVV_ENV) \
		-e MAIL_BOXES="$(TST_BOX2)" -e MAIL_DOMAIN="$(AD_DOM) $(EX_DOM)" \
		$(TST_REPO):$(call _ver,$(TST_VER),full)
	docker run -d $(CLT_ENV) $(CLTV_ENV) -e DKIM_SELECTOR=$(TST_DK_S) \
		-e RELAYHOST=[$(SRV_NAME)] \
		-e MYDESTINATION= -e MAIL_DOMAIN="$(AD_DOM)" \
		$(TST_REPO):$(call _ver,$(TST_VER),full)

test-up_8: test-up-net test_7
	#
	#
	#
	# test (8) persistent /srv no env given
	#
	# send: curl smtp://clt -> clt smtp://srv -> srv postfix mbox:$(EX_USR_BX)
	# recv: cat srv mbox:$(EX_USR_BX)
	#
	#
	docker run -d $(SRV_ENV) $(SRVV_ENV) \
		$(TST_REPO):$(call _ver,$(TST_VER),full)
	docker run -d $(CLT_ENV) $(CLTV_ENV) \
		$(TST_REPO):$(call _ver,$(TST_VER),full)

test-up_9: test-up-net test_8
	#
	#
	#
	# test (9) persistent /srv FORCE_CONFIG
	#
	# send: curl smtp://clt -> clt smtp://srv -> srv postfix mbox:$(EX_USR_BX)
	# recv: cat srv mbox:$(EX_USR_BX)
	#
	#
	docker run -d $(SRV_ENV) $(SRVV_ENV) -e FORCE_CONFIG=true \
		-e MAIL_BOXES="$(TST_BOX2)" -e MAIL_DOMAIN="$(AD_DOM) $(EX_DOM)" \
		$(TST_REPO):$(call _ver,$(TST_VER),full)
	docker run -d $(CLT_ENV) $(CLTV_ENV) \
		-e RELAYHOST=[$(AUT_NAME)] \
		$(TST_REPO):$(call _ver,$(TST_VER),full)

test-mail: test-mail_0
test-mail-send: test-mail-send_0

test-mail_%: test-mail-send_% test-waits_% test-mail-read_%
	#
	#
	# test ($*) success ☺
	#
	#
	#

test-logs_%:
	docker container logs $(SRV_NAME)

test-waits_%:
	case $* in [0-5]) sleep $(TST_W8S1);; *) sleep $(TST_W8S2);; esac

test-waitl_%:
	case $* in [0-5]) sleep $(TST_W8L1);; *) sleep $(TST_W8L2);; esac

test-up-net:
	docker network create $(NET_NAME) 2>/dev/null || true

test-down-net:
	docker network rm $(NET_NAME) 2>/dev/null || true

test-down-vol:
	docker volume rm $(SRV_NAME) $(CLT_NAME) 2>/dev/null || true

test-down: test-down_0 test-down-net test-down-vol acme-destroy

test-down_%:
	docker rm -f $(CLT_NAME) $(SRV_NAME) $(AUT_NAME) $(DB_NAME) 2>/dev/null || true
	if [ $* -ge 0 ]; then sleep $(TST_W8S1); fi

test-up-auth_%:
	docker run -d $(AUT_ENV) $(AUT_VOL) $(AUT_IMG)
	sleep $(TST_W8AU)
	echo "$$LDIF_ADD_DATA" | docker exec -i $(AUT_NAME) ldapadd -Q

test-up-db_%:
	docker run -d $(DB_ENV) $(DB_VOL) $(DB_IMG)
	sleep $(TST_W8DB)
	echo "$$SQL_ADD_DATA" | docker exec -i $(DB_NAME) mysql -u$(SQL_BD_CN) -p$(SQL_BD_PW) $(SQL_DB)


test-conf_%:
	${eval tst_ad := ${shell case $* in \
	1) echo $(AD_USR_AL);; [7-9]) echo $(EX_USR_AD);; *) echo $(AD_USR_AD);; esac}}
	${eval tst_bx := ${shell case $* in \
	2) echo $(AD_USR_AD);; [7-9]) echo $(EX_USR_BX);; *) echo $(AD_USR_BX);; esac}}
	${eval tst_spro := ${shell case $* in 4) echo smtps;; *) echo smtp;; esac}}
	${eval tst_str := ${shell case $* in 7) echo DKIM-Signature;; *) echo $(MAIL_SUB)$*;; esac}}

test-mail-send_%: test-conf_%
	printf "From: <$(AD_SND_AD)>\nTo: <$(tst_ad)>\nDate: $$(date -R)\nSubject:$(MAIL_SUB)$*\n$(MAIL_MSG)$*\n" \
	| tee /dev/tty | docker run $(CURL_ENV) $(CURL_IMG) $(CURL_OPT) -T - \
	--mail-from $(AD_SND_AD) --mail-rcpt $(tst_ad) \
	--url $(tst_spro)://$(CLT_NAME) -u $(AD_USR_CN):$(AD_USR_PW) --ssl --anyauth -k

test-mail-read_%: test-conf_% all-test_quiet
	case $* in [3-4]) ${MAKE} srv-imap;; *) ${MAKE} test-mail-cat_$*;; esac | grep $(tst_str)

test-mail-cat_%: test-conf_%
	docker exec -it $(SRV_NAME) cat /var/mail/$(tst_bx)

$(addprefix test-,diff env htop imap logs pop3 sh sv):
	${MAKE} $(patsubst test-%,srv-%,$@)

$(addsuffix -sh,$(CNT_LIST)):
	docker exec -it $(patsubst %-sh,$(TST_NAME)-%,$@) sh -c 'exec $$(getent passwd root | sed "s/.*://g")'

$(addsuffix -env,$(CNT_LIST)):
	docker exec -it $(patsubst %-env,$(TST_NAME)-%,$@) env

$(addsuffix -logs,$(CNT_LIST)):
	docker container logs $(patsubst %-logs,$(TST_NAME)-%,$@)

$(addsuffix -diff,$(CNT_LIST)):
	docker container diff $(patsubst %-diff,$(TST_NAME)-%,$@)

$(addsuffix -tools,$(CNT_LIST)):
	docker exec -it $(patsubst %-tools,$(TST_NAME)-%,$@) \
	apk --no-cache --update add \
	nano less lsof htop openldap-clients bind-tools iputils mariadb-client

$(addsuffix -htop,$(CNT_LIST)):
	docker exec -it $(patsubst %-htop,$(TST_NAME)-%,$@) htop

$(addsuffix -imap,$(MTA_LIST)):
	docker run $(CURL_ENV) $(CURL_IMG) $(CURL_OPT) \
	imap://$(patsubst %-imap,$(TST_NAME)-%,$@)/inbox \
	-X "fetch * all" --ssl --anyauth -k -u $(AD_USR_CN):$(AD_USR_PW)

$(addsuffix -pop3,$(MTA_LIST)):
	docker run $(CURL_ENV) $(CURL_IMG) $(CURL_OPT) \
	pop3://$(patsubst %-pop3,$(TST_NAME)-%,$@)/1 \
	--ssl --anyauth -k -u $(AD_USR_CN):$(AD_USR_PW)

$(addsuffix -sv,$(MTA_LIST)):
	docker exec -it $(patsubst %-sv,$(TST_NAME)-%,$@) sh -c 'sv status $$SVDIR/*'

$(addsuffix -userdb,$(MTA_LIST)):
	docker exec -it $(patsubst %-userdb,$(TST_NAME)-%,$@) doveadm user $(AD_USR_CN)

$(addsuffix -doveconf,$(MTA_LIST)):
	docker exec -it $(patsubst %-doveconf,$(TST_NAME)-%,$@) doveconf -NP

$(addsuffix -regen-edh,$(MTA_LIST)):
	docker exec -it $(patsubst %-regen-edh,$(TST_NAME)-%,$@) conf update_postfix_dhparam

$(addsuffix -dkim-key,$(MTA_LIST)):
	docker exec -it $(patsubst %-dkim-key,$(TST_NAME)-%,$@) amavisd testkeys

$(addsuffix -spam-learn,$(MTA_LIST)):
	docker exec -it $(patsubst %-spam-learn,$(TST_NAME)-%,$@) amavis-learn.sh a

$(addsuffix -bayes-status,$(MTA_LIST)):
	docker exec -it $(patsubst %-bayes-status,$(TST_NAME)-%,$@) sa-learn --dump magic \
	| sed -r 's/[^ ]+\s+[^ ]+\s+([^ ]+).*non-token data: (.*)/\1\@\2/g' \
	| sed -r '/atime/s/(.*)@(.*)/echo $$(date --date=@\1 +%Y%b%d-%T)@\2/eg' \
	| column -t -s @

auth-test:
	docker exec $(AUT_NAME) ldapsearch

db-table:
	echo "select * from $(SQL_TAB)" | \
	docker exec -i $(DB_NAME) mysql -t -u$(SQL_BD_CN) -p$(SQL_BD_PW) $(SQL_DB)

db-auth:
	echo "select password, userid as user from $(SQL_TAB) where userid = \"$(AD_MX_CN)\"" | \
	docker exec -i $(DB_NAME) mysql -t -u$(SQL_BD_CN) -p$(SQL_BD_PW) $(SQL_DB)

$(addprefix test-tls_,25 465 587):
test-tls_%:
	$(eval tst_starttls := $(shell if [ $* != 465 ]; then echo --starttls smtp; fi ))
	docker run --rm -it --network $(NET_NAME) drwetter/testssl.sh $(tst_starttls) $(SRV_NAME):$* || true

#test-learn-bayes:
#	docker exec -it $(SRV_NAME) sh -c 'rm -f bayesian.database.gz && wget http://artinvoice.hu/spams/bayesian.database.gz && gunzip bayesian.database.gz && sa-learn --restore bayesian.database && chown -R amavis: /var/amavis && rm -rf bayesian.database'

#test-export-bayes:
#	docker exec -i $(SRV_NAME) sa-learn --backup > /tmp/bayesian.database.bak

#test-import-bayes: /tmp/bayesian.database.bak
#	docker cp /tmp/bayesian.database.bak $(SRV_NAME):/tmp/.
#	docker exec -it $(SRV_NAME) sh -c 'sa-learn --restore /tmp/bayesian.database.bak && chown -R amavis: /var/amavis/.spamassassin && rm -rf /tmp/bayesian.database.bak'

all-test_quiet:
	$(eval CURL_OPT := -s -S )

acme-destroy: ssl-destroy
	rm -f acme/*

acme/acme.json: $(SRV_CERT)
	bin/gen-acme-json.sh $(AD_USR_AD) $(SRV_FQDN) $(SRV_KEY) $(SRV_CERT) > $@
