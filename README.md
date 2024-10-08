# Terraform GKE Mini Cluster
This project provides a minimal setup for spinning up a small Google Kubernetes Engine (GKE) cluster using Terraform for a sample of Go and the GIN web framework, specifically tailored for development purposes.

## Purpose
The primary goal of this project is to create a lightweight GKE cluster that developers can use to quickly deploy and test a Go application in a Kubernetes environment. This setup is intended only for development and testing purposes and not for production use. In this setup, it utilized Preemptible VMs, which is a low cost solution and comes with trade-off, it only last up to 24 hours after creation.


## Important Considerations for Production

Please change the following settings on gke-cluster/main.tf
```bash
delete_protection = true

# Under node_config
preemptible = false
# Optionally you can set spot = true
spot = true
```
For production environments, additional configurations and security measures are required to ensure robustness and safety, including but not limited to:

**Namespace Management**: Proper use of Kubernetes namespaces to isolate and manage resources effectively.

**Network Policies**: Implement network policies to control traffic flow between pods and minimize the attack surface.

**Calico or Cilium**: Consider using Calico or Cilium for advanced networking and network policy enforcement.

**Google Cloud Armor (WAF)**: Set up Google Cloud Armor for Web Application Firewall (WAF) capabilities to protect against external threats targeting your Ingress.

**Ingress and Egress Controls**: Use Cloud NAT or other mechanisms to manage outbound traffic securely.

**Monitoring and Logging**: Implement comprehensive monitoring (e.g., Stackdriver, Prometheus) and logging (e.g., ELK stack, Google Cloud Logging) to observe the cluster's health and detect anomalies.

## Install Gcloud CLI

```bash
sudo apt-get install apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install google-cloud-cli
```


## Directory Structure
```bash
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars # Create this file
├── provider.tf
├── /modules
│   ├── gke-cluster
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   └── vpc
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── service_account.json # Generated using Gcloud command
```
 

## Quick start guide


### Generate Service account for your project
```bash
gcloud iam service-accounts create gke-service-account --display-name "GKE Service Account"

## Terminal Output
Created service account [gke-service-account].
```


### Adding policy to the service account
Please replace `PROJECT_ID` with your actual project ID and `SERVICE_ACCOUNT_EMAIL` with the email of the service account created.

```bash

## Binding policy
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="${SERVICE_ACCOUNT_EMAIL}" --role="roles/container.admin"

# Kubernetes Engine Cluster Viewer role
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="${SERVICE_ACCOUNT_EMAIL}" --role="roles/container.clusterViewer"

# IAM Service Account User role
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="${SERVICE_ACCOUNT_EMAIL}" --role="roles/iam.serviceAccountUser"

# Storage admin role
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="${SERVICE_ACCOUNT_EMAIL}" --role="roles/storage.admin"

# Storage object admin role
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="${SERVICE_ACCOUNT_EMAIL}" --role="roles/storage.objectAdmin"

# Create a service account key, in this example we will use service-account.json, remmeber to add this to your terraform.tfvars
gcloud iam service-accounts keys create service-account.json --iam-account="gke-service-account@${PROJECT_ID}.iam.gserviceaccount.com"

# Check if it's created properly
gcloud iam service-accounts keys list --iam-account="${SERVICE_ACCOUNT_EMAIL}"
```

### Configure your docker setting
Update your local Docker configuration to use the gcloud command-line tool for authentication. 

```bash
gcloud auth configure-docker
```


### Prepare your Go application
```bash
cd app
go mod init go-gin-app
go mod tidy
```


## Run Terraform command
```bash
terraform init

# Double check your configuration and change as necessary
terraform plan

# Finally let's build the cluster
terraform apply
```

## Attach credentials to the kubectl 
```bash
gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${REGION} --project ${PROJECT_ID}
```


### Build and push your docker image into GCR (GCloud Container Registry)
```bash
# Please change your app name and the version tag accordingly.
docker build -t gcr.io/${PROJECT_ID}/go-gin-app:v1 .
docker push gcr.io/${PROJECT_ID}/go-gin-app:v1
```

### Let's work on the Go app deployment
```bash
cd kubernetes
kubectl apply -f deployment.yaml
# Output deployment.apps/go-gin-app created

kubectl apply -f service.yaml
# Output service/go-gin-app created

# Run kubectl get services to verify; it might take a while for the External-IP to appear.
kubectl get svc

# Output
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
go-gin-app   LoadBalancer   xx.xx.xx.xx      xx.xx.xx.xx   80:31442/TCP   30s
kubernetes   ClusterIP      xx.xx.xx.xx      <none>          443/TCP       11m
```

### Open your browser and key in the External IP from the Go app service.
http://{PUBLIC_IP}/health-check

<p>And don't forget to issue terraform destory if your cluster is temporary.</p>

```
# Since delete_protection is set to false, you can issue this command
terraform destroy
```

<p>Feel free to customize the content further based on your specific project needs or add more details as necessary.
Happy Sailing!
</p>