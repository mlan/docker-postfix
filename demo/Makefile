# Makefile
#
# demo
#

-include    *.mk .env .init.env

SRV_LIST ?= auth app db mta flt

AD_DOM   ?= $(call ad_sub_dot, $(AD_BASE))
AD_DC    ?= $(call ad_cut_dot, 1, 1, $(AD_DOM))

SSL_O     = $(MAIL_DOMAIN)
SSL_MAIL  = auto
SSL_PASS  = $(AD_USR_PW)
#SSL_TRST  = $(SSL_SMIME)

NET_NAME ?= $(COMPOSE_PROJECT_NAME)_backend
CURL_OPT ?= -s -v
TSSL_CMD ?= docker run -i --rm --network $(NET_NAME) drwetter/testssl.sh
CURL_CMD ?= curl
webb_avl := $(shell command -v browse 2> /dev/null || command -v firefox 2> /dev/null)
webb_cmd ?= $(webb_avl) $(1) &
APP_NAME  = app
AUT_NAME  = auth
AUW_NAME  = auth-web
DB_NAME   = db
DBW_NAME  = db-web
MTA_NAME  = mta
FLT_NAME  = flt
APP_FQDN ?= $(call dkr_srv_ip,$(APP_NAME))
AUT_FQDN ?= $(call dkr_srv_ip,$(AUT_NAME))
AUW_FQDN ?= $(call dkr_cnt_ip,$(AUW_NAME))
DB_FQDN  ?= $(call dkr_srv_ip,$(DB_NAME))
DBW_FQDN ?= $(call dkr_cnt_ip,$(DBW_NAME))
MTA_FQDN ?= $(call dkr_srv_ip,$(MTA_NAME))
FLT_FQDN ?= $(call dkr_srv_ip,$(FLT_NAME)):11334

MAIL_FROM ?= test@$(MAIL_DOMAIN) #test@my-domain.biz
MAIL_TYPE ?= text/plain

HAM_URL ?= https://www2.aueb.gr/users/ion/data/enron-spam/raw/ham/beck-s.tar.gz
SPAM_URL ?= https://www2.aueb.gr/users/ion/data/enron-spam/raw/spam/BG.tar.gz

variables:
	make -pn | grep -A1 "^# makefile"| grep -v "^#\|^--" | sort | uniq

test: all-test_quiet mta-test_smtp

init: up auth-init db-init mta-init app-init

#init: up auth-init db-init app-restart mta-init wait_99 app-init

ps:
	docker compose ps

up:
	docker compose up -d

down:
	docker compose down

destroy: auth-web-down db-web-down all-destroy_smime
	docker compose down -v

config:
	docker compose config

logs:
	docker compose logs --tail 10

images:
	docker compose images

$(addsuffix -up,$(SRV_LIST)):
	docker compose up -d $(patsubst %-up,%,$@)

$(addsuffix -down,$(SRV_LIST)):
	docker compose rm -sf $(patsubst %-down,%,$@)

$(addsuffix -restart,$(SRV_LIST)):
	docker compose restart $(patsubst %-restart,%,$@)

$(addsuffix -renew,$(SRV_LIST)):
	docker compose rm -s $(patsubst %-renew,%,$@)
	docker compose up -d $(patsubst %-renew,%,$@)

$(addsuffix -top,$(SRV_LIST)):
	docker compose top $(patsubst %-top,%,$@)

$(addsuffix -logs,$(SRV_LIST)):
	docker compose logs $(patsubst %-logs,%,$@)

$(addsuffix -pull,$(SRV_LIST)):
	docker compose pull $(patsubst %-pull,%,$@)

$(addsuffix -sh,$(SRV_LIST)):
	docker compose exec $(patsubst %-sh,%,$@) sh -c 'exec $$(getent passwd root | sed "s/.*://g")'

$(addsuffix -env,$(SRV_LIST)):
	docker compose exec $(patsubst %-env,%,$@) env

$(addsuffix -sv,$(SRV_LIST)):
	docker compose exec $(patsubst %-sv,%,$@) sh -c 'sv status $$SVDIR/*'

$(addsuffix -diff,$(SRV_LIST)):
	docker container diff $(call dkr_srv_cnt,$(patsubst %-diff,%,$@))

$(addsuffix -hostaddr,$(SRV_LIST)):
	$(eval myhost := $(call dkr_srv_ip,$(patsubst %-hostaddr,%,$@)))

