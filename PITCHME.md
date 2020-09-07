# Docker Deep Dive

---

## Andrew Pruski

### SQL Server DBA, Microsoft Data Platform MVP & Certified Kubernetes Administrator

@fa[twitter] @dbafromthecold <br>
@fa[envelope] dbafromthecold@gmail.com <br>
@fa[wordpress] www.dbafromthecold.com <br>
@fa[github] github.com/dbafromthecold

---

## Session Aim

To provide a deeper knowledge of the Docker platform

---

## Agenda

@ul
- Isolation<br>
- Networking<br>
- Persisting data<br>
- Docker Compose<br>
- Non-root containers<br>
@ulend

---

# Isolation

---

## Container Isolation

@quote[Containers isolate software from its environment and ensure that it works uniformly despite differences for instance between development and staging](https://www.docker.com/resources/what-container)

---

## Control Groups

Ensures a single container cannot consume all<br>
resources of the host<br>
<br>
Implements resource limiting of:-
@ul
- CPU
- Memory
@ulend

---

## Namespaces

Control what a container can see<br>
<br>
Used to control:-<br>
@ul
- Hostname within the container
- Processes that the container can see
- Mapping users in the container to users on the host
@ulend

---

## File system

@ul
- Containers cannot see the entire host's filesystem<br>
- They can only see a subset of that filesystem<br>
- The container root directory is changed upon start up
@ulend

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

@size[0.8em](Docker provide multiple drivers<br>)
@size[0.8em](Enables DNS resolution of container names to IP addresses<br>)
@size[0.8em](Can be connected to more than one network<br>)
@size[0.8em](Connect/disconnect from networks without restarting<br>)

---

# Demo

---

# Persisting data

---

## Options for persisting data

@ul
- Bind mounts<br>
- Data volume containers<br>
- Named volumes
@ulend

---

# Demo

---

# Docker Compose

---?code=assets/code/run_container.sh&lang=bash&title=Running a Container

@[1](Run container in the background)
@[2](Mapping ports)
@[3](Setting the SA password)
@[4](Accepting the EULA)
@[5](Enabling the Agent)
@[6](Setting the default data directory)
@[7](Setting the default log directory)
@[8](Setting the default backup directory)
@[9](Attaching the container to a custom network)
@[10](Mapping the sqlsystem named volume)
@[11](Mapping the sqldata named volume)
@[12](Mapping the sqllog named volume)
@[13](Mapping the sqlbackup named volume)
@[14](Specifying a name for the container)
@[15](Specifying the image to build the container from)

---

## What is Compose?

@quote[Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.](docs.docker.com/compose)

---

# Demo

---

# Non-root containers

---

## What user does SQL run as?

Before 2019, SQL ran as root within the container<br>
Now SQL runs as the MSSQL user<br>

<p align="center">
<img src="assets/images/sql_nonroot_container.png" />
</p>

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

