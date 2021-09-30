name: nomad-chapter-4-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 4
## Nomad Jobs & Drivers

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss Nomad jobs and drivers and cover basic Nomad job specification.

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-4-topics
# Chapter 4 Topics

1. Nomad Job(작업) 및 스케줄러
1. Job 및 대상 데이터센터 선언
1. Job group, Task, Task Driver 선언
1. Task에서 사용할 수 있는 Task Driver
1. 필요한 리소스 및 네트워크 지정
1. Task를 Consul 서비스로 등록

???
* This is our chapter topics slide.

---
name: jobs-definition
class: compact
# Nomad Jobs
* 우리는 이미 2 장에서 **Nomad Jobs**에 대해 이야기했으며 첫 번째 실습에서 간단한 작업을 실행했습니다.
* Nomad Job이란 아래와 같습니다.
     * Nomad에 대한 워크로드를 선언하는 사용자가 제공 한 사양입니다.
     * 해당 워크로드에 대한 원하는 **상태** 형식.
     * Job에 의해 실행 된 실제 워크로드.
  * Nomad는 Job을 실행할 위치를 결정하고 **실제 상태 **가 사용자가 원하는 상태와 일치하는지 확인합니다.
  * Job은 Task을 포함하는 하나 또는 하나 이상의 Task Group으로 구성됩니다.

???
* Define Jobs again to make sure we're all on the same page.

