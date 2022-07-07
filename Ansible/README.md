# Ansible

## Overview 
I used ansible to work on two projects. In the first one, the home_inventory and playbook-setup were used to test the waters of what ansible could do. The second was a bit more ambitious, trying to use ansible on a two-branch mid to large size business with a two-tier cisco architecture. 

*This is a work in progress.

## The home lab
I ansible to set up my single lab server. One could argue that this is a bit overkill, as I could have just used SSH, FTP, or VS code remote to set it up, but this was more of just a proof of concept for myself. I also ran two virtual machines on my laptop, mirroring the home server, to make sure I could copy all the files and configurations across multiple machines. 
One thing to note, I now know about other modules that are more effecient than the ones used in the first project. The "template" module can be used for config files, and is significantly quicker than the copy module. 

## Ansible at scale 
I had three goals for the second project.  
    1. Show I have enough networking knowledge for the normal requirements of a DevOps engineer.  
    2. Use ansible to create a baseline for all of this, and  
    3. Push out a change to the infrastructure using Ansible

## Methodology for Project 2
I used my knowledge from the CompTIA Network+ certification to put in what I think would make an effective network. When designing this network, the picture I had in my head for this business is a business analytics company with a few different teams, one large office in Chicago, and a smaller remote office in St. Louis. The company would have a large database on site, a webserver with two hosts and a reverse proxy for their web page but no client facing web app, several hosts managed with LDAP, and a certificating Kerberos server for PowerBI, Microsoft Office, and Adobe Licenses. I also included a Next Gen Firewall, used HSRP on the distribution layer routers, and manually configured the routing tables. 
The change: the company is expanding its IT department handling the webserver. There are now going to be a few individual nodes in St. Louis that need access to the DMZ. 

Update 7/7/22: Unfortunately, cisco router images are not free, and ansible doens't have great support for a lot of open source virtual routers. I'm putting a pin in this project and moving on to something a little more on the node provisioning side of things. 


## Requirements
clone the Tanchwa/DevOps-Projects repository
ansible installed on the machine you're working from
have the ansible galaxy cisco modules installed from ansible


## To do 
  * ~~Rough outline of logical topology~~
  * Finish the inventory outline with LDAP support  
  * Finish baseline playbook  
  * ~~Come up with an idea for the change to the infrastructure~~
  * Set up a virtual network and test out the baseline  
  * Run a change playbook  

## Things I'm steering clear of for the moment
VoIP phones, a mail server

## Credits
Some cool people have already made LDAP plugins for ansible. Check out the repository [here](https://github.com/joshinryz/ansible_ldap_inventory).


## Methodology for Project 2.1
Privision a LAMP stack with Ansible. This way, I will still be able to deal with a large and varied list of nodes that can be separated into mutiple parent and child directories within the inventory file. 
