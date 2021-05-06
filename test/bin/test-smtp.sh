#!/bin/bash

TESTSMTP_SMTPHOST=localhost
TESTSMTP_SMTPPORT=25
TESTSMTP_MAILFROM=postmaster@example.com
TESTSMTP_MAILTO=postmaster@localhost

#
# define function
#

test_smtp() {
	local host=${1-$TESTSMTP_SMTPHOST}
	local port=${2-$TESTSMTP_SMTPPORT}
	local from=${3-$TESTSMTP_MAILFROM}
	local to=${4-$TESTSMTP_MAILTO}
	local from_name=${from%@*}
	local to_name=${to%@*}
	local domain=${from#*@}
	nc -C $host $port <<-!nc
		EHLO $domain
		MAIL FROM:<$from>
		RCPT TO:<$to>
		DATA
		From: $from_name <$from>
		To: $to_name <$to>
		Subject: A test message generated on $(hostname)
		Hello $name
		Local time is now: $(date)
		.
		QUIT
	!nc
	}

#
# run
#

test_smtp "$@"
