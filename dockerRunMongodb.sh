#!/bin/bash

# docker network rm mongodb4onion
 [ `docker network ls | grep 'mongodb4onion' | cut -d ' ' -f 9` ] && echo "The network 「mongodb4onion」 has existed！" || docker network create -d bridge mongodb4onion


 [ `docker images | grep 'oniontraveler/mongodb_container' | cut -d ' ' -f 1,4 --output-delimiter=':'` ] && echo "The image 「oniontraveler/mongodb_container:19.7.20」 has existed！" || docker build -f ./myDockerfiles/onionfile -t oniontraveler/mongodb_container:19.7.20 .

 [ `docker ps -a | grep 'mongodb' | rev | cut -d ' ' -f 1 | rev` ] && echo "The container 「mongodb」 has existed" || docker run -itd --name mongodb --hostname mongodb -p 27018:27017 --network=mongodb4onion oniontraveler/mongodb_container:19.7.20



#========================= (port explanation)
# -p 「實體主機host」:「容器container」
# -p 27018:27017 -> Mongodb


#========================= (docker commands for entering into the container(Zookeeper、Broker1、Broker2))
# docker exec -it mongodb /bin/bash


#========================= (docker commands for remove all containers)
# docker stop mongodb
# docker rm mongodb

