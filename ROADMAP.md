# Road map

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