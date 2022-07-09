# DevOps Projects

## Overview
 The goal of this repository is to give me the hands-on experience with popular DevOps tools, while using Git to deploy them. I've used some of these technologies to accomplish personal goals, such as deploying a web app or creating a home media server and created some projects more like what one might find in a business production environment, such as setting up a Kubernetes cluster, tech stack, or network. If it exists in the tech world, I will find a way to automate and deploy it from the comfort of my house. 

（[本説明文件有中文版本](https://github.com/Tanchwa/DevOps-Projects/blob/main/README.zh-hant.md))
 
 ## Next Up
 * ~~Write a better README~~
 * Write a better README for all projects  
 * ~~Next Git based goal: Start using test branches to test new code changes. Until now, I had been writing in VS code and testing things in my local machine before pushing them to main.~~
 * ~~Start checking out new branches~~
 * ~~Terraform project with AWS autoscaling group and load balancer~~
 * Create a new GitHub Actions workflow for the Python app, and push it to DockerHub with the tag "test"
 * Create a test environment that automatically pulls this repository (tentative for cloud-based projects, money dependent) or deploys containers automatically to a cloud based Kubernetes cluster
 New Ansible Project: Use ansible to deploy and do a mock update to an analogous business network/ production environment.
 * Design a network infrastructure for a small business
 * Learn how to use ansible to update things other than hosts, i.e., routing tables, MAC tables, split horizon and STP, firewalls, etc.
 * Write the YAML file and test it out on a virtual network
 
## Technologies used
 * Terraform  
 * Docker  
 * Kubernetes  
 * Ansible  
 * Python  
 * Linux and shell scripting

## How to use
 Because of the variation between each tool, a more detailed description of how to run each project can be found within each sub folder. However, some projects do bleed into each other and use some common files. Any time a file somewhere else is referenced, the code assumes the directory is set up as-is here.  
 For Example:  
 The Digital Ocean init file references a specific Cloud-Init file located in the same directory.  
To get the most out of this repository, clone the root directory.

## What I've learned 
 * Linux -  
   My troubleshooting and knowledge of operating systems has improved significantly. I can now explain in more detail how a machine runs and how programs/ processes interact with the physical components. This includes the boot/ init process (systemd and sysVinit), deamons, binary files, how to install programs (package managers, cURL, or compiling from source code), networking and how to edit/ troubleshoot network settings, SSH and key management, and firewall configuration. 
 * Docker -  
   Running a container in interactive mode with command `docker run CONTAINER_NAME -it /bin/bash` is a very helpful way to troubleshoot networking and file permission issues from inside a container.  
 * Ansible -  
   When I first used ansible to copy over the config files for my media server, I accidentally set the ownership to Root. Being able to use the YAML file to see where I had gone wrong and fix the issue gave me my first taste of how useful infrastructure as code is.  
 * Terraform -  
  Each resource/ module can vary on how it takes attributes. This means spelling, especially pluralization, can be inconsistent. For exaple, "cidr_blocks" can sometimes be "cidr_block" because the defined resource can only take on option. The "human readable formatting" goal is acheived, but at the cost of having to go back and change everything manually when one has hit the "change all occurrences" to fix a spelling error. 
  After completing a working demo for my first Terraform deployment, I realised I need to start looking into making modules. Keeping the entire deployment in one file is conveinient, but a bit overwhelming. I'm working on this with my Azure AKS project. 
 * Kubernetes -  
   I have already learned the basic setup of a Kubernetes cluster and many of the objects available. Each master node requires ETCD, the API server, the scheduler, and the controller manager; while each worker node requires docker, kubelet, and kube proxy, and I understand the concepts of how these work together. I have hands on experience creating ingress, secrets, config maps, services and deployments, and volumes. I have also looked at Helm charts, but haven't used or written one, yet.  
   So far, I have done all of this through the console and haven't needed to use a 3rd party API. Some important debugging tools I've learned are:  
   * `kubectl api-resources` to check which API version is used with each object
   * `kubectl exec -it DEPLOYMENT-REPLICASET-POD --/bin/bash` to run a pod interactively
   * `kubectl get` nodes, services, deployments, pods, etc.   
 I've also learned how to network between namespaces by using the DNS name NameOfComponant.Namespace.TypeOfComponant.cluster.local  
 Configuring certificates, stateful sets, and setting up a cluster from scratch are still on the road ahead.  
## Credits
 Although changes have been made to their original code to suit my needs, I couldn't have done a lot of this without the help of a couple YouTubers.  
   * DB Tech's Docker Media Server  
   https://www.youtube.com/playlist?list=PLhMI0SExGwfAdXDmYJ9jt_SxjkEfcUwEB  
   * Tech World with Nana's Kubernetes Walkthrough  
   https://www.youtube.com/watch?v=X48VuDVv0do&t=12399s  
   
 No code was used from these channels directly, but still provided invaluable information.   
  * The Digital Life  
  https://www.youtube.com/c/TheDigitalLifeTech  
  * Network Chuck  
  https://www.youtube.com/c/NetworkChuck  
  * Tutorial Linux  
  https://www.youtube.com/c/tutoriaLinux  
