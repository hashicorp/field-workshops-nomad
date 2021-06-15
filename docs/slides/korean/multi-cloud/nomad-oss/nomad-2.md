name: nomad-chapter-2-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 2
## Nomad 컨셉과 구조

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
Nomad is a highly advanced service scheduler and manager.  Within this slide deck, we'll be reviewing some of the more advanced concepts and architecture behind Nomad.

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-2-topics
# Chapter 2 Topics

1. Nomad의 주요 컨셉
2. Nomad 아키텍처
3. Nomad 스케쥴링
4. Nomad 통합(Integration)

???
* This is our chapter topics slide.

---
name:  What Is Nomad
# Nomad
.smaller[
* 유연하고 가볍고 고성능이며 사용하기 쉬운 오케스트레이터
* 컨테이너와 레거시 애플리케이션을 동시에 배포하고 관리
* 데이터 센터 및 클라우드 플랫폼에서 작동하고 범용 스케줄링 제공
* 서비스, 배치 스케줄링과 시스템 서비스 관리
]

???
- Runs as a single binary in just about any environment - one of the easiest and lightweight service scheduler and manager available.
-  Used to deploy both container applications, as well as legacy applications such as Java or raw executables.
-  As an independent function, Nomad can run and communicate across data centers, and cloud platforms.  Truly cloud agnostic.
-  Can manage individual services, batch functions, or even global system services such as monitoring functions.

---
name:  Common Nomad Concepts
# Nomad Concepts (1)

.smaller[
* **Clusters** : 단일 Region에서 Nomad 바이너리로 서버와 클라이언트로 구성
* **Servers** : 클러스터 내에 스케줄링과 작업 할당 같은 지능적 역할 수행
* **Clients** : 서버에 등록된 예약 작업을 실행
* **Jobs** : 사용자가 서버에 제출한 워크로드의 원하는 상태를 정의
* **Drivers** : Docker, Exec, Java 같은 작업의 정의를 실행하는데 사용
* **Tasks** : Driver가 실행하는 가장 작은 단위
* **Task Groups** : 함께 실행하는 작업 그룹으로 하나의 클라이언트 내에서 실행되는 단위
]

???
-  Cluster contains anywhere from 3-5 server nodes, and an unconstrained number of client nodes.
-  All nodes run the same Nomad binary.
-  Nomad server nodes provide the brains and intelligence to the cluster, performing all scheduling and allocations
-  Clients execute the tasks as directed by the server cluster.
-  Jobs are used to describe the desired state of the workloads.
-  Drivers for docker containers, java apps, and arbitrary executables execute the defined tasks
-  Task Groups are groups of tasks that must be run together, often colocated on the same client -  may be required for various architectural reasons.

---
name:  More Nomad Concepts
# Nomad Concepts (2)

.smaller[
* **Allocations** : Job에 정의된 task와 group을 클라이언트에 맵핑
* **Evaluations** : Job과 Client의 상태가 변경될 때마다 상태를 평가하여 Allocation(할당)을 조정해야하는지 판단
* **Bin Packing** : 리소스 효율적인 알고리즘으로 사용율을 극대화
* **Datacenters** : 일반적으로 클라우드 서비스 제공사가 가용영역(AZ)로 정의하는 물리적 또는 논리적 컴퓨팅 리소스 그룹
* **Regions** : 여러 Datacenter로 구성될 수 있고, 하나의 Nomad 클라스터를 포함하는 Nomad의 논리적인 구조
* **Federated** : 여러 Region을 연동
]

???
-  Allocations map tasks, task groups, and jobs to various client resources.
-  Allocations are adjusted based on Nomad Evaluations that are performed whenever balance within the system is disrupted, either through adjustments to the job, and/or changes to the client availability.
-  Nomad uses a highly efficient bin packing algorithm to ensure that resource utilization is maximized across the client cluster.
-  A cluster can reside within a traditional datacenter, or across multiple data centers defined as a Nomad region.
- Regions can be federated together enabling wider communication without replicating data across all regions.