---
name: Nomad Job and Scheduler Types
class: col-2, smaller
# Nomad Job & Scheduler Types
- [type stanza](https://www.nomadproject.io/docs/job-specification/job.html#type)는 사용할 Nomad 스케줄러를 지정합니다.
- Nomad에는 작업을 생성 할 때 사용할 수있는 세 가지 스케줄러 유형이 있습니다.
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
- [서비스 스케줄러](https://www.nomadproject.io/docs/schedulers.html#service)는 중단되지 않아야하는 장기 실행 서비스를 예약하도록 설계되었습니다.
- 서비스 작업은 운영자가 명시 적으로 중지 할 때까지 실행됩니다.
- 서비스 작업이 종료되면 실패로 간주되고 작업의 'restart'및 'reschedule'스탠자에 따라 처리됩니다.

???
* First, we have the Service Scheduler

---
name: Batch Scheduler
# Batch Scheduler
  - [배치 스케줄러](https://www.nomadproject.io/docs/schedulers.html#batch)는 수명이 짧은 일괄 Job을 실행하며 일반적으로 몇 분에서 며칠 내에 완료됩니다.
  - 단기 성능 변동에 덜 민감합니다.
  - 일괄 작업은 성공적으로 종료 될 때까지 실행됩니다.
  - 오류와 함께 종료 된 일괄 작업은 작업의 'restart'및 'reschedule'스탠자에 따라 처리됩니다.

???
* Then, we have the Batch Scheduler

---
name: System Scheduler
class: smaller
# System Scheduler
- [시스템 스케줄러](https://www.nomadproject.io/docs/schedulers.html#system)는 제약 조건을 충족하는 모든 클라이언트에서 실행되어야하는 Job을 등록합니다.
- 클라이언트가 클러스터에 참여하거나 준비 상태로 전환 될 때도 호출됩니다.
  - 즉, 등록 된 모든 시스템 작업이 재평가되고 제약 조건이 충족되면 해당 작업이 새로 사용 가능한 노드에 배치됩니다
- 시스템 Job은 운영자 또는 선점에 의해 명시 적으로 중지 될 때까지 실행됩니다.
- 시스템 Job이 종료되면 실패로 간주되고 작업의 'restart'스탠자에 따라 처리됩니다.
- 시스템 Job은 rescheduling 되지 않습니다.

???

* And last we have the System Scheduler.

---
name: Declaring Jobs and Their Target Datacenters
class: compact, col-2
# 작업 및 대상 데이터 센터 선언

.smaller[
- [Nomad Jobs](https://www.nomadproject.io/docs/job-specification)는 사용자가 Nomad를 사용할 때 상호 작용하는 기본 구성입니다.
- Nomad는 인프라를 Region 및 Datacenter로 모델링합니다.
- Region에는 여러 Datacenter가 포함될 수 있습니다.
- 서버는 특정 Region에 할당되어 해당 Region 내에서 상태를 관리하고 스케줄링을 결정합니다.

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
# Task Groups 선언

.smaller[
- [group stanza](https://www.nomadproject.io/docs/job-specification/group.html)는 동일한 Nomad 클라이언트에 함께 배치되어야하는 일련의 작업을 정의합니다.
- group 내의 모든 Task는 동일한 클라이언트에 배치됩니다.
- 하나의  job에는 다중의 group 인스턴스를 배치 할 수 있습니다.

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
# Tasks 선언
.smaller[
- [task stanza](https://www.nomadproject.io/docs/job-specification/task.html)는 Docker 컨테이너, 웹 애플리케이션 또는 일괄 처리 배치와 같은 개별 작업 단위를 만듭니다.
- Task는 단기 배치 작업이거나 웹 애플리케이션, 데이터베이스 서버 또는 API와 같은 장기 실행 서비스 일 수 있습니다.]
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
# Task Drivers 선언
.smaller[
-   [Task Driver] (https://www.nomadproject.io/docs/drivers)는 Nomad 클라이언트가 작업을 실행하고 리소스 격리를 제공하는 데 사용됩니다.
-   Task Driver 리소스 격리는 작업간에 Nomad 클라이언트 CPU, 메모리 및 스토리지를 분리하기위한 것입니다.
-   리소스 격리 효과는 개별 작업 드라이버 구현 및 기본 운영 체제에 따라 다릅니다.

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
- HashiCorp에서 개발 및 유지 관리하는 Task Driver
  - [Docker Driver](https://www.nomadproject.io/docs/drivers/docker.html)
  - [Raw Fork/Exec Driver](https://www.nomadproject.io/docs/drivers/raw_exec.html)
  - [Isolated Fork/Exec Driver](https://www.nomadproject.io/docs/drivers/exec.html)
  - [Java Driver](https://www.nomadproject.io/docs/drivers/java.html)
  - [QEMU Driver](https://www.nomadproject.io/docs/drivers/qemu.html)
  - [Podman Driver](https://www.nomadproject.io/docs/drivers/podman)
<br>
<br>

###  Community Task Drivers
- 커뮤니티에서 개발 및 유지 관리하는 Task Driver
  - [LXC Driver](https://www.nomadproject.io/docs/drivers/external/lxc/)
  - [Singularity Driver](https://www.nomadproject.io/docs/drivers/external/singularity/)
  - [Jail Driver](https://www.nomadproject.io/docs/drivers/external/jail-task-driver/)
  - [Pot Driver](https://www.nomadproject.io/docs/drivers/external/pot/)
  - [Firecracker Driver](https://www.nomadproject.io/docs/drivers/external/firecracker-task-driver/)
  - [Nspawn Driver](https://www.nomadproject.io/docs/drivers/external/nspawn/)
  - [Windows IIS Driver](https://www.nomadproject.io/docs/drivers/external/iis)
]

???
* showing all the drivers except depricated drivers

---
name: Docker Task Driver
class: compact, col-2
# Docker Task Driver
.smaller[
- [Docker Driver](https://www.nomadproject.io/docs/drivers/docker.html) (`docker`)는 Docker 컨테이너를 관리하고 실행합니다.
- 가장 주요한 (그리고 유일한 필수) 구성 설정은 사용할 Docker 이미지를 지정하는`image`입니다.
- 다른 많은 설정이 있으며 대부분은`docker run` 명령에 전달할 수있는 인수에 해당합니다.
- `docker` 드라이버는 호스트 네트워크의 포트를 컨테이너에 매핑 할 수 있습니다.

]

<br>


```hcl

task "redis" {
  driver = "docker"
    config {
      image = "redis:3.2"
      port_map {
        db = 6379
      }
    }
  }
}
```

???
* The Docker Driver runs Docker containers from Docker images.
It can map ports.
* It has a lot of configuration options

---
name: Raw Fork/Exec Driver
class: compact, col-2
# Raw Fork/Exec Driver
.smaller[
- [Raw Fork / Exec Driver](https://www.nomadproject.io/docs/drivers/raw_exec.html) (`raw_exec`)는 격리기능 없이 명령을 실행하는 데 사용됩니다.
- 작업은 Nomad 프로세스와 동일한 사용자로 시작됩니다.
- **따라서 매우주의해서 사용해야하며 보안상의 이유로 기본적으로 비활성화되어 있습니다.**
- `plugin` 스탠자의 Nomad 클라이언트 구성에서 활성화 할 수 있습니다.]


```hcl

task "example" {
  driver = "raw_exec"
  config {
    command = "/bin/sleep"
    args    = ["1"]
  }
}
```

???
* The Raw Fork/Exec Driver can run scripts.
* But it is somewhat dangerous.

---
name: Isolated Fork/Exec Driver
class: compact, col-2
# Isolated Fork/Exec Driver
.smaller[
- [Isolated Fork / Exec Driver](https://www.nomadproject.io/docs/drivers/exec.html) (`exec`)는 특정 명령을 실행하는 데 사용됩니다.
- 그러나`raw_exec` 드라이버와 달리`exec` 드라이버는 운영 체제의 기본 격리 프리미티브를 사용하여 리소스에 대한 작업의 액세스를 제한합니다.
- 이것은`raw_exec` 드라이버보다 **훨씬 더 안전**합니다.
- 더 높은 수준의 기능을 제공하는 스크립트 또는 기타 래퍼를 호출하는 데 사용할 수 있습니다.

]
<br>

```hcl
task "example" {
  driver = "exec"
  config {
    command = "/bin/sleep"
    args    = ["1"]
  }
}
```

???
* The Isolated Fork/Exec Driver also runs scripts.
* But it is much safer.

---
name: Java Driver
class: compact, col-2
# Java Driver
.smaller[
- [Java Driver](https://www.nomadproject.io/docs/drivers/java.html) (`java`)는 Java 애플리케이션 패키지 Java Jar 파일을 실행하는 데 사용됩니다.
- [artifact downloader](https://www.nomadproject.io/docs/job-specification/artifact.html)를 통해 Nomad 클라이언트에서 Jar 파일에 액세스 할 수 있어야합니다.
- 드라이버가 실행하는 자바 애플리케이션은`args`,`class`,`class_path`,`jar_path`,`jvm_options` 설정으로 구성 할 수 있습니다.

]
<br>
<br>
<br>

```hcl

task "web" {
  driver = "java"
  config {
    jar_path    = "local/hello.jar"
    jvm_options = ["-Xmx2048m", "-Xms256m"]
  }
  artifact {
    source = "https://FQDN/hello.jar"
  }
}
```

???
* The Java Driver lets you launch Java applications from Jar files.
* You can even download them with the Nomad's artifact downloader.

---
name: Qemu Driver
class: compact, col-2
# Qemu Driver
.smaller[
* [Qemu Driver](https://www.nomadproject.io/docs/drivers/qemu.html) (`qemu`)는 QEMU 용 일반 가상 머신 실행기를 제공합니다.
* 호스트 머신에서 게스트 가상 머신으로 포트 세트를 매핑하고 리소스 할당을위한 구성을 제공 할 수 있습니다.
* qemu 드라이버는 일반 QEMU 이미지 (예 : qcow, img, iso)를 실행할 수 있으며 qemu-system-x86_64로 호출됩니다.
* 드라이버는 아티팩트 다운로더를 통해 Nomad 클라이언트에서 이미지에 액세스 할 수 있어야합니다.

]

<br>

```hcl

task "virtual" {
  driver = "qemu"
  config {
    image_path  = "local/linux.img"
    accelerator = "kvm"
    graceful_shutdown = true
    args        = ["-nodefaults"]
  }
  artifact {
    source = "https://FQDN/linux.img"
  }
}
```

???
* wait, so you are telling me that Nomad can just run vm images all willy nilly?

---
name: Specifying Required Resources
class: compact, col-2
# 필요 리소스 지정
- [resources stanza](https://www.nomadproject.io/docs/job-specification/resources.html)는 작업에 필요한 리소스를 설명합니다.
  - 리소스 요구 사항에는 메모리, CPU, 장치등이 포함됩니다.
  - 작업은 리소스 요구 사항을 충족하는 클라이언트 노드에만 예약됩니다.

<br>
```hcl

job "example" {
  group "cache"
  {
    task "redis" {
*     resources {
*       cpu    = 500
*       memory = 256
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
# 특정 네트워크 지정
- [network stanza](https://www.nomadproject.io/docs/job-specification/network.html)는 작업 그룹의 모든 작업에 대한 네트워킹 요구 사항을 지정합니다.
  - 대역폭
  - 포트 할당

<br>
<br>

```hcl

job "example" {
  datacenters = ["dc1"]
  group "cache" {
*   network {
*     mbits = 100
*     port  "db"  {}
* }
```

???
* networking settings

---
class: compact, col-2
name: Specifying Port Mapping
# 포트 맵핑
.smaller[
- Nomad는 [Dynamic Ports](https://www.nomadproject.io/docs/job-specification/network.html#dynamic-ports), [Static Ports](https://www.nomadproject.io/docs/ job-specification / network.html # static-ports), [Mapped Ports](https://www.nomadproject.io/docs/job-specification/network.html#mapped-ports) 를 지원합니다.
  - 이 예에서 Redis는 Docker 컨테이너 내부의 포트 6379에서 수신 대기합니다.
  - Nomad는 동적으로 포트를 선택하고 컨테이너 내부의 포트 6379로 전송 된 요청을 매핑합니다.

]

<br>
<br>
<br>

```hcl

job "example" {
  datacenters = ["dc1"]
  group "cache" {
*   network {
*     port "db" {}
*   }
    task "redis" {
      driver = "docker"
      config {
*       port_map = {
*         db = 6379
*       }
      }
    }
```

???
* port mapping

---
name: Specifying Bridged Networks
class: compact, col-2
# 브릿지 네트워크 설정
.smaller[
-  이 예는 [bridge](https://www.nomadproject.io/docs/job-specification/network.html#bridge-mode) 네트워크 모드를 보여줍니다.
- 'bridge' 네트워크 네임 스페이스 내에서 실행되는 작업은 동일한 호스트의 네임 스페이스 외부에있는 애플리케이션에 표시되지 않습니다.
-  ]

<br>
<br>
<br>
<br>
<br>

```hcl

job "example" {
  datacenters = ["dc1"]
  group "cache" {
*   network {
*     mode = "bridge"
*     port "http" {
*       static = 9002
*       to     = 9002
*     }
*   }
    task "redis" {
      driver = "docker"
    }
  }
```

???
* good time to throw in consul ;)

---
name: Registering Tasks as Consul Services
class: compact, col-2
# Task를 Consul의 서비스에 등록
.smaller[
- [service stanza] (https://www.nomadproject.io/docs/job-specification/service.html)는 서비스 검색을 위해 서비스를 Consul에 등록하도록 Nomad에 지시합니다.
- 태그, 상태 확인, 포트 및 기타 여러 [매개 변수](https://www.nomadproject.io/docs/job-specification/service.html#service-parameters)를 정의 할 수 있습니다.

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
name: nomad-4-Summary
# 📝 Chapter 4 Summary

* 이 장에서는 다음에 대해 더 알아보았습니다. :
  1. Nomad Jobs and Schedulers
  1. Jobs과 대상이 되는  Datacenters 선언
  1. Task Groups, Tasks, Task Drivers 선언
  1. 사용 가능한 Task Driver
  1. 필요한 리소스와 네트워크 지정
  1. Consul 서비스에 등록하는 설정

???
* What we learned in this chapter
