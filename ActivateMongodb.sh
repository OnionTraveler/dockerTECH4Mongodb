#!/bin/bash

#========================= (Zookeeper、Broker1、Broker2的IP位置) =========================#
ipmongodb=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" mongodb`  # 172.19.0.2



docker exec -i mongodb /bin/bash << ONION
#========================= (建立預設資料庫存取位置)
mkdir -p /data/db

#========================= (啟動mongodb服務)
cd /usr/mongodb/mongodb; bin/mongod > /dev/null
ONION