---
name:  Deployment Architecture
# 일반적인 구성 아키텍처

.smaller[
* Nomad 바이너리는 서버와 클라이언트 기능을 모두 포함
* 각 Nomad 클러스터는 3~5개의 서버로 구성
* 서버는 우선순위(priorities), 평가(evalutions), 할당(Allocations)를 관리하기 위한 'Leader'를 선출
* 클러스터는 물리적 데이터센터를 넘어 구성 가능
]
.center[![:scale 80%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/NomadRegion.png)]

???
-  Nomad utilizes a single binary application that can be run as a client or server.
-  A server cluster should utilize 3-5 server nodes.
-  Servers communicate via the Gossip protocol, and use Consensus protocol to elect a leader
-  A single cluster of servers operate in a single region, which may consist of one or more data centers.

---
class: img-right
name:  Nomad Cluster Leader Election and Viability
# 클러스터내의 "Leader" 선출

![ServerElection](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/ServerElection.png)

.smaller[
* 서버는 서로가 후보로서 경쟁
    * 서버 2가 먼저 자신을 알리고 투표 요청함
* 서버 1이 서버 2를 먼저 선출
    * 서버 2에 투표
* 서버 3은 투표에서 지고 "Follower"로 변경되며, 서버 2가 "Leader"로 선출
]

.smaller.center[3 Servers can sustain 1 Failure, 5 servers can sustain 2 failures]


???
-  When servers initialize, they need to find eachother and create a leader.
-  A server will promote itself as a candidate to be a leader, and notify the other servers in the cluster.
-  Once the candidate has a quorum of votes, it will promote itself as the leader.
-  With 3 server nodes, the cluster can sustain a single failure.  With 5 server nodes, the cluster can sustain two failures.
-  Note that as you increase server members, it will take longer for the consensus protocol to converge and elect a leader.

---
name:  Multi-region Federation
# Region 간 운영

.smaller[
* 여러개의 Nomad Region(Cluster)를 하나로 연합 가능
* Job은 특정 Region에서 제출되고 대상은 여러 Region일 수 있음
* ACL 토큰, Policy, Sentinel은 Region간 공유 가능
* 애플리케이션/상태에 대한 데이터는 공유되지 않음

]

.center[![:scale 80%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Multi-Region.png)]

???
- Clusters can federate across regions using WAN Gossip
- Only ACL, Policies, and Sentinel Policies are shared across regions (no application data).

---
name:  Multi-region Federation
# Region 서버 장애 시

.smaller[
* 특정 Region의 서버에 문제가 생기면 클라이언트가 연합된 타 Region에 접근 가능
* 클라이언트에서 서버에 접속이 가능해야 함
* 다중 Region에 대한 RPC, Serf 통신 필요

]

.center[![:scale 80%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Failed-Region.png)]

???
-  한 지역의 서버 클러스터가 완전히 다운되면 다른 지역의 서버 클러스터 관리를 용이하게 할 수 있습니다.
-  이 다중 지역 연합에는 지역 간 RPC 및 Serf 지원이 필요합니다..

---
class: img-right
name:  Nomad Layout and Comms
# Nomad Communications
![NomadArchitectureRegion](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/nomad-architecture-region.png)

.smaller[
* 3~5 개의 서버 노드 (홀수, RAFT 기반)
* Leader는 Follower에게 상태를 복제
* Follower는 클라이언트의 데이터와 요청을 Leader에게 전달
* 서버는 클라이언트에 할당된 작업을 전달
* 클라이언트는 RPC를 통해 모든 서버와 통신

]

???
-  Within the Server Cluster, we have a Leader, and we have Followers.
-  Leaders are elected via quorum (which is why it is important to have 3-5 nodes) using Nomad's Consensus prootcol, based on RAFT.
-  Leader of the servers makes all allocation decisions, and distributes to Followers.
-  Server push allocation and task assignments via RPC to each Server.

