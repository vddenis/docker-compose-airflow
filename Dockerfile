#наследуемся от образа airflow, здесь можно подменять версию
FROM apache/airflow:2.6.0
#главным каталогом airflow в самих контейнерах будет папка opt
ENV AIRFLOW_HOME=/opt/airflow
#устанавливаем рабочую директорию
WORKDIR ${AIRFLOW_HOME}
#меняемся на рута, устанавливаем все обновления
USER root
RUN apt-get update
#меняемся обратно на airflow, устанавливаем python-зависимости (из файла requirements.txt)
USER airflow
COPY requirements.txt /
RUN pip install --upgrade pip 
RUN pip install --no-cache-dir -r /requirements.txt
#снова меняемся на рута и аттачим директорию дагов в образ (зачем и нужен кастомный образ)
USER root
ADD --chown=airflow:root /dags /opt/airflow/dags
#аттачим email-темплейт, если используем email-нотификацию
ADD --chown=airflow:root /email-template /opt/airflow/email-template