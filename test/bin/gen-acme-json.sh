#!/bin/bash
# args: email hostname keyfile certfile
mail=$1
host=$2
keyfile=$3
certfile=$4

#
# The "PrivateKey": attribute needs a PKCS#1 key without tags and line breaks
# "openssl req -newkey rsa" generates a key stored in PKCS#8 so needs conversion
#
#acme_strip_tag() { openssl rsa -in $1 | sed '/^-----/d' | sed ':a;N;$!ba;s/\n//g' ;}
acme_strip_tag() { sed '/^-----/d' $1 | sed ':a;N;$!ba;s/\n//g' ;}

cat <<-!cat
{
  "Account": {
    "Email": "$mail",
    "Registration": {
      "body": {
        "status": "valid",
        "contact": [
          "mailto:$mail"
        ]
      },
      "uri": "https://acme-v02.api.letsencrypt.org/acme/acct/$RANDOM"
    },
    "PrivateKey": "$(acme_strip_tag $keyfile)",
    "KeyType": "2048"
  },
  "Certificates": [
    {
      "Domain": {
        "Main": "$host",
        "SANs": null
      },
      "Certificate": "$(base64 -w 0 $certfile)",
      "Key": "$(base64 -w 0 $keyfile)"
    }
  ],
  "HTTPChallenges": {},
  "TLSChallenges": {}
}
!cat
