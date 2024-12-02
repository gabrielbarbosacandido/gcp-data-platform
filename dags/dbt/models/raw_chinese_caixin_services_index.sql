\WITH caixin_data AS (
    SELECT
        date,
        actual_state,
        close,
        forecast
    FROM raw_data.chinese_caixin_services_index
)
SELECT * FROM caixin_data;
