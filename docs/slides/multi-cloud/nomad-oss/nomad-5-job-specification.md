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
- [Nomad Jobs](https://www.nomadproject.io/docs/job-specification) are the primary configuration that users interact with when using Nomad.
- Nomad models infrastructure as regions and datacenters.
- Regions may contain multiple datacenters.
- Servers are assigned to a specific region, managing state and making scheduling decisions within that region.
]

```go

*job "example" {
* datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      driver = "docker"
      config {
      }
    }
  }
}
```

???
* Simple redis job definition
---
class: compact, col-2
name: Declaring Tasks, Task Groups, and Task Drivers
# Declaring Task Groups

.smaller[
- The [group stanza](https://www.nomadproject.io/docs/job-specification/group.html) defines a series of tasks that should be co-located on the same Nomad client.
- Any task within a group will be placed on the same client.
- But note that multiple instances of a task group can be placed.
]
<br>
<br>
<br>
<br>

```go

job "example" {
  datacenters = ["dc1"]
*  group "cache" {
*    task "redis-1" {
*     driver = "docker"
*     config {
*     }
*    task "redis-2" {
*     driver = "docker"
*     config {
*     }
*   }
* }
}
```

???
* expanding the redis example with groups
---
class: compact, col-2
name: Declaring Tasks, Task Groups, and Task Drivers
### Declaring Tasks
.smaller[
- The [task stanza](https://www.nomadproject.io/docs/job-specification/task.html) creates an individual unit of work, such as a Docker container, web application, or batch processing.
- Tasks can be short-lived batch jobs or long-running services such as a web application, database server, or API.
]
<br>
```go
job "example" {
  datacenters = ["dc1"]
   group "cache" {
*    task "redis" {
*      driver = "docker"
*      config {
*      }
*    }
  }
}
```

???
* same redis example

---
class: compact, col-2
name: Declaring Tasks, Task Groups, and Task Drivers
### Declaring Task Drivers
.smaller[
-   [Task Drivers](https://www.nomadproject.io/docs/drivers) are used by Nomad clients to execute a task and provide resource isolation.
    -  Task driver resource isolation is intended to provide a degree of separation of Nomad client CPU, memory, and storage between tasks.
    -  Resource isolation effectiveness is dependent upon individual task driver implementations and underlying client operating systems.
]
<br>
```go
job "example" {
  datacenters = ["dc1"]
   group "cache" {
     task "redis-1" {
*     driver = "docker"
      config {
      }
     task "redis-2" {
*     driver = "docker"
      config {
      }
    }
  }
}
```

???
* task driver explained

---
class: compact, col-2
name: Declaring Tasks, Task Groups, and Task Drivers
### HashiCorp Task Drivers
.smaller[
- There are 5 task drivers developed and maintained by HashiCorp
  - [Docker Driver](https://www.nomadproject.io/docs/drivers/docker.html)
  - [Isolated Fork/Exec Driver](https://www.nomadproject.io/docs/drivers/exec.html)
  - [Java Driver](https://www.nomadproject.io/docs/drivers/java.html)
  - [QEMU Driver](https://www.nomadproject.io/docs/drivers/qemu.html)
  - [Raw Fork/Exec Driver](https://www.nomadproject.io/docs/drivers/raw_exec.html)
<br>

###  Community Task Drivers
- There are 5 open source community supported task drivers
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
- The [resources stanza](https://www.nomadproject.io/docs/job-specification/resources.html) describes the requirements a task needs to execute.
  - Resource requirements include memory, network, CPU, and device.
  - Tasks will only be scheduled to client nodes that satisfy its resource requirements.


```go


job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      driver = "docker"
*     resources {
*       cpu    = 500
*       memory = 256
*       network {
*         mbits = 100
*         port  "db"  {}
*       }
*     }
    }
```

???
* expanding the redis example with resources

---
class: compact, col-2
name: Specifying Required Resources and Networks
# Specifying Networking
- The [network stanza](https://www.nomadproject.io/docs/job-specification/network.html) specifies the networking requirements for the task.
  - Bandwidth
  - Port Allocations

<br>
<br>
<br>

```go

job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      driver = "docker"
      resources {
        cpu    = 500
        memory = 256
*       network {
*         mbits = 100
*         port  "db"  {}
*       }
      }
    }
```

???
* expanding the redis example with networking

---
class: compact, col-2
name: Specifying Required Resources and Networks
# Specifying Port Mapping
.smaller[
- Nomad supports [Dynamic Ports](https://www.nomadproject.io/docs/job-specification/network.html#dynamic-ports), [Static Ports](https://www.nomadproject.io/docs/job-specification/network.html#static-ports), and [Mapped Ports](https://www.nomadproject.io/docs/job-specification/network.html#mapped-ports).

* In this example, Redis is listening on port 6379 inside the Docker container.
* Nomad will dynamically select a port and map requests sent to it to port 6379 inside the container.
]

<br>
<br>

```go


job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      driver = "docker"
      config {
*       port_map = {
*         db = 6379
*       }
      }
      resources {
        network {
*         port "db" {}
        }
      }
```

???
* port mapping

---
class: compact, col-2
name: Specifying Required Resources and Networks
# Specifying Bridged Networks
.smaller[
-  When the network stanza is defined at the group level with [bridge](https://www.nomadproject.io/docs/job-specification/network.html#bridge-mode) as the networking mode, all tasks in the task group share the same network namespace.
-  Tasks running within a network namespace are not visible to applications outside the namespace on the same host.
]

<br>
<br>
<br>

```go

job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      driver = "docker"
    }
    network {
*     mode = "bridge"
*       port "http" {
*         static = 9002
*         to     = 9002
*       }
*     }
    }
  }
```

???
* good time to throw in consul ;)

---
class: compact, col-2
name: Registering Tasks as Consul Services
# Registering Tasks as Consul Services
.smaller[
- The [service stanza](https://www.nomadproject.io/docs/job-specification/service.html) instructs Nomad to register the service with Consul for Service Discovery.
- We can define tags, health checks, ports, and [several other parameters](https://www.nomadproject.io/docs/job-specification/service.html#service-parameters).
]
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
```go

job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
*     service {
*       tags = ["leader", "redis"]
*       port = "db"
*         check {
*           type     = "tcp"
*           port     = "db"
*           interval = "10s"
*           timeout  = "2s"
*         }
*       }
*     }
```

???
* for sure now talk about consul

---
name: nomad-5-Summary
# 📝 Chapter 5 Summary

* In this chapter, you learned some of the most important aspects of Nomad job specification:
  * Jobs and their target datacenters
  * Task groups, tasks, and task drivers
  * Required resources
  * Networking and port mapping
  * Registering tasks as Consul services

???
* What we learned in this chapter
