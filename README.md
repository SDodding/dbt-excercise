## Setup

To run this requires a python virtual environment (Targeting >3.8, I like to use pyenv to manage these), Java (for Pyspark), Docker (DB/Grafana) and the ability to execute Makefiles in a terminal.

The project was generated to run using Windows Subsystem for Linux with an Ubuntu image.

From within your chosen python env:

```
pip install -r requirements.txt
```

Ensure an appropriate java version is installed

```
sudo apt install default-jdk
```

Ensure [docker](https://docs.docker.com/engine/install/ubuntu/) is installed

## Running the DBT project

The Makefile scripts the setup process and dependencies.

It can be run end to end using:

```
make dbt_all
```

The postgres instance we're using for DBT is running on localhost:5488 and grafana can be found at http://localhost:3111

If you wish to serve the dbt docs you can run

```
make dbt_serve_docs
```

At which point you can access them at http://localhost:8001

## Running the pyspark script

This can be found in the pyspark directory from root and is a simple script. It can be executed with:

```
cd pyspark
python report_to_model.py 
```

The directory change is important as the csv path is hardcoded as a relative one in the script.

## Grafana

Unfortunately there wasn't time to save and pre-populate a dashboard in Grafana. I'm happy to demonstrate this.

## Commentary

Initially bootstrapped with (cookiecutter-dbt)[https://github.com/datacoves/cookiecutter-dbt]

I was tempted to do the majority of this work in a jupyter notebook or equivalent, however I'm used to spinning up local platforms like this - so docker seemed like a nice way to go. Retrospectively that might have allowed me to add a satisfying narrative.

I unfortunatley ran out of time I had available to spend on this, so aspects are less tidy than I'd like. I'm happy to talk through all the missing parts and intentions, some notes off the top of my head here:

On DBT:

- DBT seed is upsettingly slow (and unsuitable) for large fixtures, so a short python script ingests the CSV into the database initially. It uses PySpark and the JDBC driver as that seemed relevant to this excercise, but I'd otherwise just use psycopg2 and the postgres COPY command to ingest it directly to the DB.
- DBT added snapshots since the last time I built a DWH with it - I'd be interested to explore that
- UML/ERD Diagrams are always handy, It'd be interesting to explore auto generating these from DBT with something like (DBTerd)[https://github.com/datnguye/dbterd]

On the models in this project:

- I might spend more time considering exactly how I'd lay out the Medallion style architecture and naming of the data layers. If an existing convention was there I'd consider adopting that.
- Models at DWH and above generally should be explicit about types and names on all columns. Only a few relevant models have this currently due to time. At scale I'd script the majority of this.
- I'd usually include YAML files for all models with typing and tests - again I'd likely script the generation of a lot of that
- Indexes are currently missing in the models. Not needed at this scale, but I'd prefer they at least existed on all fks
- These models are currently all simple table materialisations, and fully refresh each time - depending on the update frequency and scale some type 2 tables and incremental loads would make sense. Some DM tables could also happily be views.
- Custom tests/macros - I'd have preferred to add a few of these as examples. As it is only some default tests in the yaml files associated with the models are included - lacking singular/generic test files

On the python:

- I wouldn't write a deployed transformation as a simple script. I'd prefer properly composed packages - ideally with some level of testing with pytest
- I'd prefer to set up things like pre-commit to help enforce some code standards, formatting and linting on commit to save time and improve consistency.
- Uses pyspark in local mode since there's no cluster to provide a session or set up proper hive tables and so on

On Grafana:

- Initially I selected Superset, however it was too heavy in the build process and spun up too many containers. Grafana is much lighter for a local use-case.
- Postgres needs some grant fiddling to get Grafana to auto detect the non default schemas properly in explore
- Persistent dashboards for the Grafana docker image would require a little bit of extra scripting
