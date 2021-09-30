name: nomad-chapter-5-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 5
## Nomad 클러스터와 Job 실행

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss how to run Nomad servers, clusters, and jobs

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-5-topics
# Chapter 5 Topics

1. Nomad 서버 구성 및 실행
2. Nomad 클라이언트 구성 및 실행
3. 클러스터링 서버 및 클라이언트
4. Nomad Job 실행
5. Nomad 클러스터 및 Job 모니터링
6. Nomad Job 수정

???
* In this chapter, we will discuss configuring and running Nomad servers, clients, and jobs.
* We'll also learn about different ways of joining servers and clients in clusters and how to modify jobs.

---
name: chapter-5-summary
# 우리는 무엇을 향해 가고있나요?

* 이미 2 장에서 Nomad 서버, 클라이언트, 클러스터 및 작업에 대해 배웠습니다.
* 우리는 이미 "Nomad Basics"랩에서 Nomad Dev Agent와 간단한 작업을 실행했습니다.
* 해당 에이전트를 구성 할 필요는 없습니다.
* 이 장에서는 Nomad 서버와 클라이언트를 구성하고 실행하는 방법과 클러스터에서 연결하는 방법을 배웁니다.
* 또한 Nomad Job을 수정하고 다시 실행하는 방법도 알아 봅니다.

???
* We've learned a little about Nomad servers, clients, clusters, and jobs.
* But there is more.
* In particular, we want to learn how to configure Nomad servers and clients and cluster them.
* We also want to learn how to modify and re-run jobs.

---
name: nomad-server-review
class: smaller
# Nomad Clusters, Servers, Clients 리뷰
* Nomad는 인프라를 **Region** 내 **Datacenter**로 구성합니다.
* 각 Nomad Region은 여러 Datacenter가 있더라도 항상 단일 Nomad **Cluster**를 실행합니다.
* Nomad **Server**는 Nomad 클러스터의 두뇌입니다.
* 그들은 지역의 모든 작업과 클라이언트를 관리하고, 평가를 실행하고, 작업 할당을 만들고, 이러한 할당을 작업 그룹과 함께 클라이언트에 할당하고, 서로간에 상태를 복제합니다.
   * Nomad 서버는 구성 파일에서`server.enabled`가`true`로 설정된 Nomad 에이전트를 실행하거나`-server` CLI 인수로 시작됩니다.
* Nomad **Client**는 서버에서 할당 한 Nomad 작업의 작업 그룹 및 작업을 실행합니다.
   * Nomad 클라이언트는 구성 파일에서`client.enabled`가`true`로 설정된 Nomad 에이전트를 실행하거나`-client` CLI 인수로 시작됩니다.

???
* Let's review what Nomad clusters, servers, and clients are and how they differ.
* First, we need to understand that servers and clients are organized into datacenters and regions with one cluster per region.
* Whether a Nomad agent (and the machine) it runs on is a Nomad server or client depends on how it is configured or on the CLI arguments used to start it.

---
name: nomad-server-configuration
class: smaller
# Nomad Server 구성
다음은 일반적인 Nomad 서버 구성입니다.:

```hcl
server {
  enabled = true
  bootstrap_expect = 3
  server_join {
    retry_join = ["nomad-server-1"]
  }
}
```

`enabled = true` : 에이전트가 서버로 실행되어야 함을 지정합니다.<br>
`bootstrap_expect = 3` : 리더 선택 전에 대기 할 서버 노드 수를 지정합니다.
`retry_join`  : 연결할 다른 서버를 나타냅니다.

???
* This slide shows the key portion of a Nomad HCL configuration file that makes an agent run as a server.
* It also shows the important `bootstrap_expect` setting that determines how many servers should the cluster should run before any server tries to become a leader.
* It also shows the `retry_join` setting that tells the server what other server or servers to cluster with.

---
name: nomad-client-config
class: smaller
# Nomad Client 구성
다음은 일반적인 Nomad 클라이언트 구성입니다.:

```hcl
client {
  enabled = true
  servers = ["nomad-server-1"]
}
```

`enabled` : 에이전트가 클라이언트로 실행되어야 함을 지정합니다.<br>
`servers` 연결할 서버를 나타냅니다.

???
* This slide shows the key portion of a Nomad HCL configuration file that makes an agent run as a client.
* It also shows the `servers` setting that tells the client what server or servers to connect to.

---
name: job-specification
class: compact, smaller
# Job Specification

* **Job Specification**은 작업이 실행되어야하는 워크로드를 정의하는 HCL 유형의 파일에 의해 제공됩니다.
* 해당 사양에 대해서는 5 장에서 자세히 알아볼 것입니다.
* 다음은 이 장의 실습에서 만들 정의의 일부입니다.

```hcl
job "redis" {
  group "cache" {
    task "redis" {
      driver = "docker"
      config {
        image = "redis:3.2"
      }
    }
  }
}
```
???
* This slide shows part of the job specification you will create in this chapter's lab.
* We see that it will run a Redis Docker container.

