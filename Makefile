db_up:
	docker compose -f ./docker/postgres-docker-compose.yml up -d
	./wait_for_container.sh

superset_up:
	cd visualisation && \
	git clone https://github.com/apache/superset.git git_tmp && \
	mv git_tmp/.git superset/.git && \
	rm -rf git_tmp && \
	cd superset && \
	git checkout 3.0.0 && \
	TAG=3.1.1 docker compose -f docker-compose-non-dev.yml up -d

all_up: db_up superset_up

dbt_all: db_up
	# DBT seed is a poor way to load a ~70 meg CSV under normal circumstances, even if it's static data
	# Ideally this would be batch inserted using psycopg2, but for speed i'll just take advantage of this for the excercise
	cd transform && \
	dbt deps && \
	dbt seed  && \
	dbt run && \
	dbt test
	# We could also have just used 'dbt build', but in this makefile I'd like each step explicit

dbt_serve_docs: db_up
	# This may throw a gio error with some versions of python in WSL. It will eventually serve regardless however.
	cd transform && \
	dbt docs generate && \
	dbt docs serve --port 8001
