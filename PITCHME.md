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
- Storing images<br>
- Persisting data<br>
- Docker Compose<br>
- Non-root containers<br>
@ulend

---

# Isolation

---

## Namespaces

Processes within the container cannot see<br>
processes on the host or in other containers

---

## Control Groups

Implements resource limiting of
- CPU
- Memory
- Disk IO

Ensures a single container cannot consume all<br>
resources of the host

---

## Overlay file system

---

# Networking

---

## Default network drivers

<img src="assets/images/docker_network_ls.png" style="float: right"/>

bridge<br>
host<br>
null<br>

---

## Bridge network

Default network<br>
Represents _docker0_ network in the host network stack<br>
Containers communicate by IP address<br>
Supports port mapping 

---

## User defined networks

@size[0.8em](Enables DNS resolution of container names to IP addresses<br>)
@size[0.8em](Docker provide default drivers for:-<br>)
@size[0.8em](- bridge network<br>)
@size[0.8em](- overlay network<br>)
@size[0.8em](- MACVLAN network<br>)
@size[0.8em](Can be connected to more than one network<br>)
@size[0.8em](Connect/disconnect from networks without restarting<br>)

---

# Registries

---

# Persisting data

---

# Docker Compose

---

# Non-root containers

---

## Resources

@size[0.8em](https://tinyurl.com/yyz8fe9x/DockerDeepDive)<br>
@size[0.8em](http://tinyurl.com/y3x29t3j/summary-of-my-container-series/)

