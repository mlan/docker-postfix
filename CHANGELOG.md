# 1.0.3

- [docker](Makefile) Use alpine:3.19 (postfix:3.8.3 dovecot:2.3.21).

# 1.0.2

- [docker](Makefile) Use alpine:3.18 (postfix:3.8.3 dovecot:2.3.20).
- [docker](src/docker) Improve debug message in [docker-service.sh](src/docker/bin/docker-service.sh).
- [repo](README.md) Added section on Authentication (SASL) Mechanisms.

# 1.0.1

- [docker](Makefile) Use alpine:3.18 (postfix:3.8.1 dovecot:2.3.20).
- [test](test/Makefile) Now use the `mariadb` instead of `mysql` command in MariaDB image.
- [test](demo/Makefile) Now use the `mariadb-show` instead of `mysqlshow` command in MariaDB image.

# 1.0.0

- [docker](Makefile) Use alpine:3.18 (postfix:3.8.0 dovecot:2.3.20).
- [github](.github/workflows/testimage.yml) Now use GitHub Actions to test image.
- [demo](demo/Makefile) Now depend on the `docker-compose-plugin`.
- [demo](demo/Makefile) Fix the broken `-diff` target.
- [dovecot](src/dovecot/entry.d/10-dovecot-common) Now support both PLAIN and the legacy LOGIN authentication (SASL) mechanisms.
- [repo](.) Based on [mlan/postfix-amavis](https://github.com/mlan/docker-postfix).
- [test](test) Cleanup tests.
- [test](test/Makefile) Increase sleep time `TST_W8DB` from 40 to 80 for travis-ci.
- [repo](Makefile) Now use functions in `bld.mk`.
- [repo](README.md) Updated the `docker-compose.yml` example.
- [repo](README.md) Added section on Milter support.
- [demo](demo/Makefile) Monitor logs to determine when clamd is activated.
- [test](.travis.yml) Updated dist to jammy.
