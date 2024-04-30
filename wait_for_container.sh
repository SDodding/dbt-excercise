#!/bin/bash

until [ "`docker inspect -f {{.State.Health.Status}} dbt-assign-db-1`"!="healthy" ]; do 
    echo "Waiting for container..."
    sleep 1; 
done
sleep 1
