FROM python:3.12

WORKDIR /app

# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install mlflow boto3 awscli setuptools pymysql

# COPY . .

# CMD ["mlflow", "server", "--host", "0.0.0.0", "--port", "5000"]
