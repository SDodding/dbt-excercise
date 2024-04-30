#!/bin/bash

until [ "`docker inspect -f {{.State.Health.Status}} pg_db_data`"!="healthy" ]; do 
    echo "Waiting for container..."
    sleep 1; 
done
sleep 1
