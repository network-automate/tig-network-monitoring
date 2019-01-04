build-telegraf-conf:
	@echo "======================================================================"
	@echo "Build telegraf configuration files from template"
	@echo "======================================================================"
	python ./render-telegraf-configuration.py -o 'configs/telegraf-openconfig.conf' -t 'templates/telegraf-openconfig.j2' -y 'data.yml'
	python ./render-telegraf-configuration.py -o 'configs/telegraf-snmp.conf' -t 'templates/telegraf-snmp.j2' -y 'data.yml'

grafana-cli:
	@echo "======================================================================"
	@echo "start a shell session in the grafana container"
	@echo "======================================================================"
	docker exec -i -t grafana /bin/bash

telegraf-openconfig-cli:
	@echo "======================================================================"
	@echo "start a shell session in the telegraf container for Openconfig"
	@echo "======================================================================"
	docker exec -i -t telegraf-openconfig /bin/bash

telegraf-snmp-cli:
	@echo "======================================================================"
	@echo "start a shell session in the telegraf container for SNMP"
	@echo "======================================================================"
	docker exec -i -t telegraf-snmp /bin/bash

influxb-cli:
	@echo "======================================================================"
	@echo "start a shell session in the influxb container"
	@echo "======================================================================"
	docker exec -it influxdb bash

restart: stop start
rebuild: destroy build-telegraf-conf build

build:
	@echo "======================================================================"
	@echo "create docker networks, pull docker images, create and start docker containers"
	@echo "======================================================================"
	python ./render-telegraf-configuration.py -o 'docker-compose.yml' -t 'templates/docker-compose-tig.j2' -y 'data.yml'
	docker-compose -f ./docker-compose.yml up -d

destroy:
	@echo "======================================================================"
	@echo "stop docker containers, remove docker containers, remove docker networks"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml down

start:
	@echo "======================================================================"
	@echo "Start docker containers"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml start

stop:
	@echo "======================================================================"
	@echo "Stop docker containers"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml stop
