# A deep dive into Docker

---

## Andrew Pruski

<img src="images/apruski.jpg" style="float: right"/>

### Field Solutions Architect
### Microsoft Data Platform MVP

<!-- .slide: style="text-align: left;"> -->
<i class="fab fa-twitter"></i><a href="https://twitter.com/dbafromthecold">  @dbafromthecold</a><br>
<i class="fas fa-envelope"></i>  dbafromthecold@gmail.com<br>
<i class="fab fa-wordpress"></i>  www.dbafromthecold.com<br>
<i class="fab fa-github"></i><a href="https://github.com/dbafromthecold">  github.com/dbafromthecold</a>

---

## Session Aim
<!-- .slide: style="text-align: left;"> -->
To provide a deeper knowledge of the Docker platform

---

## Agenda
<!-- .slide: style="text-align: left;"> -->
- Isolation<br>
- Networking<br>
- Persisting data<br>
- Custom images<br>
- Docker Compose<br>

---

# Isolation

---

## Container Isolation
<!-- .slide: style="text-align: left;"> -->
"Containers isolate software from its environment and ensure that it works uniformly despite differences for instance between development and staging"<br>
<font size="6"><a href="https://www.docker.com/resources/what-container">docker.com/resources/what-container</a></font>

---

## Control Groups
<!-- .slide: style="text-align: left;"> -->
Ensures a single container cannot consume all<br>
resources of the host<br>
<br>
Implements resource limiting of:-
- CPU
- Memory

---

## Namespaces
<!-- .slide: style="text-align: left;"> -->
Control what a container can see<br>
<br>
Used to control:-<br>
- Hostname within the container
- Processes that the container can see
- Mapping users in the container to users on the host

---

## File system
<!-- .slide: style="text-align: left;"> -->
- Containers cannot see the entire host's filesystem<br>
- They can only see a subset of that filesystem<br>
- The container root directory is changed

---

# Demo

---

# Networking

---

## Default networks
<!-- .slide: style="text-align: left;"> -->
<img src="images/docker_default_networks.png" style="float: right"/>

- bridge<br>
- host<br>
- none<br>

---

## Bridge network
<!-- .slide: style="text-align: left;"> -->
- Default network<br>
- Represents _docker0_ network<br>
- Containers communicate by IP address<br>
- Supports port mapping 

---

## User defined networks
<!-- .slide: style="text-align: left;"> -->
- Docker provide multiple drivers<br>
- DNS resolution of container names to IP addresses<br>
- Can be connected to more than one network<br>
- Connect/disconnect from networks without restarting<br>

---

# Demo

---

# Persisting data

---

## Options for persisting data
<!-- .slide: style="text-align: left;"> -->
- Bind mounts<br>
- Data volume containers<br>
- Named volumes

---

# Demo

---

# Custom images

---

## Building your own image
<!-- .slide: style="text-align: left;"> -->
- Custom images built from a file<br>
- Known as a dockerfile<br>
- Customise the image to grant permissions<br>
- Add databases to SQL Server<br>

---

## Dockerfile

<pre><code data-line-numbers="1|3|5-8|10|12|14">FROM mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04

USER root

RUN mkdir /var/opt/sqlserver
RUN mkdir /var/opt/sqlserver/sqldata
RUN mkdir /var/opt/sqlserver/sqllog
RUN mkdir /var/opt/sqlserver/sqlbackups

RUN chown -R mssql /var/opt/sqlserver

USER mssql

CMD /opt/mssql/bin/sqlservr
</pre></code>

---

# Demo

---

# Docker Compose

---

## Docker container run

<pre><code data-line-numbers="1|2|3-8|9|10-13|14|15">docker container run -d
--publish 15789:1433
--env SA_PASSWORD=Testing1122
--env ACCEPT_EULA=Y
--env MSSQL_AGENT_ENABLED=True
--env MSSQL_DATA_DIR=/var/opt/sqlserver/sqldata
--env MSSQL_LOG_DIR=/var/opt/sqlserver/sqllog
--env MSSQL_BACKUP_DIR=/var/opt/sqlserver/sqlbackups
--network sqlserver
--volume sqlsystem:/var/opt/mssql
--volume sqldata:/var/opt/sqlserver/sqldata
--volume sqllog:/var/opt/sqlserver/sqllog
--volume sqlbackup:/var/opt/sqlserver/sqlbackups
--name sqlcontainer1
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04
</pre></code>

---

## What is Compose?
<!-- .slide: style="text-align: left;"> -->
"Compose is a tool for defining and running multi-container Docker applications.
With Compose, you use a YAML file to configure your application`s services.
Then, with a single command, you create and start all the services from your configuration."<br>
<font size="6"><a href="https://docs.docker.com/compose/">docs.docker.com/compose</a></font>

---

# Demo

---

## Resources
<!-- .slide: style="text-align: left;"> -->
<font size="6">
<a href="https://github.com/dbafromthecold/DockerDeepDive">https://github.com/dbafromthecold/DockerDeepDive</a><br>
</font>

<p align="center">
<img src="images/dockerdeepdive_qr_code.png" />
</p>
