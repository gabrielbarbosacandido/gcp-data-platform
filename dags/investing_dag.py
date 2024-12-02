from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator

from include import utils, constants as ct


with DAG(
    dag_id="monthly_extraction_financial_data",
    default_args={
        "owner": "suzano",
        "start_date": datetime(1991, 2, 1),
    },
    schedule_interval="@daily",
    description="This DAG extracts financial data from the Investing.com website using the `investpy` library",
    catchup=True
) as dag:
    chinese_caixin_services_index_table_to_gcs = PythonOperator(
        task_id="extract_chinese_caixin_services_index",
        python_callable=utils.economic_calendar,
        op_kwargs={
            "time_zone": "GMT",
            "time_filter": "time_remaining",
            "countries": ["china"],
            "importances": ["medium"],
            "categories": ["Economic Activity"],
            "from_date": "{{ macros.ds_format(prev_ds, '%Y-%m-%d', '%d/%m/%Y') }}",
            "to_date":"{{ macros.ds_format(ds, '%Y-%m-%d', '%d/%m/%Y') }}"
        }
    )

    bloomberg_commodity_index_table_to_gcs = PythonOperator(
        task_id="extract_bloomberg_commodity_index",
        python_callable=utils.get_index_historical_data,
        op_kwargs={
            "index": "Bloomberg Commodity",
            "country": "world",
            "from_date": "{{ macros.ds_format(prev_ds, '%Y-%m-%d', '%d/%m/%Y') }}",
            "to_date": "{{ macros.ds_format(ds, '%Y-%m-%d', '%d/%m/%Y') }}"
        },
    )

    usd_to_cny_table_to_gcs = PythonOperator(
        task_id="extract_usd_to_cny",
        python_callable=utils.get_currency_cross_historical_data,
        op_kwargs={
            "currency_cross": "USD/CNY",
            "from_date": "{{ macros.ds_format(prev_ds, '%Y-%m-%d', '%d/%m/%Y') }}",
            "to_date":"{{ macros.ds_format(ds, '%Y-%m-%d', '%d/%m/%Y') }}"
        },
    )

    for table in ct.TABLES:
        refresh_trino_with_gcs_data_task = PythonOperator(
            task_id=f"refresh_trino_with_gcs_data_{table}",
            python_callable=utils.refresh_trino_with_gcs_data,
            op_kwargs={
                "table": table
            },
        )
        ct.refresh_trino_tasks.append(refresh_trino_with_gcs_data_task)

    quality_test_in_raw_tables = KubernetesPodOperator(
        namespace="airflow-prd",
        image="gcr.io/suzano-challenge/airflow:latest",
        cmds=['/bin/bash', '-c', 'dbt run && dbt test'],
        task_id="quality_test_in_raw_tables",
        get_logs=True,
        is_delete_operator_pod=True,
        in_cluster=True
    )

    chinese_caixin_services_index_table_to_gcs >> ct.refresh_trino_tasks
    bloomberg_commodity_index_table_to_gcs >> ct.refresh_trino_tasks
    usd_to_cny_table_to_gcs >> ct.refresh_trino_tasks

    for task in ct.refresh_trino_tasks:
        task >> quality_test_in_raw_tables
