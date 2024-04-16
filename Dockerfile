FROM python:3.7-slim

WORKDIR /app

# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install mlflow boto3 awscli setuptools

# COPY . .

# CMD ["mlflow", "server", "--host", "0.0.0.0", "--port", "5000"]
