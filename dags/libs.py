
import pendulum
local_tz = pendulum.timezone("Europe/Moscow")
from airflow.models import Variable
# var_email_list = Variable.get("email_list") #раскомментировать и установить в веб-админке имэйлы, на которые хотим пускать нотификацию
import pandas as pd
import numpy as np
from airflow.exceptions import AirflowException
from airflow.hooks.postgres_hook import PostgresHook
from airflow.hooks.base_hook import BaseHook
from airflow import DAG
from airflow.utils import timezone
from datetime import datetime, timedelta
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.python import BranchPythonOperator