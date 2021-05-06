# ad.mk
#
# AD and LDAP   make-functions
#

#
# chars
#
char_null  :=
char_space := $(char_null) #
char_comma := ,
char_dot   := .
char_colon := :

#
# $(call ad_sub_dc,example.com) -> dc=example,dc=com
#
ad_sub_dc   = $(subst $(char_space),$(char_comma),$(addprefix dc=, $(subst ., ,$(1))))
#
# $(call ad_sub_dot,dc=example,dc=com) -> example.com
#
ad_sub_dot  = $(subst $(char_comma)dc=,$(char_dot),$(patsubst dc=%,%,$(1)))
#
# $(call ad_cat_dn,admin,dc=example,dc=com) -> cn=admin,dc=example,dc=com
#
ad_cat_dn   = cn=$(1),$(2)
#
# $(call ad_cut_dot,1,1,example.com) -> example
#
ad_cut_dot  = $(subst $(char_space),$(char_dot),$(wordlist $(1), $(2), $(subst $(char_dot),$(char_space),$(3))))
#
# $(call ad_rootdc,2,9,adm.dom.org:secret) -> dom.org
#
ad_rootdc   = $(subst $(char_space),$(char_dot),$(wordlist $(1), $(2), $(subst $(char_dot),$(char_space),$(firstword $(subst $(char_colon),$(char_space),$(3))))))
#
# $(call ad_rootpw,adm.dom.org:secret) -> secret
#
ad_rootpw   = $(lastword $(subst $(char_colon),$(char_space),$(1)))
