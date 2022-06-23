#Terraform


##Overview
Here are a couple projejcts using Terraform to automatically provision cloud resources. My first project was to provision a single droplet within Digital Ocean. 
Scaling up the difficulty, I decided I wanted to try to provision an entire enterprise architecture within Terraform. The first of these is a video on demand system, similar to YouTube. 
The inspiration for this architecture was a video from Cloud With Raj https://www.youtube.com/watch?v=7hZXBrI2TjY&t=458s. 
I am currently still researching some of the components of this architecture, as provisioning aws lambda functions and a content distribution have been especially difficult to provision automatically.

### To Do List for the Video Hosting Service Project
* research networking, access points for lambda and s3, lamda and dynamodb:  
  there are many different options for these (IAM, access points, step functions), and I'm not sure which is the best option yet
* learn more about HTML in order to understand the caching behavior for a CDN 

For the other project, I made a webapp architecture that autoscales accross three availability zones. 
This also has a database with a read only instance in a second availability zone for failover reliability. 
### To Do List for the Webapp Architecture Project
* research how to provision read only copies for databases, relate it back to a certain availability zone subnet
* finish writing the code, eta 6/24