---
name: lab-nomad-simple-cluster-track
# 👩‍💻 Lab 5: Nomad Simple Cluster
* 이제 첫 번째 Nomad 클러스터를 구성하고 실행할 수 있습니다.
* **Nomad Simple Cluster** Instruqt 트랙에서 서버 1 개와 클라이언트 2 개로 구성된 간단한 Nomad 클러스터를 실행합니다.
* 첫 번째 도전에서는 클러스터를 구성하고 실행합니다.
* 추가 챌린지에서는 클러스터에서 간단한 작업을 생성, 실행, 중지, 수정 한 다음 다시 실행합니다.
* 트랙의 "Run the Nomad Server and 2 Clients"챌린지를 클릭하여 "Nomad Simple Cluster"트랙을 시작합니다.

???
* Now, you'll do the second lab of the workshop in which you'll run a simple Nomad cluster with 1 server and 2 clients.
* You'll also create, run, stop, modify, and then re-run a simple job in the cluster.
* We'll be running the Instruqt track "Nomad Simple Cluster"

---
name: client-server-architecture
# Lab Topology
.center[![:scale 55%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad_Simple_Cluster_Topology.png)]

???
* This slide shows the lab topology

---
name: nomad-commands-used-in-lab-1
class: smaller
# Nomad Commands Used in the Lab (1)
* Nomad 에이전트를 서버 또는 클라이언트로 실행합니다.
  * `nomad agent -config <config_file>`
* 클러스터의 서버를 확인합니다.
  * `nomad server members`
* 클러스터의 클라이언트를 확인합니다.
  * `nomad node status`
* 새 샘플 Nomad 작업을 초기화합니다.
  * `nomad job init -short`
* Nomad Job Plan (드라이런 수행) :
  * `nomad job plan <jobspec>`
* Nomad job 실행:
  * `nomad job run <jobspec>`

???
* This slide shows some of the Nomad commands you will use in the lab.

---
name: nomad-commands-used-in-lab-2
class: smaller
# Nomad Commands Used in the Lab (2)
* 특정 Nomad 작업의 상태를 가져옵니다.
  * `nomad job status <ID>`
* Nomad 평가 상태를 가져옵니다.
  * `nomad eval status <EvaluationID>`
* Nomad 할당 상태를 가져옵니다.
  * `nomad alloc status <AllocationID>`
* Nomad 할당에서 작업 로그를 가져옵니다.
  * `nomad alloc logs <AllocationID> <task>`
* Nomad 작업 중지:
  * `nomad job stop <ID>`

???
* This slide shows more Nomad commands you will use in the lab.
---
name: lab-challenge-5.1
# 👩‍💻 Lab Challenge 5.1: Run the Server and Clients
* 이 과제에서는 서버와 클라이언트를 구성하고 실행합니다.
* 지침 :
   * 첫 번째 과제가 로드되는 동안 두 화면의 메모를 읽으십시오.
   * 도전을 시작하려면 녹색 "Start"버튼을 클릭하십시오.
   * 도전의 오른쪽에있는 지침을 따르십시오.
   * 모든 단계를 완료 한 후 녹색 "Check"버튼을 클릭하여 모든 작업을 올바르게 수행했는지 확인하십시오.
   * 또한 "Check"버튼을 클릭하여 미리 알림을받을 수도 있습니다.

???
* Give the students some instructions for starting the track's first challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminders of what they should do next.

---
name: lab-challenge-5.2
# 👩‍💻 Lab Challenge 5.2: Create a Nomad Job

* 이 과제에서는`nomad job init` 명령을 사용하여 첫 번째 Nomad Job을 생성합니다 (작업을 더 간단하게 유지하기 위해`-short` 옵션 사용).
* 또한 Job 구성을 검사 할 수 있습니다.
* 지침 :
   * "Nomad Simple Cluster"트랙의 "Create Your First Nomad Job"도전을 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 도전의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* Give the students some instructions for starting the track's second challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminders of what they should do next.

---
name: lab-challenge-5.3
# 👩‍💻 Lab Challenge 5.3: Run Your First Nomad Job

* 이 과제에서는 첫 번째 Nomad 작업을 실행하고 모니터링합니다.
* Job의 상태, 평가, 단일 할당을 확인할 수 있으며 실행중인`redis` 작업에 대한 로그도 볼 수 있습니다.
* 지침 :
   * "Nomad Simple Cluster"트랙의 "Run and Monitor Your First Nomad Job"챌린지를 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 도전의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* Give the students some instructions for starting the track's third challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminders of what they should do next.

---
name: lab-challenge-5.4
# 👩‍💻 Lab Challenge 5.4: Modify a Job to Scale

* 이 과제에서는 더 많은로드를 처리 할 수 있도록 3 개의 인스턴스를 실행하도록`redis` 작업을 수정합니다.
* Job을 다시 실행하고 2 개의 새 할당이 할당되었는지 확인합니다.
* 지침 :
   * "Nomad Simple Cluster"트랙의 "Modify a Job to Run More Instances"챌린지를 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 도전의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* Give the students some instructions for starting the track's fourth and final challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminders of what they should do next.

---
name: nomad-5-Summary
# 📝 Chapter 5 Summary
* 이번 장에서는 다음을 확인하였습니다. :
  - 샘플 Job 생성
  - Job 실행
  - jobs, evaluations, allocations 모니터링
  - Task logs 확인
  - Job의 수정과 재시작
  - Job 정지

???

* What we learned in this chapter
