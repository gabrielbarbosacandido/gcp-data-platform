# suzano-challenge

This challenge involves building a data pipeline to extract financial data from the **investing.com** website. The challenge requires the use of cloud resources, and the data platform stack consists of the following tools:

- **Provider**: GCP (Google Cloud Platform)
- **Storage**: GCS (Google Cloud Storage) and OpenSearch
- **Lakehouse**: Trino
- **Orchestrator**: Airflow
- **Ingestion**: Python
- **Data Quality**: DBT
- **Catalog**: DBT
- **Infrastructure**: Docker, Kubernetes, and Terraform (IAC)
- **Data Security and Monitoring**: Apache Ranger
- **Observability**: Grafana and Prometheus

## Repository Structure

The repository is structured as follows:

- **dags/**: Contains the logic for the data pipeline, including the Airflow DAGs.
- **dags/dbt/**: Contains the scripts for Data Quality and the data catalog, utilizing DBT.
- **infra/**: Contains the provisioning for all infrastructure, including Terraform and Kubernetes.
- **tests/**: Contains validation tests for the Airflow DAGs.
- **pyproject.toml**: The project dependency manager, listing the required Python libraries.
- **Dockerfile**: The image used in the Helm Chart for Airflow, which was deployed on Kubernetes.
- **.github/workflows/ci.yaml**: The CI pipeline ensuring that the DAGs will be executed. This file also includes URLs for the Helm Charts of Trino and Airflow, as well as the Elastic Search URLs for the modules used.

## References
- **Investpy Documentation**: [https://pypi.org/project/investpy/](https://pypi.org/project/investpy/)
- **Terraform VPC Module**: [https://registry.terraform.io/modules/terraform-google-modules/network/google/latest](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest)
- **Terraform DNS Module**: [https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest)
- **Terraform VPN Module**: [https://registry.terraform.io/modules/terraform-google-modules/vpn/google/latest](https://registry.terraform.io/modules/terraform-google-modules/vpn/google/latest)
- **Terraform GKE Module**: [https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)
- **Trino Helm Chart**: [https://github.com/trinodb/charts/blob/main/charts/trino/values.yaml](https://github.com/trinodb/charts/blob/main/charts/trino/values.yaml)
- **Airflow Helm Chart**: [https://github.com/apache/airflow/blob/main/chart/values.yaml](https://github.com/apache/airflow/blob/main/chart/values.yaml)
- **OpenSearch Helm Chart**: [https://github.com/opensearch-project/helm-charts/blob/main/charts/opensearch/values.yaml](https://github.com/opensearch-project/helm-charts/blob/main/charts/opensearch/values.yaml)
- **Grafana Helm Chart**: [https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml](https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml)
- **Prometheus Helm Chart**: [https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml)
- **Apache Ranger Documentation**: [https://ranger.apache.org/](https://ranger.apache.org/)
- **Istio Load Balancer**: [https://istio.io/](https://istio.io/)
