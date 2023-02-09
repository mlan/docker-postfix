# 1.0.0

- [dovecot](src/dovecot/entry.d/10-dovecot-common) Now support both PLAIN and the legacy LOGIN authentication (SASL) mechanisms.
- [docker](Makefile) Use alpine:3.17 (postfix:3.7.4 dovecot:2.3.20).
- [repo](.) Based on [mlan/postfix-amavis](https://github.com/mlan/docker-postfix).
- [test](test) Cleanup tests.
- [test](test/Makefile) Increase sleep time `TST_W8DB` from 40 to 80 for travis-ci.
- [repo](Makefile) Now use functions in `bld.mk`.
- [repo](README.md) Updated the `docker-compose.yml` example.
- [repo](README.md) Added section on Milter support.
- [demo](demo/Makefile) Monitor logs to determine when clamd is activated.
- [test](.travis.yml) Updated dist to jammy.
