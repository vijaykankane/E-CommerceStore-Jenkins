Steps to execute 

1. created the dockerfile for all 5 MS and build and push the same to dockerhub

![alt text](image/dockerCart.png) 

![alt text](image/dockerFrontend.png) 

![alt text](image/dockerOrder.png) 

![alt text](image/dockerProduct.png) 

![alt text](image/dockerUser.png)

All images are in teh dockerhub now.

now provisioning the infra by terraform and deploy the docker images through terraaform .
1. create main.tf with VPC creation , EC2 ,Security group creation with the 80, 3000 ports in ingress and rest 3001-3004 to internal
2. create variable.tf for the input for the keyname/region/instancetype/dockername
3. running terraform init 
![alt text](image/terraform.init.png)

teeraform plan 

![alt text](image/terrafromPlan.png)

terraform apply and output of the EC2 provistioned

![alt text](image/output.png)

VPC creation with public subnet
![alt text](image/Vpc-publicsubnet.png)

![alt text](image/vpc-awsconsole.png)

SG are created with the 3000 open for the frontend.
![alt text](image/securiytGpurp.png)


Docker installed on the machine and images are pulled automatically
![alt text](image/dockerinstalled.png)

all images automatically pulled and running 
![alt text](image/imageRunning.png)

terraform destroy post testing the same

![alt text](image/terraformDestrtory.png)