wait_%:
	sleep $*

web: app-web

auth-init: wait_3 auth-mod_conf auth-add_schema auth-add_data

export define LDIF_MOD_CONF
dn: olcDatabase={-1}frontend,cn=config
changetype: modify
add: olcPasswordHash
olcPasswordHash: {CRYPT}

dn: cn=config
changetype: modify
add: olcPasswordCryptSaltFormat
olcPasswordCryptSaltFormat: $$6$$%.16s

dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: cn,ou,uid,mail eq
endef

export define LDIF_ADD_DATA
dn: $(AD_BASE)
objectClass: organization
objectClass: dcObject
dc: $(AD_DC)
o: $(AD_DOM)

dn: ou=$(AD_USR_OU),$(AD_BASE)
ou: $(AD_USR_OU)
objectClass: organizationalUnit

dn: ou=$(AD_GRP_OU),$(AD_BASE)
ou: $(AD_GRP_OU)
objectClass: organizationalUnit

dn: cn=$(AD_GRP_CN),ou=$(AD_GRP_OU),$(AD_BASE)
cn: $(AD_GRP_CN)
objectClass: groupOfNames
objectClass: kopano-group
member: uid=$(AD_ADM_CN),ou=$(AD_USR_OU),$(AD_BASE)
member: uid=$(AD_USR_CN),ou=$(AD_USR_OU),$(AD_BASE)
mail: $(AD_GRP_CN)@$(MAIL_DOMAIN)

dn: uid=$(AD_ADM_CN),ou=$(AD_USR_OU),$(AD_BASE)
changetype: add
cn: $(AD_ADM_CN)
objectClass: inetOrgPerson
objectClass: kopano-user
sn: $(AD_ADM_CN)
uid: $(AD_ADM_CN)
mail: $(AD_ADM_CN)@$(MAIL_DOMAIN)
userPassword: $(AD_ADM_PW)
telephoneNumber: $(AD_ADM_TEL)
title: $(AD_ADM_TIT)
kopanoAccount: 1
kopanoAdmin: 1
kopanoEnabledFeatures: imap
kopanoEnabledFeatures: pop3

dn: uid=$(AD_USR_CN),ou=$(AD_USR_OU),$(AD_BASE)
changetype: add
cn: $(AD_USR_CN)
objectClass: inetOrgPerson
objectClass: kopano-user
sn: $(AD_USR_CN)
uid: $(AD_USR_CN)
mail: $(AD_USR_CN)@$(MAIL_DOMAIN)
userPassword: $(AD_USR_PW)
telephoneNumber: $(AD_USR_TEL)
title: $(AD_USR_TIT)
kopanoAccount: 1
kopanoAliases: $(AD_USR_AS)@$(MAIL_DOMAIN)
kopanoEnabledFeatures: imap
kopanoEnabledFeatures: pop3

dn: uid=$(AD_SHR_CN),ou=$(AD_USR_OU),$(AD_BASE)
cn: $(AD_SHR_CN)
objectClass: inetOrgPerson
objectClass: kopano-user
sn: $(AD_SHR_CN)
uid: $(AD_SHR_CN)
mail: $(AD_SHR_CN)@$(MAIL_DOMAIN)
kopanoAccount: 1
kopanoSharedStoreOnly: 1

dn: uid=$(AD_PUB_CN),ou=$(AD_USR_OU),$(AD_BASE)
cn: $(AD_PUB_CN)
objectClass: inetOrgPerson
objectClass: kopano-user
sn: $(AD_PUB_CN)
uid: $(AD_PUB_CN)
mail: $(AD_PUB_CN)@$(MAIL_DOMAIN)
kopanoAccount: 1
kopanoHidden: 1
kopanoSharedStoreOnly: 1
kopanoResourceType: publicFolder:Public Stores/public
endef

PLAIN_SUBJ = Test message.
PLAIN_MESS = Great news! You can receive email.
GTUBE_SUBJ = GTUBE spam message.
GTUBE_MESS = XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X
EICAR_SUBJ = EICAR virus message.
EICAR_MESS = X5O!P%@AP[4\PZX54(P^)7CC)7}\$$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!\$$H+H*
EICAR_TYPE = audio/basic
RANDS_SUBJ = $(shell shuf -n 3 /usr/share/dict/words | tr '\n' ' ')
RANDS_MESS = $(shell shuf -n 200 /usr/share/dict/words | tr '\n' ' ')

