import psycopg2
from pyspark.sql import SparkSession

# Ensure the schema is created
# In a bigger example this should either be managed by DBT or a migration tool like alembic
with psycopg2.connect(
    host="localhost",
    port="5488",
    database="postgres",
    user="postgres",
    password="postgres",
) as conn:
    with conn.cursor() as cursor:
        create_schema_sql = f"CREATE SCHEMA IF NOT EXISTS analytics_raw;"
        cursor.execute(create_schema_sql)

# Populate the seed table using pyspark
spark = (
    SparkSession.builder.master("local[1]")
    .config("spark.jars.packages", "org.postgresql:postgresql:42.7.3")
    .getOrCreate()
)
df = spark.read.options(header=True).csv(
    "../transform/data/Amazon Sale Report.csv",
)

df.write.format("jdbc").options(
    url="jdbc:postgresql://localhost:5488/postgres",
    driver="org.postgresql.Driver",
    dbtable='analytics_raw."amazon_sale_report"',
    user="postgres",
    password="postgres",
).mode("overwrite").save()