---
name: Nomad Scheduler Section
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad Scheduler Processes
## Evaluations, Allocations, Priorities, Preemption

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
Focusing more on the Scheduler process

---
class: img-right
name:  Nomad Evaluation
# Nomad 스케줄러 시작 - Evaluations

![NomadEvalAlloc](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad_eval_alloc.png)

Evaluation(평가)는 다음 중 하나라도 발생할 때마다 "시작"됩니다.
.smaller[

* 새로운 Job이 생성
* Job이 업데이트 되거나 수정 됨
* Job 또는 Node가 실패

]

???
-  Evaluations to determine if any work is necessary.
-  Evaluation is initiated by a new job definition, an updated job definition, or some change to the infrastructure.
-  If necessary, a new Allocation maps tasks or task groups within jobs, to the available nodes

---
class: img-right

name:  Nomad Scheduler
# Nomad 스케줄러 시작

![NomadEvaluationKickoff](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad_Evaluation_Kickoff.png)

.smaller[
* Evaluation이 시작되는 방법과 무관하게 평가 요청는 모든 서버 노드로 보내집니다.
* 모든 평가의 결과는 Leader의 "Evaluation Broker"에게 전달됩니다.
* 평가는 Leader가 프로세스를 대기 시킬 때까지 "Pending" 상태로 유지됩니다.

]

???
-  A new job, a modified or updated job, or any change in the system (job or node failure) will cause an evaluation to kick off.
-  Any of the server nodes can receive the evaluation request.
-  Evaluations are forwarded to a dedicated process on the Leader, called the evaluation broker.
-  Evaluation remains in 'pending' state until broker decides upon allocation

---
class: img-right

name:  Nomad Evaluation
# Nomad Evaluation(평가)
![EvaluationQueue](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Evaluation_Queue.png)

.smaller[

- "Evaluation Broker"가 평가 대상을 받으면 우선순위에 따라 변경 사항을 대기열에 넣습니다.

- Follower 서버 노드의 스케줄러는 대기열에서 평가항목을 선택하고 "Plan"을 시작합니다.

- Leader 노드에 상주하는 "Evaluation Broker"는 보류중인 평가 대기열을 관리합니다.
- Job의 정의에 따라 우선 순위가 결정 됩니다.

]

???
-  Here the evaluation Broker, residing on the leader node, manages the queue of pending evaluations.
-  Priority is determined based on Job definition
-  Broker ensures that somebody picks up the evaluation for processing.
-  Once the evaluation is picked up by a Scheduler, the planning begins!

---
name:  Scheduling Workers
# Scheduler Operations

모든 서버는 스케줄링 작업자를 실행합니다.
* 기본적으로 CPU 코드 당 하나의 스케줄러를 항당
* 세가지 기본 스케줄러 사용
    * **Service** : 수명이 긴(웹서버 같은) 서비스에 최적화 된 스케줄러
    * **Batch** : 스케줄러로 배치 작업을 빠르게 배치
    * **System** : 모든 노드에서 작업을 실행할 수 있는 스케줄러

???
-  Each server node runs one scheduler per CPU core.
-  Server chooses the proper scheduler, either for standard services, batch jobs, or system level jobs.

---
name:  Scheduler Function Part 2
# Scheduler Processing
스케줄러가 Job을 수행했다는 가정하에 그 기능을 살펴보겠습니다.
.smaller[

1.  Job을 실행하기 위해 사용 가능한 리소스/노드를 식별
2.  Bin packing을 기반 또는 기존의 task와 Job을 기준으로 노드의 순위를 지정
3.  최상의 노드를 선택하고 Allocation(할당)계획을 생성
4.  Leader에게 할당 계획 제출

]
???

