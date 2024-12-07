# Road map

## Postfix configuration
### TLS Forward Secrecy

The built-in default Postfix FFDHE group is a 2048-bit group as of Postfix 3.1. You can optionally generate non-default Postfix SMTP server FFDHE parameters for possibly improved security against pre-computation attacks, but this is not necessary or recommended. Just leave "smtpd_tls_dh1024_param_file" at its default empty value. [TLS Forward Secrecy in Postfix](https://www.postfix.org/FORWARD_SECRECY_README.html)

```sh
/etc/postfix/main.cf: support for parameter "smtpd_tls_dh1024_param_file" will be removed; instead, do not specify (leave at default)
```
### Enable TLS

Dont use `smtpd_use_tls` anymore. `smtpd_tls_security_level=may` is sufficient.

```sh
/etc/postfix/main.cf: support for parameter "smtpd_use_tls" will be removed; instead, specify "smtpd_tls_security_level"
```

## PostSRSd

Arrange optional configuration of the [PostSRSd](https://github.com/roehling/postsrsd) Sender Rewriting Scheme (SRS) via TCP-based lookup tables for Postfix.

```sh
dd if=/dev/urandom bs=18 count=1 | base64 > /etc/postsrsd/postsrsd.secret
```

## ACME

Don't make DOCKER_ACME_SSL_DIR=/etc/ssl/acme persistent. We will remove all old certs and keys on updates anyway.

## Runit

Need to fix runit script for postfix. It does not kill all children.
the reason is that we don't let `runsvdir` become pid=1 and `postfix startup-fg`
checks for pid=1 and since it isn't start `master -s` instead of `exec master -i`
, see `/usr/libexec/postfix/postfix-script`.
