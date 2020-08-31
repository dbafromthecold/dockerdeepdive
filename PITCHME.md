# Docker Deep Dive

---

## Andrew Pruski

### SQL Server DBA & Microsoft Data Platform MVP

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

## Control Groups

Implements resource limiting of:-
- CPU
- Memory
- Disk IO

Ensures a single container cannot consume all<br>
resources of the host

---

## Namespaces

Processes within the container cannot see<br>
processes on the host or in other containers

---

## Union file system

<p align="center">
<img src="assets/images/docker_container_layers.jpg"/>
</p>

@size[0.4em](https://docs.docker.com/v17.09/engine/userguide/storagedriver/imagesandcontainers/#container-and-layers)

---

# Demo

---

# Networking

---

## Default networks

<img src="assets/images/docker_default_networks.png" style="float: right"/>

- bridge<br>
- host<br>
- null<br>

---

## Bridge network

Default network<br>
Represents _docker0_ network in the host network stack<br>
Containers communicate by IP address<br>
Supports port mapping 

---

## User defined networks

@size[0.8em](Enables DNS resolution of container names to IP addresses<br>)
@size[0.8em](Docker provide multiple drivers<br>)
@size[0.8em](Can be connected to more than one network<br>)
@size[0.8em](Connect/disconnect from networks without restarting<br>)

---

# Demo

---

# Persisting data

---

## Options for persisting data

- Bind mounts<br>
- Named volumes<br>
- Data volume containers<br>

---

# Demo

---

# Docker Compose

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

@size[0.8em](https://tinyurl.com/yyz8fe9x/DockerDeepDive)<br>
@size[0.8em](http://tinyurl.com/y3x29t3j/summary-of-my-container-series/)

<p align="center">
<img src="assets/images/dockerdeepdive_qr_code.png" />
</p>