-  Server process has several steps
-  First it identifies the potential nodes, or available resources, that could accept the job.
-  Next take a look at the ideal nodes, based on bin packing and existing tasks.
   -  Bin packing ensures the most efficient usage of the resources.
-  Taking existing tasks into account minimizes co-locating tasks on the same servers.
-  Highest ranking node is chosen, the allocation plan is created, and submitted back to the Leader.

---
class: img-right
name:  Plan Queue Processing
# Plan Queue Processing
![QueueProcessing](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Queue_Processing.png)

다시 Leader로 돌아가서...
.smaller[

5.  제출된 모든 Allocation(할당) Plan을 평가
6.  Plan을 수락, 거부 또는 부분 거부
7.  구성, 일정 변경 또는 종료를 위해 스케줄러에 응답을 반환
8.  스케줄러는 Evaluation(평가)의 상태를 업데이트 하고 Evaluation Broker와 확인
9.  클라이언트는 할당 변경 사항을 선택하고 동작 수행

]

???
-  Leader makes final determination for allocation.
-  All pending plans are prioritized and eliminate any concurrency if it exists.
-  Leader will either accept or reject (or partial reject) the plan.
-  Scheduler can chose to reschedule or terminate the request
-  Scheduler updates the Evaluation Broker with the decision, and clients pick up any changes deemed necessary

---
name:  End to End Flow
#  Flow Recap
![:scale 90%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad_Overall_Flow.png)

---
name:  Job Priority
# Job Priority(우선순위)
* 모든 스케줄러, 플래너, 프로그램 관리자는 까다로운 주제인  '우선순위'를 다룹니다.
* Nomad 또한 Evaluation, Planning 과정에서 우선순위를 처리합니다.
* 모든 작업에는 관련한 우선순위가 있습니다.
* 우선순위의 범위는 1~100 입니다.
* 높은 숫자가 높은 우선순위를 갖습니다.

]

.center[우선 순위가 더 높은 작업이 예약되면 어떻게 동작할까요?]


???
-  Nomad supports priority configuration with every Job, from 1 to 100.
-  The higher the number, the higher the priority.
-  What if a higher priority job is scheduled and resources are limited?

---
name:  Preemption
# Nomad에서의 Preemption(선점)
.center[Preemption(선점)을 통해 우선순위가 높은 작업이 다른 작업을 대체 합니다.]
.smaller[

| Without Preemption            | With Preemption                  |
|-------------------------------|-------------------------------------------------|
|Job과 Task는 순서대로 할당 |자원 가용성에 관계없이 평가 수행 |
|리소스가 가용할 때까지 할당되지 않은 보류 상태                   |필요한 경우 우선순위가 가장 낮은 작업을 제거|
|             |'Plan'의 결과는 모든 사전 선점을 식별|
]

.center[Preemption(선점)은 Namespace로 범위를 구분하지 않습니다.]

???
-  Jobs are evaluated and allocated as they are delivered to the evaluation broker.
-  If resources aren't avialable, any evaluations will be stuck in pending state until resources become available.
-  With preemption, Nomad evicts lowest priority jobs if necessary.
-  Any preemption actions necessary are highlighted as an output of the 'Plan' operation
- Nomad Preemption is not scoped to Nomad namespaces. It operates at the cluster level. A high priority job targeted to one namespace can preempt lower-priority jobs in other namespaces.

---
class: col-2
name:  How Preemption Works
layout: false
# Preemption Details 1

![systemalert](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/SystemAlerting.png)
.center[System Alerting 앱을 추가하고 싶지만 공간이 없습니다.]

![fullcluster](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/FullCluster.png)
.center[Nomad 클러스터는 이미 12GB의 메모리를 모두 사용하고 있습니다.]



