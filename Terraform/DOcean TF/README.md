# Terraform 
## Overview
Here is a simple Terraform script to reate a single Digital Ocean droplet. I've also included a Cloud-Init file to automatically set up the cloud instance with an installation of Docker, and to pull my Python application image.
This also pulls any new versions of the image with an app called "Watchtower." This is also set up automatically on the cloud image with Cloud-Init. 

# Requirements
Install Terraform on your workstation, clone this repository.

## How To Use
From the DOcean TF directory, run `teraform init` to initialize the directory. This will install the necessary files needed for your specified provider.
Next run `terraform apply`. This will run a "diff" against your existing infrustructure and calculate what changes will made to any existing infrustructure based on the config files. 
At this point, terraform should ask you to input any variables specified in the "variables.tf" folder. Enter in your public SSH key, private SSH key, and Digital Ocean token.
Terraform will ask you if you want to perform these actions. Type "yes" to confirm. 
If you want to check what terraform will do before executing a change, run `terraform plan`
