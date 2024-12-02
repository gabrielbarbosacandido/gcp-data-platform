WITH commodity_data AS (
    SELECT
        date,
        close,
        open,
        high,
        low,
        volume
    FROM raw_data.bloomberg_commodity_index
)
SELECT * FROM commodity_data;
