# Docker Deep Dive

---

## Andrew Pruski

### SQL Server DBA, Microsoft Data Platform MVP, & Certified Kubernetes Administrator

<a href="https://twitter.com/dbafromthecold">@dbafromthecold</a><br>
www.dbafromthecold.com<br>
<a href="https://github.com/dbafromthecold">github.com/dbafromthecold.com</a>

---

## Session Aim

To provide a deeper knowledge of the Docker platform

---

## Agenda

- Isolation<br>
- Networking<br>
- Persisting data<br>
- Custom images<br>
- Docker Compose<br>

---

# Isolation

---

## Container Isolation

>Containers isolate software from its environment and ensure that it works uniformly 
>despite differences for instance between development and staging
(https://www.docker.com/resources/what-container)

---

## Control Groups

Ensures a single container cannot consume all<br>
resources of the host<br>
<br>
Implements resource limiting of:-
- CPU
- Memory

---

## Namespaces

Control what a container can see<br>
<br>
Used to control:-<br>
- Hostname within the container
- Processes that the container can see
- Mapping users in the container to users on the host

---

## File system

- Containers cannot see the entire host's filesystem<br>
- They can only see a subset of that filesystem<br>
- The container root directory is changed upon start up

---

# Demo

---

# Networking

---

## Default networks

<img src="assets/images/docker_default_networks.png" style="float: right"/>

- bridge<br>
- host<br>
- none<br>

---

## Bridge network

Default network<br>
Represents _docker0_ network in the host network stack<br>
Containers communicate by IP address<br>
Supports port mapping 

---

## User defined networks

Docker provide multiple drivers<br>
Enables DNS resolution of container names to IP addresses<br>
Can be connected to more than one network<br>
Connect/disconnect from networks without restarting<br>

---

# Demo

---

# Persisting data

---

## Options for persisting data

- Bind mounts<br>
- Data volume containers<br>
- Named volumes

---

# Demo

---

# Custom images

---

## Building your own image

- Custom images built from a file containing instructions<br>
- Known as a dockerfile<br>
- Customise the image to grant permissions to directories<br>
- Add databases to SQL Server, ready to go when container starts<br>

---

?code=assets/code/customimage&lang=bash&title=Building a container image

@[1](Specifying the base image to build from)
@[3](Switching to the root user)
@[5-8](Creating directories)
@[10](Changing the owner of the directories)
@[12](Switching to the mssql user)
@[14](Starting SQL Server)

---

# Demo

---

# Docker Compose

?code=assets/code/docker_container_run.sh&lang=bash&title=Running a Container

@[1](Run container in the background)
@[2](Mapping ports)
@[3-4](Setting the SA password and accepting the EULA)
@[5](Enabling the Agent)
@[6-8](Setting the default directories)
@[9](Attaching the container to a custom network)
@[10-13](Mapping the named volumes)
@[14](Specifying a name for the container)
@[15](Specifying the image to build the container from)

---

## What is Compose?

>Compose is a tool for defining and running multi-container Docker applications. 
>With Compose, you use a YAML file to configure your application’s services. 
>Then, with a single command, you create and start all the services from your configuration.](docs.docker.com/compose

---

# Demo

---

## Resources

@size[0.8em](https://github.com/dbafromthecold/DockerDeepDive)<br>
@size[0.8em](http://tinyurl.com/y3x29t3j/summary-of-my-container-series)<br>
@size[0.8em](https://github.com/dbafromthecold/SqlServerAndContainersGuide)

<p align="center">
<img src="assets/images/dockerdeepdive_qr_code.png" />
</p>

