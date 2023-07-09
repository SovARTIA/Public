# Sovereignty ARTIA Container Guide

## Prerequisites


- THIS FOLDER CONTAINS DOCKER CONTAINER YAML FILES. YOU WILL NEED TO HAVE <a href="https://docs.docker.com/engine/install/">DOCKER ENGINE</a> + <a href="https://docs.docker.com/compose/install/">DOCKER-COMPOSE</a> INSTALLED IN ORDER TO GET THESE YAML FILES TO WORK.

- IT IS ALSO **HIGHLY** RECOMMENDED TO USE <a href="https://docs.portainer.io/start/install-ce/server/docker">PORTAINER</a> UNLESS YOU HAVE AN ALTERNATIVE METHOD OF CONTAINER MANAGEMENT
<br>

## Additional Suggestions


- <a href="https://docs.docker.com/develop/develop-images/dockerfile_best-practices/">Docker recommends</a> that users create their own networks (<a href="https://docs.portainer.io/user/docker/networks/add">How to do this in Portainer</a>) (<a href="https://www.geeksforgeeks.org/basics-of-docker-networking/">How to do this using the Command Line Interface [CLI]</a>) when creating multiple docker containers that are to be used simultaneously. As such, these YAML files have be created to use an external bridged network called:
<br> 
"sovbridge"
<br>
You will need to create this network first in order to make sure that the containers have a network to attach to when they're made. If no manual network is made when these files are pulled down then the container will fail to deploy.

- It is also recommended that you use <a href ="https://www.cyberithub.com/system-users-and-human-users-in-linux-explained-with-examples/">System User</a> accounts when deploying containers to a potentially public-facing host