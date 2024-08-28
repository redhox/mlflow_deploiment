FROM python:3.10

WORKDIR /app

# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install mlflow boto3 awscli setuptools mysqlclient psycopg2 gunicorn

# pymysql

# CMD ["mlflow", "server", "--host", "0.0.0.0", "--port", "5000"]
