# dkr.mk
#
# Container   make-functions
#

#
# $(call dkr_srv_cnt,app) -> d03dda046e0b90c...
#
dkr_srv_cnt = $(shell docker-compose ps -q $(1) | head -n1)
#
# $(call dkr_cnt_ip,demo-app-1) -> 172.28.0.3
#
dkr_cnt_ip   = $(shell docker inspect -f \
	'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
	$(1) | head -n1)
#
# $(call dkr_srv_ip,app) -> 172.28.0.3
#
dkr_srv_ip   = $(shell docker inspect -f \
	'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
	$$(docker-compose ps -q $(1)) | head -n1)
#
# $(call dkr_cnt_pid,demo-app-1) -> 9755
#
dkr_cnt_pid  = $(shell docker inspect --format '{{.State.Pid}}' $(1))
#
#cnt_ip_old = $(shell docker inspect -f \
#	'{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}' \
#	$(1) | head -n1)

#
# $(call dkr_cnt_state,demo-app-1) -> running
#
dkr_cnt_state = docker inspect -f '{{.State.Status}}' $(1)

#
# $(call dkr_cnt_timeout,180,demo-app-1) -> wait up to 180s for demo-app-1 to enter state running
#
dkr_cnt_timeout = for i in {1..$(1)}; do sleep 1; if [ "$$($(call dkr_cnt_state, $(2)))" = "running" ]; then echo $(2) running in $${i}s; break; fi; done

#
# $(call dkr_srv_timeout,180,app) -> wait up to 180s for app to enter state running
#
dkr_srv_timeout = $(call dkr_cnt_timeout,$(1),$(call dkr_srv_cnt $(2)))

#
# $(call dkr_cnt_wait,app,ready for connections) -> time docker logs -f app | sed -n '/ready for connections/{p;q}'
#
dkr_cnt_wait = time docker logs -f $(1) 2>&1 | sed -n '/$(2)/{p;q}'

#
# List IPs of containers
#
ip-list:
	@for srv in $$(docker ps --format "{{.Names}}"); do \
	echo $$srv $$(docker inspect -f \
	'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $$srv); \
	done | column -t
