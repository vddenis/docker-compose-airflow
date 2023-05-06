from libs import *

from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator

# Following are defaults which can be overridden later on
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1, tzinfo=local_tz),
    # 'email': [var_email_list],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=1), 
    'wait_for_downstream': False
}

dag = DAG('Hello_DAG',
            catchup=False,
            max_active_runs=1,
            default_args=default_args, 
            schedule_interval='0 12 * * *')


def hello():
    print('hello! dag works!')

start_task = DummyOperator(task_id='start_task', dag=dag)
hello_task = PythonOperator(task_id='hello_task', python_callable=hello, dag=dag)
end_task = DummyOperator(task_id='end_task', dag=dag)

start_task >> hello_task >> end_task