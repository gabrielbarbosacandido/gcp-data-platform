from typing import List

import logging

from investpy import news, indices, currency_crosses
from airflow.providers.google.cloud.hooks.gcs import GCSHook
from trino.dbapi import connect

import pandas as pd
import trino


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def save_to_gcs_parquet(bucket_name: str, object_name: str, df: pd.DataFrame) -> None:
    """
    Saves a DataFrame as a Parquet file and uploads it to a specified GCS bucket.
    
    Args:
        bucket_name (str): The name of the GCS bucket.
        object_name (str): The object name in GCS (including the partition prefix).
        df (pd.DataFrame): The DataFrame containing the data to be saved.
        
    Returns:
        None
    """
    try:
        gcs_hook = GCSHook(gcp_conn_id="google_cloud_default")

        partitioned_path = f"{object_name}/partition={df['date'].dt.strftime('%Y%m')}/"
        file_path = f"{partitioned_path}{df['date'].dt.strftime('%Y%m')}.parquet"

        gcs_hook.upload(bucket_name=bucket_name, object_name=file_path, data=df.to_parquet())
        logger.info(f"Successfully uploaded {file_path} to GCS bucket {bucket_name}")
    
    except Exception as e:
        logger.error(f"Failed to upload DataFrame to GCS: {e}")
        raise


def economic_calendar(
    time_zone: str,
    time_filter: str,
    countries: List[str],
    importances: List[str],
    categories: List[str],
    from_date: str,
    to_date: str
) -> None:
    """
    Extracts economic calendar data using the `investpy` library and saves it to GCS as Parquet.
    
    Args:
        time_zone (str): Time zone for the economic data (e.g., "GMT").
        time_filter (str): Filter for the time range (e.g., "time_remaining").
        countries (List[str]): List of countries for which the data is extracted.
        importances (List[str]): List of importance levels for the events.
        categories (List[str]): List of event categories.
        from_date (str): The start date for the data extraction (format: "DD/MM/YYYY").
        to_date (str): The end date for the data extraction (format: "DD/MM/YYYY").
        
    Returns:
        None
    """
    try:
        df = news.economic_calendar(
            time_zone=time_zone,
            time_filter=time_filter,
            countries=countries,
            importances=importances,
            categories=categories,
            from_date=from_date,
            to_date=to_date
        )

        save_to_gcs_parquet(
            bucket_name="raw",
            object_name="extract_chinese_caixin_services_index",
            df=df
        )
    except Exception as e:
        logger.error(f"Error extracting economic calendar data: {e}")
        raise


def get_index_historical_data(
    index: str,
    country: str,
    from_date: str,
    to_date: str
) -> None:
    """
    Retrieves historical data for a specified index using `investpy` and saves it as Parquet to GCS.
    
    Args:
        index (str): The index for which historical data is required (e.g., "Bloomberg Commodity").
        country (str): The country to retrieve the index data for (e.g., "world").
        from_date (str): The start date of the historical data range (format: "DD/MM/YYYY").
        to_date (str): The end date of the historical data range (format: "DD/MM/YYYY").
        
    Returns:
        None
    """
    try:
        df = indices.get_index_historical_data(
            index=index,
            country=country,
            from_date=from_date,
            to_date=to_date
        )

        save_to_gcs_parquet(
            bucket_name="raw",
            object_name="Bloomberg Commodity",
            df=df
        )
    except Exception as e:
        logger.error(f"Error retrieving index historical data: {e}")
        raise


def get_currency_cross_historical_data(
    currency_cross: str,
    from_date: str,
    to_date: str
) -> None:
    """
    Retrieves historical data for a specified currency cross (e.g., "USD/CNY") using `investpy`.

    Args:
        currency_cross (str): The currency pair (e.g., "USD/CNY").
        from_date (str): The start date for the historical data range (format: "DD/MM/YYYY").
        to_date (str): The end date for the historical data range (format: "DD/MM/YYYY").

    Returns:
        None
    """
    try:
        df = currency_crosses.get_currency_cross_historical_data(
            currency_cross=currency_cross,
            from_date=from_date,
            to_date=to_date
        )

        save_to_gcs_parquet(
            bucket_name="raw",
            object_name="USD_CNY_Historical_Data",
            df=df
        )
    except Exception as e:
        logger.error(f"Error retrieving currency cross historical data: {e}")
        raise


def refresh_trino_with_gcs_data(table: str) -> None:
    """
    Refreshes a table in Trino to ensure that it reflects the latest data from GCS.

    Args:
        table (str): The name of the table to refresh in Trino (e.g., "investing.table_name").
        
    Returns:
        None
    """
    try:
        conn = connect(
            host="trino_host",
            port=8081,
            user="trino",
            catalog="raw",
            schema="investing"
        )
        cursor = conn.cursor()

        query = f"REFRESH TABLE {table};"
        cursor.execute(query)
        conn.close()

        logger.info(f"Successfully refreshed the table: {table}")
    except Exception as e:
        logger.error(f"Failed to refresh Trino table {table}: {e}")
        raise
