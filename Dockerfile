FROM apache/airflow:2.7.2

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        vim \
        nano \
 && apt-get autoremove -yqq --purge \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


RUN sudo pip install --no-cache-dir --upgrade pip 

RUN curl -sSL https://install.python-poetry.org | python3 -

COPY pyproject.toml .

RUN poetry install

RUN poetry export -f requirements.txt --without-hashes > /opt/airflow/requirements.txt\

RUN sudo -u airflow pip install --no-cache-dir -r requirements.txt

USER airflow