???
* Let's run through a quick example of how preemption works.
* Here we have a Nomad cluster with a few allocations in an analytics solution.
* All allocations are all happy, and now we have a new job added to the system for System Alerting.
* We have enough CPU, and plenty of Hard Drive, but we are at the memory limit.
* There's no room at the inn for our System Alerting process.
* Without Preemption, that's where we would stop.
* But we have preemption, so we'll continue

---
class: col-2
name:  How Preemption Works 2
layout: false
# Preemption Details 2

![EvictBusinessAlert](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/EvictBusinessAlert1.png)
.center[Business Reporting 앱 중 하나의 리소스로 대체합니다.]

![AddSystemAlert](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/AddSystemAlert1.png)


???
With Preemption, Nomad realizes that there are lower priority allocations that can be evicted.  So if we are adding one System Alerting job, we evict one Business Reporting Job.  The Business Reporting job has the lowest priority, so it gets evicted first.  But what happens if we have to add two more System Alerting allocations?

---
class: col-2

name:  How Preemption Works 3
# Preemption Details 3

![EvictBusinessAlert](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/EvictBusinessAlert2.png)
.center[더 많은 System Alerting 은 우선순위가 낮은 다른 서비스를 퇴출시킵니다.]
![AddSystemAlert](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/AddSystemAlert2.png)
 .center[Log Collection 서비스는 우선순위의 차이가 10 미만이기에 선점 교체 대상에서 제외됩니다.]

???
* If we add two more Sytem Alerting allocations, we need to bump a Batch Analytics Allocation as well.
* Evicting the Log Collection allocation would be sufficient, but the Batch Analytics Allocation has a lower priority.
* Additionally, as the priority difference between System Alerting and Log Collection is less than 10, the Log Collection allocation isn't a candidate for preemption with respect to System Alerting.
---
name: Nomad within HashiCorp
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad 통합(Integration)
## The HashiCorp Ecosystem

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
Nomad integrates well with other HashiCorp products.  We're just going to touch on the functionality here.

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name:  Nomad and Consul
# Nomad와 Consul의 긴밀한 통합

* Consul은 다음을 제공합니다. :
  * Nomad 서버 및 클라이언트의 자동 클러스터링
  * Job에 대한 서비스 탐색
  * Job에 의해 실행되는 애플리케이션에 대한 동적인 구성
* Consul Connect 는 다음을 제공합니다. :
  * Job과  Task groups으로 배포된 애플리케이션의 보안 통신

???
-  Nomad Servers and Clients can automatically find each other within the network, minimizing configuration and being more address-flexible.
-  Consul enables application service nodes to be automatically discoverable within the cluster
-  Configuration files can be dynamically created utilizing environment variables or even Vault secrets with templating
-  Consul Connect can secure communication between services deployed in public or private clouds.

---
name:  Nomad and Vault
# Nomad와 Vault의 통합

* Nomad가 Vault의 토큰을 생성하고 Job에 배포합니다.
* Vault로 부터 시크릿 데이터(e.g. password)를 검색하고 할당합니다.
* Job은 Vault에서 동적으로 생성되는 단기 자격 증명으로 대상 서비스(e.g. DB)에 접근합니다.
* Task는 Vault의 Nomad Secret Engine을 사용하여 Nomad API 토큰을 확인할 수도 있습니다.
* Nomad Enterprise에서는 Vault의 Namespace와 연계가 가능합니다.

???
-  Nomad's integration with Vault allows Vault tokens to be used by Nomad Tasks
-  Nomad's tasks can retrieve secrets directly from Vault
-  Vault can also provide short-lived credentials to Nomad tasks
-  Vault offers a native Nomad Secrets Engine
-  Nomad Enterprise supports integrating a single Nomad cluster with a Vault cluster that has multiple namespaces.

---
name: chapter-2-summary
# 📝 Chapter 2 Summary
In this chapter, you learned about:
  * Nomad의 주요 컨셉
  * Nomad's Architecture
  * Nomad's Scheduling Processes
  * Nomad 통합(Integration) with Consul and Vault
