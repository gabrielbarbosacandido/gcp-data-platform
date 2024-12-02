WITH usd_cny_data AS (
    SELECT
        date,
        close,
        open,
        high,
        low,
        volume
    FROM raw_data.usd_to_cny
)
SELECT * FROM usd_cny_data;
