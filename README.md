# provision_carthage
Provisioning using Vagrant and chef-solo

### Environment requirement setup:
1. [Oracle VirtualBox](https://www.virtualbox.org/) version ^5.1 
2. [Vagrant](https://www.vagrantup.com/downloads.html) version ^1.9.7
3. [Berks comes along with Chef Development Kit Version](https://downloads.chef.io/chefdk/stable/1.5.0) version 1.5.0

### To spin up the box
1. clone this repo and from the root fire:
2. vagrant plugin install vagrant-berkshelf (from anywhere it can be fired, creates a berkshelf location for cookbooks)
3. vagrant up

### Creates a box with the following in it

        - java 
        - maven 
        - docker
        - git 
        - jenkins

### The Jenkins hosted at http://localhost:9090/
         
1. carthage-pipeline job (For building, testing  [Carthage Rest API Proj](https://github.com/samit2040/carthage.git) and publishing docker Image to dockerhub) 

2. carthage-deploy-docker job (To deploy the [Carthage Docker Image](https://hub.docker.com/r/samit2040/carthage/tags/) onto an existing ec2 instance)
        