define messid
$(shell echo $$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c8)@dot.com)
endef

define head_mail
@echo -e "From: <$(1)>\nTo: <$(2)>\nDate: $$(date -R)\nMessage-ID: <$(messid)>\nMIME-Version: 1.0\nContent-type: $(if $(5),$(5),$(MAIL_TYPE))\nSubject: $(3)\n\n$(if $(4),$(4),$(PLAIN_MESS))\n" | tee /dev/tty
endef

define smtp_mail
$(call head_mail,$(2),$(3),$(4),$(5),$(6)) \
| $(CURL_CMD) $(1) -T - --mail-from $(2) --mail-rcpt $(3) $(CURL_OPT)
endef

define lmtp_mail
printf "LHLO mx\nMAIL FROM: <$(2)>\nRCPT TO: <$(3)>\nDATA\
\nFrom: <$(2)>\nTo: <$(3)>\nDate: $$(date -R)\nSubject: $(4)\
\n\nGreat news! You can receive email.\n.\nQUIT\n" | tee /dev/tty \
| $(CURL_CMD) $(1) -T - $(CURL_OPT)
endef

export define MAKE_UTILS_CONTAINER
CURL_CMD ?= docker run -i --rm --network $(NET_NAME) curlimages/curl
webb_cmd ?= docker run -d --rm --network $(NET_NAME) \
-e DISPLAY=$$$$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
-v /etc/localtime:/etc/localtime:ro -v $$$$(pwd)/ssl:/ssl \
kennethkl/firefox $$(1)
APP_FQDN ?= $(APP_NAME)
AUT_FQDN ?= $(AUT_NAME)
AUW_FQDN ?= $(AUW_NAME)
DB_FQDN  ?= $(DB_NAME)
DBW_FQDN ?= $(DBW_NAME)
MTA_FQDN ?= $(MTA_NAME)
FLT_FQDN ?= $(FLT_NAME)
endef

utils-container:
	echo "$$MAKE_UTILS_CONTAINER" > utils-container.mk

utils-default:
	rm -f utils-container.mk

auth-mod_conf:
	echo "$$LDIF_MOD_CONF" | docker compose exec -T auth ldapmodify -Q

auth-add_data:
	echo "$$LDIF_ADD_DATA" | docker compose exec -T auth ldapadd -Q

auth-add_schema:
	docker compose exec app zcat /usr/share/doc/kopano/kopano.ldif.gz \
	| docker compose exec -T auth ldapadd -Q

auth-show_conf:
	docker compose exec auth ldapsearch -QLLLb cn=config "(cn=config)"
	docker compose exec auth ldapsearch -QLLLb cn=config olcDatabase={-1}frontend
	docker compose exec auth ldapsearch -QLLLb cn=config olcDatabase={1}mdb

auth-show_data:
	docker compose exec auth ldapsearch -QLLL

auth-show_cat0:
	docker compose exec auth slapcat -n0

auth-show_cat1:
	docker compose exec auth slapcat -n1

