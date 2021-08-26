#Terraform Provisioning assignments:

Probelem statement: Create a terraform template for by below requirement.
- Create EKS cluster 
- RDS database 
- EFS mount by persistent volumes. 
- Use multiple nodes and load balancer.
This need to be deployed in AWS or GCP and required step by step process document.

Pre-requisites
--------------
kubectl
terraform 
wget
aws-cli

Directory structure
-------------------
eks-cluster.tf - This is the file where all EKS cluster related configurations are thier. e.g. Cluster name,version ,tags worker group configuraions, Types of instances needed to be in worker groups, we have addded two groups one of 2 with t2.small instance type and another one of t2.medium instance type.Where master is managed by EKS and worker is managed by us

kubernetes.tf -  This file contains the provider info as k8 for EKS provisioning else it will show error `kubernetes_config_map.aws_auth`..

output.tf This file is for providing outputs of the resource we have created e.g. EKS_Id, EKS_endpoint etc

security-group.tf - This file contains all the configuration for securiy groups required for worker nodes and rds which is port 22 and 3306

version.tf - This file contains the different provider versions for various usecase including s3 backend configuration.

rds.tf - This file contains all the configuration required for RDS provisioning e.g db engine, db username, password, subets etc.

efs.tf - This contains configuration related efs like efs name and key

custom-app/ - This folder contains the yaml files to deploy nginx and custom java springboot application which are exposed through loadbalencers endpoint

multiple-pods/ This folder contains all the pv, pvc and pod deployment for efs persistant volume use-case.


To starts with the stack:

Create a IAM user with proper permission and configure access keys 
Create S3 bucket to store backend with versioning enabled , proper permission enabled and mention that buckets name in version.tf

terraform init
(For the initialiation of tech stack and configure s3 backend)


terraform plan 
(To check what are the changes we are going to push in the stack)

terrafrom apply
(To apply the terraform template )


it will prompt for yes to change the configs at every teraaform command
In the result you'll get following resources:

EKS cluster Higly avilable
RDS with mysql engine
EFS 

aws eks --region us-east-2 update-kubeconfig --name test-eks-cluster
(To import cluser configs to local)
Next step is to apply yamls in the cluster .

Kubectl apply -f custom-app/
(This will deploy delpoyment file and svc objects for nginx and custom java based  and expose them through load balencers publically)



kubectl apply -f dev/
(This will deploy efs-eks-driver for mounting)

kubectl apply -f multiple-pods/specs
(This will deploy another custom app for the efs as a persistant volume use-case)

kubectl apply -f kubernetes-dashboard-admin.rbac.yaml

(To apply roles and aservice-aacount)