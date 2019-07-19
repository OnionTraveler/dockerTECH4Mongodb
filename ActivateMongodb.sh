#!/bin/bash

#========================= (Zookeeper、Broker1、Broker2的IP位置) =========================#
ipmongodb=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" mongodb`  # 172.19.0.2



docker exec -i mongodb /bin/bash << ONION
#========================= (建立資料庫預設存取的目錄位置)
mkdir -p /data/db

#========================= (啟動mongodb服務) (該服務精靈若要指定存取位置，可改為「bin/mongod --dbpath=/data/db」，其中「/data/db」是芒果資料庫的存取位智預設路徑)
cd /usr/mongodb/mongodb; bin/mongod > /dev/null
ONION