auth-web: auth-web-up
	sleep 2
	$(call webb_cmd,http://$(AUW_FQDN))

auth-web-up:
	docker run -d --name $(AUW_NAME) --network $(NET_NAME) \
	-e PHPLDAPADMIN_LDAP_HOSTS=auth -e PHPLDAPADMIN_HTTPS=false \
	osixia/phpldapadmin || true

auth-web-down:
	docker rm -f $(AUW_NAME) || true

mta-init:

mta-edh:
	docker compose exec mta run postfix_update_dhparam

mta-test_smtp:
	$(call smtp_mail,smtp://$(MTA_FQDN),$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),$(PLAIN_SUBJ))

mta-test_rand:
	$(call smtp_mail,smtp://$(MTA_FQDN),$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),$(RANDS_SUBJ),$(RANDS_MESS))

mta-test_gtube:
	$(call smtp_mail,smtp://$(MTA_FQDN),$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),$(GTUBE_SUBJ),$(GTUBE_MESS))

mta-test_eicar:
	$(call smtp_mail,smtp://$(MTA_FQDN),$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),$(EICAR_SUBJ),$(EICAR_MESS),$(EICAR_TYPE))

mta-test_regexp:
	$(call smtp_mail,smtp://$(MTA_FQDN),$(MAIL_FROM),$(AD_USR_CN)+info@$(MAIL_DOMAIN),A regexp SMTP test message.)

mta-test_smtps:
	$(call smtp_mail,smtps://$(MTA_FQDN),$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),A secure SMTPS test message.) \
	-k --login-option "AUTH=LOGIN" -u $(AD_USR_CN):$(AD_USR_PW)

mta-test_shared: all-test_quiet
	$(call smtp_mail,smtp://$(MTA_FQDN),$(MAIL_FROM),$(AD_SHR_CN)@$(MAIL_DOMAIN),A shared SMTP test message.)

mta-test_public: all-test_quiet
	$(call smtp_mail,smtp://$(MTA_FQDN),$(MAIL_FROM),$(AD_PUB_CN)@$(MAIL_DOMAIN),A public SMTP test message.)

mta-tools:
	docker compose exec mta apk --no-cache --update add \
	nano less lsof htop openldap-clients bind-tools iputils strace iproute2

mta-apk_list:
	docker compose exec mta /bin/sh -c 'for pkg in $$(apk info 2>/dev/null); do printf "%9s %3s %s\n" $$(apk info -s $$pkg 2>/dev/null | sed -n "2{p;q}") $$pkg; done | sort | sort -k 2,2'

mta-htop: mta-tools
	docker compose exec mta htop

mta-encrypt:
	$(eval secret := $(shell whiptail --backtitle "doveadm pw" --title "encrypt password" --inputbox "password" 8 78 secret 3>&1 1>&2 2>&3))
	docker compose exec mta doveadm pw -p $(secret)

mta-show_doveconf:
	docker compose exec mta doveconf -n

mta-show_postconf:
	docker compose exec mta postconf -n

mta-show_mailq:
	docker compose exec mta mailq

mta-flush_mailq:
	docker compose exec mta postqueue -f

mta-test_auth:
	docker compose exec mta doveadm auth test $(AD_USR_CN) $(AD_USR_PW)

mta-man:
	docker compose exec mta apk --no-cache --update add \
	man-db man-pages apk-tools-doc postfix-doc cyrus-sasl-doc dovecot-doc

flt-init:
	docker compose exec flt sh -c 'rspamadm configwizard; sv restart rspamd'

flt-clamdtop:
	docker compose exec flt clamdtop

flt-reload:
	docker compose exec flt /bin/sh -c 'echo RELOAD | nc localhost 3310'

flt-ping:
	docker compose exec flt /bin/sh -c 'echo PING | nc localhost 3310'

flt-tools:
	docker compose exec flt apk --no-cache --update add \
	nano less lsof htop openldap-clients bind-tools iputils strace iproute2 curl

flt-man:
	docker compose exec flt apk --no-cache --update add \
	man-db man-pages apk-tools-doc clamav-doc rspamd-doc

flt-apk_list:
	docker compose exec flt /bin/sh -c 'for pkg in $$(apk info 2>/dev/null); do printf "%9s %3s %s\n" $$(apk info -s $$pkg 2>/dev/null | sed -n "2{p;q}") $$pkg; done | sort | sort -k 2,2'

flt-web:
	$(call webb_cmd,http://$(FLT_FQDN))

flt-test: flt-test_plain flt-test_gtube flt-test_eicar

flt-test_plain:
	$(call head_mail,$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),$(PLAIN_SUBJ)) \
	| docker compose exec -T flt rspamc --hostname localhost

flt-test_gtube:
	$(call head_mail,$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),$(GTUBE_SUBJ),$(GTUBE_MESS)) \
	| docker compose exec -T flt rspamc --hostname localhost

flt-test_eicar:
	$(call head_mail,$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),$(EICAR_SUBJ),$(EICAR_MESS),$(EICAR_TYPE)) \
	| docker compose exec -T flt rspamc --hostname localhost

flt-passwd:
	docker compose exec flt rspamadm pw

flt-bayes_init:
	docker compose exec flt sh -c 'mkdir -p /tmp/ham && wget --no-check-certificate -O - $(HAM_URL)  | tar -xzC /tmp/ham && rspamc learn_ham /tmp/ham'
	docker compose exec flt sh -c 'mkdir -p /tmp/spam && wget --no-check-certificate -O - $(SPAM_URL) | tar -xzC /tmp/spam && rspamc learn_spam /tmp/spam'

flt-stat:
	docker compose exec flt rspamc stat

flt-config:
	docker compose exec flt rspamadm configdump

flt-config_%:
	docker compose exec flt rspamadm configdump $*

$(addprefix flt-config_,actions antivirus classifier dkim dkim_signing greylist group.statistics logging metric milter_headers options redis worker):

db-init:

db-test:
	docker compose exec db mysqlshow -u $(MYSQL_USER) $(MYSQL_DATABASE) -p$(MYSQL_PASSWORD)

db-web: db-web-up
	sleep 2
	$(call webb_cmd,http://$(DBW_FQDN))

db-web-up:
	docker run -d --name $(DBW_NAME) --network $(NET_NAME) \
	-e PMA_HOST=db phpmyadmin/phpmyadmin || true

db-web-down:
	docker rm -f $(DBW_NAME) || true

app-init: app-wait app-public_store app-create_smime

app-wait:
	#
	# Waiting for kopano-server to initialize.
	#
	time docker compose logs -f app | sed -n '/Startup succeeded/{p;q}'
	#
	# kopano-server ready.
	#

app-tools:
	docker compose exec app apt update
	docker compose exec app apt install --yes \
	less nano ldap-utils htop net-tools lsof iputils-ping dnsutils strace

app-htop: app-tools
	docker compose exec app htop

app-test_smtp: mta-test_smtp

app-test_lmtp:
	$(call lmtp_mail,telnet://$(APP_FQDN):2003,$(MAIL_FROM),$(AD_USR_CN)@$(MAIL_DOMAIN),A LMTP test message.)

app-test_all: all-test_muted $(addprefix app-test_,imap pop3 ical imaps pop3s icals)

app-test_imap:
	$(CURL_CMD) imap://$(APP_FQDN) -u $(AD_USR_CN):$(AD_USR_PW) $(CURL_OPT)

app-test_imaps:
	$(CURL_CMD) imaps://$(APP_FQDN) -k -u $(AD_USR_CN):$(AD_USR_PW) $(CURL_OPT)

app-test_pop3:
	$(CURL_CMD) pop3://$(APP_FQDN) -u $(AD_USR_CN):$(AD_USR_PW) $(CURL_OPT)

app-test_pop3s:
	$(CURL_CMD) pop3s://$(APP_FQDN) -k -u $(AD_USR_CN):$(AD_USR_PW) $(CURL_OPT)

app-test_ical:
	$(CURL_CMD) http://$(APP_FQDN):8080 -u $(AD_USR_CN):$(AD_USR_PW) $(CURL_OPT)

app-test_icals:
	$(CURL_CMD) https://$(APP_FQDN):8443 -k -u $(AD_USR_CN):$(AD_USR_PW) $(CURL_OPT)

app-test_tls:
	$(TSSL_CMD) $(APP_FQDN):993 || true

app-test_oof1:
	docker compose exec app kopano-oof -u $(AD_USR_CN) -m 1 -t "Dunno when I return"

app-test_oof0:
	docker compose exec app kopano-oof -u $(AD_USR_CN) -m 0

app-stats_server:
	docker compose exec app kopano-stats --system

app-show_server:
	docker compose exec app kopano-stats --top

app-show_user1:
	docker compose exec app kopano-admin --details $(AD_USR_CN)

app-show_user2: app-tools
	docker compose exec app ldapsearch -H ldap://auth:389 -xLLL -b $(AD_BASE) '*'

app-show_sync:
	docker compose exec app z-push-top

app-create_store:
	docker compose exec app kopano-admin --create-store $(AD_USR_CN)

app-public_store:
	docker compose exec app kopano-storeadm -P

#app-add_user:
#	docker compose exec app kopano-admin -c $(AD_USR_CN) -p $(AD_USR_PW) \
#	-e $(AD_USR_CN)@$(MAIL_DOMAIN) -f $(AD_USR_CN) -a 1

$(addprefix app-parms_,archiver dagent gateway ical ldap search server spamd spooler):
	docker compose exec app run list_parms $(patsubst app-parms_%,%,$@)

app-create_smime: all-create_smime
	docker cp ssl/ca.crt $(call dkr_srv_cnt,app):/usr/local/share/ca-certificates/$(MAIL_DOMAIN)_CA.crt
	docker compose exec app update-ca-certificates

app-web:
	$(call webb_cmd,http://$(APP_FQDN))

all-test_quiet:
	$(eval CURL_OPT := -s -S )

all-test_muted:
	$(eval CURL_OPT := -s -S >/dev/null || true)

all-create_smime: ssl/$(AD_USR_CN).p12

all-destroy_smime: ssl-destroy
