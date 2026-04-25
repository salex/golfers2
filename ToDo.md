ToDo.md
to login to remote console
  kamal app exec -i bash

this is my attempt to copy a development sqlite3 database to a container

First create an imports and backups directory in /root

rsync the local file to the imports directory

rsync -av production.sqlite3 root@165.245.134.38:/root/imports/production-2026-04-24.sqlite3

first simple try it to copy that file to the containers /storage directory

get the container id

CONTAINER_ID=$(docker ps --filter name=golfers2 --format '{{.ID}}')

to see its value
  echo $CONTAINER_ID

the docker cp help

root@rails8-kamal:~/imports# docker cp --help
Usage:  
  docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
  docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH

  docker exec $CONTAINER_ID sqlite3 /rails/storage/production.sqlite3 ".backup /tmp/backup.sqlite3"

  docker cp $CONTAINER_ID:/tmp/backup.sqlite3 golfers2-2026-04-25.sqlite3

so look like to cp localhost file in imports dir to container
  stop the container while in the app directory (home)/work/rails8/(app)

  kamal app stop 

  copy the db to the container

  docker cp  /root/imports/production-2026-04-24.sqlite3 $CONTAINER_ID:/rails/storage/production.sqlite3 

  kamal app start (and hope you didn't screw up!)


Here we go
  use 2 terminal windows - one to the vfs, one to the app directory

  login to the vps 

    sshkamal 
    cd imports

  go to app directory
    cd work/rails8/golfers2

  stop the container
    kamal app stop

  NOPE!!! has to be running

  back to the vfs thats in the imports dir

  set the container id 

  copy the import file to the container

  CONTAINER_ID=$(docker ps --filter name=golfers2 --format '{{.ID}}')

  echo $CONTAINER_ID
  89c591b0d8bd

copy new version
  docker cp  /root/imports/production-2026-04-24.sqlite3 $CONTAINER_ID:/rails/storage/production.sqlite3

can write premission problem with the above

668  cd imports
669  ls
670  CONTAINER_ID=$(docker ps --filter name=golfers2 --format '{{.ID}}')
671  echo $CONTAINER_ID
672  docker ps
673  CONTAINER_ID=$(docker ps --filter name=golfers2 --format '{{.ID}}')
674  echo $CONTAINER_ID
675  docker cp  /root/imports/production-2026-04-24.sqlite3 $CONTAINER_ID:/rails/storage/production.sqlite3
676  ls
