name: nomad-chapter-5-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 5
## Nomad Jobs and Drivers

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss Nomad jobs and drivers and cover basic Nomad job specification.

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-5-topics
# Chapter 5 Topics

1. Job and Scheduler Types
1. Declaring Jobs and Their Target Datacenters
1. Declaring Task Groups, Tasks, and Task Drivers
1. Specifying Required Resources and Networks
1. Registering Tasks as Consul Services

???
* This is our chapter topics slide.

---
name: jobs-definition
class: compact
# Nomad Jobs
* We've already discussed **Nomad Jobs** in Chapter 2 and have already run a simple job in our first lab.
* But what exactly is a Nomad Job?
  * A specification provided by a user that declares  a workload for Nomad.
  * A form of **desired state** for that workload.
  * The actual workload executed by the job.
* Nomad decides where the job should run and makes sure that the **actual state** matches the user's desired state.
* Jobs are composed of one or more task groups which contain tasks.

???
* Define Jobs again to make sure we're all on the same page.

---
name: Job Types and Schedulers
class: col-2, smaller
# Nomad Job Types and Schedulers
- The [type stanza](https://www.nomadproject.io/docs/job-specification/job.html#type) specifies the Nomad scheduler to use.
 - Nomad has three scheduler types that can be used when creating your job:
  - `service`
  - `system`
  - `batch`

<br>

```hcl
job "example" {
  datacenters = ["dc1"]
* type = "system"
}
```
???
* There are 3 types of Nomad jobs, corresponding to the three types of Nomad schedulers

---
name: Service Scheduler
# Service Scheduler
- The [Service Scheduler](https://www.nomadproject.io/docs/schedulers.html#service) is designed for scheduling long lived services that should never go down
- Service jobs are intended to run until explicitly stopped by an operator.
- If a service task exits it is considered a failure and handled according to the job's `restart` and `reschedule` stanzas.

???
* First, we have the Service Scheduler

---
name: Batch Scheduler
# Batch Scheduler
  - The [Batch Scheduler](https://www.nomadproject.io/docs/schedulers.html#batch) runs batch jobs, which are short lived, usually finishing in a few minutes to a few days.
  - They are much less sensitive to short term performance fluctuations.
  - Batch jobs are intended to run until they exit successfully.
  - Batch tasks that exit with an error are handled according to the job's `restart` and `reschedule` stanzas.

???
* Then, we have the Batch Scheduler

---
name: System Scheduler
class: smaller
# System Scheduler
- The [System Scheduler](https://www.nomadproject.io/docs/schedulers.html#system) registers jobs that should run on all clients that meet constraints.
- It is also invoked when clients join the cluster or transition into the ready state.
  - This means that all registered system jobs will be re-evaluated and their tasks will be placed on the newly available nodes if the constraints are met.
- Systems jobs are intended to run until explicitly stopped either by an operator or by preemption.
- If a system task exits it is considered a failure and handled according to the job's `restart` stanza.
- System jobs do not have rescheduling.

???
* And last we have the System Scheduler.

---
name: Declaring Jobs and Their Target Datacenters
class: compact, col-2
# Declaring Jobs and Their Target Datacenters

.smaller[
- [Nomad Jobs](https://www.nomadproject.io/docs/job-specification) are the primary configuration that users interact with when using Nomad.
- Nomad models infrastructure as regions and datacenters.
- Regions may contain multiple datacenters.
- Servers are assigned to a specific region, managing state and making scheduling decisions within that region.
]

```hcl

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
name: Declaring Task Groups
class: compact, col-2
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
```hcl

job "example" {
  datacenters = ["dc1"]
*  group "cache" {
*    task "redis" {
*     driver = "docker"
*    }
*    task "web" {
*     driver = "docker"
*    }
*  }
}
```

???
* expanding the redis example with groups

---
name: Declaring Tasks
class: compact, col-2
# Declaring Tasks
.smaller[
- The [task stanza](https://www.nomadproject.io/docs/job-specification/task.html) creates an individual unit of work, such as a Docker container, web application, or batch processing.
- Tasks can be short-lived batch jobs or long-running services such as a web application, database server, or API.
]
<br>
```hcl
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
name: Declaring Task Drivers
class: compact, col-2
# Declaring Task Drivers
.smaller[
-   [Task Drivers](https://www.nomadproject.io/docs/drivers) are used by Nomad clients to execute a task and provide resource isolation.
    -  Task driver resource isolation is intended to provide separation of Nomad client CPU, memory, and storage between tasks.
    -  Resource isolation effectiveness is dependent upon individual task driver implementations and underlying operating systems.
]
<br>
```hcl

job "example" {
  datacenters = ["dc1"]
   group "cache" {
     task "redis" {
*     driver = "docker"
     }
     task "web" {
*     driver = "docker"
     }
  }
}
```

???
* task driver explained

---
name: HashiCorp and Community Task Drivers
class: compact, col-2
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
name: Specifying Required Resources
class: compact, col-2
# Specifying Required Resources
- The [resources stanza](https://www.nomadproject.io/docs/job-specification/resources.html) describes the requirements a task requires.
  - Resource requirements include memory, network, CPU, and device.
  - Tasks will only be scheduled to client nodes that satisfy its resource requirements.

<br>
```hcl

job "example" {
  group "cache"
  {
    task "redis" {
*     resources {
*       cpu    = 500
*       memory = 256
*       network {
*         mbits = 100
*         port  "db"  {}
*       }
*     }
    }
  }
}
```

???
* expanding the redis example with resources

---
name: Specifying Networking
class: compact, col-2
# Specifying Networking
- The [network stanza](https://www.nomadproject.io/docs/job-specification/network.html) specifies the networking requirements for the task.
  - Bandwidth
  - Port Allocations

<br>
<br>
<br>

```hcl

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
name: Specifying Port Mapping
# Specifying Port Mapping
.smaller[
- Nomad supports [Dynamic Ports](https://www.nomadproject.io/docs/job-specification/network.html#dynamic-ports), [Static Ports](https://www.nomadproject.io/docs/job-specification/network.html#static-ports), and [Mapped Ports](https://www.nomadproject.io/docs/job-specification/network.html#mapped-ports).

* In this example, Redis is listening on port 6379 inside the Docker container.
* Nomad will dynamically select a port and map requests sent to it to port 6379 inside the container.
]

<br>
<br>
<br>

```hcl

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
name: Specifying Bridged Networks
class: compact, col-2
# Specifying Bridged Networks
.smaller[
-  When the network stanza is defined at the group level with [bridge](https://www.nomadproject.io/docs/job-specification/network.html#bridge-mode) as the networking mode, all tasks in the task group share the same network namespace.
-  Tasks running within a network namespace are not visible to applications outside the namespace on the same host.
]

<br>
<br>
<br>

```hcl

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
name: Registering Tasks as Consul Services
class: compact, col-2
# Registering Tasks as Consul Services
.smaller[
- The [service stanza](https://www.nomadproject.io/docs/job-specification/service.html) instructs Nomad to register the service with Consul for Service Discovery.
- We can define tags, health checks, ports, and several other [parameters](https://www.nomadproject.io/docs/job-specification/service.html#service-parameters).
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
```hcl

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

* In this chapter, you learned some of the most important aspects of Nomad jobs:
  * Types of jobs and schedulers
  * Jobs and their target datacenters
  * Task groups, tasks, and task drivers
  * Required resources
  * Networking and port mapping
  * Registering tasks as Consul services

???
* What we learned in this chapter
