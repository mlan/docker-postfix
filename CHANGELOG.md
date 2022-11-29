# 0.9.0

- [docker](Makefile) Use alpine:3.17 (postfix:3.7.3 dovecot:2.3.19.1).
- [repo](.) Based on [mlan/postfix-amavis](https://github.com/mlan/docker-postfix).
- [test](test) Cleanup tests.
- [repo](Makefile) Now use functions in `bld.mk`.
- [repo](README.md) Updated the `docker-compose.yml` example.
- [repo](README.md) Added section on Milter support.
- [demo](demo/Makefile) Monitor logs to determine when clamd is activated.
