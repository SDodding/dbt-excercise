from pyspark.sql import SparkSession
import pyspark.sql.functions as fn

# Presented as a single script rather than composed into package/modules and functions
# We'll do this directly in spark and avoid using hive tables and lots of sparksql for the example
spark = SparkSession.builder.master("local[1]").getOrCreate()

report_raw = spark.read.options(header=True).csv(
    "../transform/data/Amazon Sale Report.csv",
)

report_cleaned = report_raw.drop("index", "Unnamed: 22").drop_duplicates()

# I'd be tempted to do some schema enforcement here
fct_amazon_sales = (
    report_cleaned.select(
        fn.col("Order ID").alias("order_id"),
        fn.col("Qty").cast("int").alias("qty"),
        fn.col("Amount").cast("double").alias("amount"),
        fn.col("currency").alias("currency"),
        fn.col("ship-postal-code").alias("ship_postal_code"),
        fn.col("ship-country").alias("ship_country"),
    )
    .withColumn(
        "location_id",
        fn.sha1(fn.concat("ship_country", "ship_postal_code")),
    )
    .drop(
        "ship_postal_code",
        "ship_country",
    )
)

dim_locations = (
    report_cleaned.select(
        fn.col("ship-city").alias("ship_city"),
        fn.col("ship-state").alias("ship_state"),
        fn.col("ship-postal-code").alias("ship_postal_code"),
        fn.col("ship-country").alias("ship_country"),
    )
    .withColumn(
        "location_id",
        fn.sha1(fn.concat("ship_country", "ship_postal_code")),
    )
    .distinct()
)

fct_amazon_sales.write.mode("overwrite").parquet("fct_amazon_sales.parquet")
dim_locations.write.mode("overwrite").parquet("dim_locations.parquet")

sales_by_state_df = (
    dim_locations.join(fct_amazon_sales, "location_id", "left")
    .groupBy("ship_state")
    .sum("amount")
    .withColumnRenamed("sum(amount)", "total_sales")
    .orderBy("total_sales", ascending=False)
)

sales_by_state_df.write.mode("overwrite").parquet("sales_by_state.parquet")
sales_by_state_df.show()
