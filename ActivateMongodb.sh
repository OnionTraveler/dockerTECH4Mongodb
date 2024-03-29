#!/bin/bash

#========================= (mongodb的IP位置) =========================#
ipmongodb=`docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" mongodb`  # 172.19.0.2
echo "ipmongodb is $ipmongodb" > /tmp/ipmongodb.txt && cat /tmp/ipmongodb.txt && rm -rf /tmp/ipmongodb.txt


docker exec -i mongodb /bin/bash << ONION
#========================= (建立資料庫預設存取的目錄位置)
 [ -d /data/db ] && echo 'The directory 「/data/db」 has existed' || mkdir -p /data/db

#========================= (更改mongodb的參數設定)
cd /usr/mongodb/mongodb/bin/; [ -e mongod.conf ] && echo "The 「mongod.conf」 file has existed" || cat >> /usr/mongodb/mongodb/bin/mongod.conf << onion
verbose = true
dbpath = /data/db
logpath = /var/log/mongodb.log
logappend = true
# bind_ip 指的是【mongod在其所在的機台上，所要與此機台裡某IP位置建立關係(稱為綁定)】，以利於別人(client)可以經由「本組IP」與「port號」這個媒介來訪問mongod
# 「127.0.0.1」為特殊IP，「bind_ip=127.0.0.1」表示mongod與本機台的內網綁定，因此僅供本機內部的程式(from pymongo import MongoClient; conn = MongoClient("mongodb://127.0.0.1:27018/"))或芒果指令(./mongo)來訪問mongod
# 「$ipmongodb」為本mongod所在container的IP，若別機台(仍須同個網域)要來連入此mongod，則「from pymongo import MongoClient; conn = MongoClient("mongodb://$ipmongodb:27018/")」或「./mongo --host $ipmongodb --port 27018」
# 「0.0.0.0」為特殊IP，「bind_ip=0.0.0.0」表示mongod與本機台之能與外網溝通的IP綁定，則所有機台皆可連入本機台訪問mongod
bind_ip=127.0.0.1, $ipmongodb
port = 27018
onion

#========================= (啟動mongodb服務) (該服務精靈若要指定存取位置，可改為「bin/mongod --dbpath=/data/db」，其中「/data/db」是芒果資料庫的存取位置預設路徑)
cd /usr/mongodb/mongodb; bin/mongod --config /usr/mongodb/mongodb/bin/mongod.conf > /dev/null 2>&1
ONION










#========================= (若使用「dockerTECH4onionDevlpmtEnvrmt」的容器作為client端，欲訪問mongodb_container這個伺服端，須將onionDE這個容器連到與mongodb_container相同之網域上)
# docker network connect mongodb4onion onionDE

# docker inspect --format "{{ .NetworkSettings.Networks.onionDENET.IPAddress }}" onionDE
# docker inspect --format "{{ .NetworkSettings.Networks.mongodb4onion.IPAddress }}" onionDE
# docker inspect --format "{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}" onionDE

