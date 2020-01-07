name: nomad-chapter-5-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 5
## Nomad Job Specification

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss basic Nomad job specification.

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-5-topics
# Chapter 5 Topics

1. Declaring Jobs and Their Target Datacenters
2. Declaring Tasks, Task Groups, and Task Drivers
3. Specifying Required Resources and Networks
4. Registering Tasks as Consul Services

???
* This is our chapter topics slide.

---
class: compact, col-2
name: Declaring Jobs and Their Target Datacenters
# Declaring Jobs and Their Target Datacenters

.smaller[
- Jobs are the primary configuration that users interact with when using Nomad.
- Nomad models infrastructure as regions and datacenters. 
- Regions may contain multiple datacenters. 
- Servers are assigned to a specific region, managing state and making scheduling decisions within that region. 
]
```go
  job "redis-1" {
    datacenters = ["dc1"]
      task "redis" {
        driver = "docker"
        # ...
      }
  }
```

???
* Simple redis job definition

---
class: compact, col-2
name: Declaring Tasks, Task Groups, and Task Drivers
### Declaring Tasks
.smaller[
- The [task](https://www.nomadproject.io/docs/job-specification/task.html) stanza creates an individual unit of work, such as a Docker container, web application, or batch processing.
- Tasks can be short-lived batch jobs or long-running services such as a web application, database server, or API.
]
```go
  job "redis" {
    datacenters = ["dc1"]
      task "redis" {
        driver = "docker"
        # ...
      }
    }
```

???
* same redis example
---
class: compact, col-2
name: Declaring Tasks, Task Groups, and Task Drivers
### Declaring Task Groups

.smaller[
- The [group](https://www.nomadproject.io/docs/job-specification/group.html) stanza defines a series of tasks that should be co-located on the same Nomad client.
- Any task within a group will be placed on the same client.
]
```go
  job "redis" {
    datacenters = ["dc1"]
    group "redis-fleet" {
      task "redis-1" {
        # ...
      }
      task "redis-2" {
        # ...
      }
```

???
* expanding the redis example with groups
---
name: Declaring Tasks, Task Groups, and Task Drivers
### Declaring Task Drivers
.smaller[
-   Task drivers are used by Nomad clients to execute a task and provide resource isolation.
    -  Task driver resource isolation is intended to provide a degree of separation of Nomad client CPU / memory / storage between tasks.
    -  Resource isolation effectiveness is dependent upon individual task driver implementations and underlying client operating systems.
]

???
* task driver explained

---
class: compact, col-2
name: Declaring Tasks, Task Groups, and Task Drivers
### HashiCorp Task Drivers
.smaller[
- There are 5 HashiCorp developed and maintained Task Drivers
  - [Docker Driver](https://www.nomadproject.io/docs/drivers/docker.html)
  - [Isolated Fork/Exec Driver](https://www.nomadproject.io/docs/drivers/exec.html)
  - [Java Driver](https://www.nomadproject.io/docs/drivers/java.html)
  - [QEMU Driver](https://www.nomadproject.io/docs/drivers/qemu.html)
  - [Raw Fork/Exec Driver](https://www.nomadproject.io/docs/drivers/raw_exec.html)
###  Community Task Drivers
- There are 5 OSS Community supported Task Drivers
  - [LXC Driver Driver](https://www.nomadproject.io/docs/drivers/external/lxc.html)
  - [Singularity Driver](https://www.nomadproject.io/docs/drivers/external/singularity.html)
  - [Jail Task Driver](https://www.nomadproject.io/docs/drivers/external/jail-task-driver.html)
  - [Pot Task Driver](https://www.nomadproject.io/docs/drivers/external/pot.html)
  - [Firecracker Task Driver](https://www.nomadproject.io/docs/drivers/external/firecracker-task-driver.html)
]

???
* showing all the drivers except depricated drivers
---
class: compact, col-2
name: Specifying Required Resources and Networks
# Specifying Required Resources
- The resources stanza describes the requirements a task needs to execute. 
  - Resource requirements include memory, network, CPU, and more.


```go
job "redis" {
  group "redis-fleet" {
    task "redis-1" {
      resources {
        cpu    = 100
        memory = 256
        # ...
      }
    }
    task "redis-2" {
        # ...
```

???
* expanding the redis example with networking
---
name: Specifying Required Resources and Networks
# Specifying Networks
.smaller[
-  The network stanza specifies the networking requirements for the task, including the minimum bandwidth and port allocations.
-  When the network stanza is defined at the group level with bridge as the networking mode, all tasks in the task group share the same network namespace.
-  Tasks running within a network namespace are not visible to applications outside the namespace on the same host.
]

???
* good time to throw in consul ;)
---
class: compact, col-1
name: Specifying Required Resources and Networks
# Specifying Networks
```go
job "redis" {
  group "redis-fleet" {
    task "redis-1" {
      resources {
        network {
          mbits = 200
          port "http" {}
          port "lb" {
            static = "8889"
            ...
          }
        }
```

???
* expanding redis example with few network options

---
class: compact, col-2
name: Registering Tasks as Consul Services
# Registering Tasks as Consul Services
.smaller[
- The consul stanza configures the Nomad agent's communication with [Consul](https://www.consul.io/) for service discovery and key-value integration. 
- When configured, tasks can register themselves with Consul, and the Nomad cluster can [automatically bootstrap](https://www.nomadproject.io/guides/operations/cluster/automatic.html) itself.
]

```go
consul {
  address = "127.0.0.1:8500"
  auth    = "admin:password"
  token   = "abcd1234"
}
```
