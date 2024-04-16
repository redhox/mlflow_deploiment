<img src="https://github.com/redhox/labeling_mlflow/blob/main/Capture%20d%E2%80%99%C3%A9cran%20du%202024-04-15%2016-51-53.png?raw=true"></img><br>
local python/serveur-mlflow/bucket-s3
<h1>mlflow en server distant</h1>
local python/serveur-mlflow/bucket-s3
<h2>serveur-mlflow</h2>

        python -m venv .venv
        source .venv/bin/activate
        pip install mlflow
        pip install boto3
        pip install awscli
        export MLFLOW_S3_ENDPOINT_URL=http://1.2.3.4:9000/
        export AWS_ACCESS_KEY_ID=
        export AWS_SECRET_ACCESS_KEY=
        mlflow server -h 0.0.0.0 --default-artifact-root s3://artifacts --backend-store-uri sqlite:///mlflow.db --app-name basic-auth

<h2>conexion et train</h2>
.env

    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    MLFLOW_S3_ENDPOINT_URL=http://1.2.3.4:9000/
    MLFLOW_TRACKING_URI=http://1.2.3.4:5000/
    MLFLOW_TRACKING_USERNAME=admin
    MLFLOW_TRACKING_PASSWORD=password
    

app.py
pip install mlflow ultralytics boto3 awscli setuptools python-dotenv
    
    import os
    from dotenv import dotenv_values
    import mlflow
    from ultralytics import YOLO
    
variable

    project_name= "" #experiment
    run_name=""
    model_size="yolov8s.pt" #yolov8n.pt/yolov8s.pt/yolov8m.pt
    data_yaml_path=""
    epochs=
    image_sise=
    patience=
start mlflow experimante

    mlflow.set_tracking_uri(temp["MLFLOW_TRACKING_URI"])
    mlflow.set_experiment(project_name)
    with mlflow.start_run(run_name=run_name):
        model = YOLO(model_size)
        results  = model.train(project=project_name,name=run_name,data=data_yaml_path, epochs=epochs,imgsz=image_sise)
    




    
<h2>generé par IA pour un possible deploiment</h2>


Configuration des Secrets GitHub

Tout d'abord, vous devez stocker vos identifiants AWS et toute autre information sensible dans les secrets de votre dépôt GitHub. Cela inclut :
```bash
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    AWS_REGION (si nécessaire)
```
Ces secrets seront utilisés dans votre workflow GitHub Actions pour configurer l'environnement AWS.


2. Création du Workflow GitHub Actions

Créez un fichier de workflow dans le répertoire .github/workflows de votre dépôt. Par exemple, deploy.yml. Voici un exemple de workflow qui construit une image Docker, la pousse vers Amazon ECR, et déploie un service sur Amazon ECS :

name: Deploy to AWS
```bash
on:
 push:
    branches:
      - main

env:
 AWS_REGION: us-east-1
 ECR_REPOSITORY: your-ecr-repository-name
 ECS_SERVICE: your-ecs-service-name
 ECS_CLUSTER: your-ecs-cluster-name

jobs:
 deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}

    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1

    - name: Build, tag, and push image to Amazon ECR
      id: build-image
      env:
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
        ECR_REPOSITORY: ${{ env.ECR_REPOSITORY }}
        IMAGE_TAG: ${{ github.sha }}
      run: |
        docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
        docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
        echo "::set-output name=image::$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"

    - name: Fill in the new image ID in the Amazon ECS task definition
      id: task-def
      uses: aws-actions/amazon-ecs-render-task-definition@v1
      with:
        task-definition: task-definition.json
        container-name: your-container-name
        image: ${{ steps.build-image.outputs.image }}

    - name: Deploy Amazon ECS task definition
      uses: aws-actions/amazon-ecs-deploy-task-definition@v1
      with:
        task-definition: ${{ steps.task-def.outputs.task-definition }}
        service: ${{ env.ECS_SERVICE }}
        cluster: ${{ env.ECS_CLUSTER }}
        wait-for-service-stability: true
```
3. Configuration du fichier docker-compose.yml

Assurez-vous que votre fichier docker-compose.yml est correctement configuré pour votre application. Vous n'avez pas besoin de spécifier les identifiants AWS dans ce fichier, car ils seront gérés par le workflow GitHub Actions.


4. Déploiement

Une fois que vous avez configuré votre workflow GitHub Actions et votre fichier docker-compose.yml, chaque fois que vous poussez des modifications sur la branche main, GitHub Actions construira votre image Docker, la poussera vers Amazon ECR, et déploiera votre service sur Amazon ECS.

Cette approche vous permet de déployer votre application de manière automatisée et sécurisée, en utilisant les meilleures pratiques de sécurité pour gérer les identifiants AWS.
