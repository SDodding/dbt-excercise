db_up:
	docker compose -f ./docker-compose.yml up -d
	./wait_for_container.sh

run_migrations: db_up
	# alembic upgrade head

run: run_migrations
	# DBT seed is silly way to load a ~70 meg CSV under normal circumstances, even if it's static data
	# Ideally this would be batch inserted, but for speed i'll just take advantage of this for the excercise
	cd transform && \
	dbt deps && \
	dbt seed  && \
	dbt run
