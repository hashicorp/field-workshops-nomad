name: nomad-chapter-7-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 7
## Job 모니터링

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss how to monitor Nomad jobs including their allocations, evaluations, task groups, and tasks.

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-7-topics
# Chapter 7 Topics

* Nomad CLI를 사용하여 다음을 수행합니다.
  * Job, Allocation, Evaluation 확인
  * Allocation 로그 보기
* Nomad UI를 사용하여 동일하게 수행
* Hands on Lab : Nomad Monitoring

???
* In this chapter, we'll discuss how to monitor Nomad jobs including their allocations, evaluations, task groups, and tasks.
* The hands-on lab will show how Nomad telemetry can be sent to tools like Prometheus.
---
name: inspect-job
class: compact, smaller
# Job 확인하기

Nomad CLI로 Job 상태를 확인하려면 다음을 실행하십시오.<br>
`nomad job status <job_id>`<br>

```output
*nomad job status redis
 ID            = redis
 Name          = redis
 Type          = service
 Status        = running
 ...
Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created  Modified
*081459da  234c769f  cache       0        run      running  2m ago   2m ago
```
여기의 출력은 축약되어 있지만 실행중인 할당의 ID를 표시하며이를 검사 할 수 있습니다.
???

* This is the command to inspect the status of a job.

---
name: inspect-allocation
class: compact, smaller
# Allocation 확인하기
Nomad CLI로 Allocation(할당)을 확인하려면 다음을 실행하십시오.<br>
`nomad alloc status <allocation_id>` <br>

```output
*nomad alloc status 081459da
*ID                  = 081459da
Eval ID             = 13ebb66d
Name                = redis.cache[0]
*Node ID             = 234c769f
*Node Name           = nomad-client-1
Job ID              = redis
```
Job 상태 명령의 출력에서 *Allocation ID*를 사용했으며 Allocation이 실행중인 노드를 확인할 수 있습니다. <br>
또한 Allocation을 예약 한 Evaluation의 ID도 볼 수 있습니다.

???
* This is the command to inspect the status of an allocation.

---
name: inspect-allocation
class: compact, smaller
# Evaluation 확인
Nomad CLI로 평가를 확인하려면 다음을 실행하십시오. <br>
`nomad eval status <evaluation_id>` <br>

```output
*nomad eval status 13ebb66d
ID                 = 13ebb66d
Create Time        = 1m27s ago
Status             = complete
Type               = service
Job ID             = redis
Priority           = 50
*Placement Failures = false
```
Allocation 상태 명령의 출력에서 *Eval ID*를 사용했습니다. <br>
또한 배치 실패가 없었는지 확인할 수 있습니다.

???
* This is the command to inspect the status of an allocation.

---
name: show-task-logs
class: compact, smaller
# View Task Logs
Nomad CLI를 사용하여 Task에 대한 로그를 보려면 다음을 실행하십시오. <br>
`nomad alloc logs <allocation_id> <task>` <br>

```output
*nomad alloc logs 081459da redis
1:C 10 Jan 16:05:30.456 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 3.2.12 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1
```
작업 상태 명령의 출력에서 *Allocation ID*를 다시 사용했습니다.

???
* This is the command to view logs for a task.

---
name: monitor-with-ui
# Nomad UI로 Nomad 모니터링
* 다음 슬라이드는 Nomad UI를 사용하여 모니터링하는 방법을 보여줍니다.
  * Jobs
  * Allocations
  * Task Groups
  * Tasks (including their logs)

???
* The Nomad UI can also be used to monitor Nomad

---
name: nomad-ui-job-high-level
# List of Nomad Jobs
.center[![:scale 100%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-Job_Status-Highlevel.png)]

???
* This is a screenshot showing the list of jobs in the Nomad UI.

---
name: nomad-ui-job-with-deployments
# Nomad Job with Deployments
.center[![:scale 70%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-Job-with-Deployments.png)]

???
* This is a screenshot showing a job and its deployments in the Nomad UI.

---
name: nomad-ui-job-with-task-groups-and-allocations
# Nomad Job with Task Groups and Allocations
.center[![:scale 80%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-Job-with-task-groups-allocations.png)]

???
* This is a screenshot showing task groups and allocations for a job in the Nomad UI.

---
name: nomad-ui-task-group
# Nomad Task Group
.center[![:scale 70%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-task-group.png)]

???
* This is a screenshot showing a task group of a job in the Nomad UI.

---
name: nomad-ui-task-group-status-and-task
# Nomad Task Group Status and Task
.center[![:scale 70%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-task-group-status-and-task.png)]

???
* This is a screenshot showing the status of a task group and its tasks in the Nomad UI.

---
name: nomad-ui-task
# Nomad Task
.center[![:scale 68%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-task.png)]

???
* This is a screenshot showing the status of a task in the Nomad UI.

---
name: nomad-ui-task-logs
# Nomad Task Logs
.center[![:scale 80%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-task-logs.png)]

???
* This is a screenshot showing the logs of a task in the Nomad UI.

---
name: monitoring-nomad-with-prometheus
# Monitoring Nomad With Prometheus
* Nomad 클라이언트 및 서버 에이전트는 런타임 [telemetry](https://www.nomadproject.io/docs/telemetry/index.html)을 수집합니다.
* 운영자는이 데이터를 사용하여 Nomad 클러스터에 대한 실시간 가시성을 확보하고 성능을 향상시킬 수 있습니다.
* 메트릭은 Prometheus, Grafana, Graphite, DataDog 및 Circonus와 같은 도구로 내보낼 수 있습니다.

???
* Nomad collects telemetry that can be sent to external tools like Prometheus.

---
name: monitoring-nomad-with-prometheus-lab
class: compact
# 👩‍💻 Monitoring Nomad With Prometheus Lab
* 이 트랙은 [Using Prometheus to Monitor Nomad Metrics](https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html) 가이드를 구현하는 과정을 안내합니다.
* 실습에서는 Nomad로 다음을 수행합니다.
   * [Fabio](https://fabiolb.net) 및 [Prometheus](https://prometheus.io/docs/introduction/overview)를 Nomad 클러스터에 배포
   * 클러스터에 Prometheus [Alertmanager](https://prometheus.io/docs/alerting/alertmanager) 배포
   * Nomad 클러스터에 웹 서버를 배포하고 중지 한 다음 Prometheus 및 Alertmanager에서 생성 된 경고를 확인
* 이 모든 작업은 **Nomad Monitoring** Instruqt 트랙에서 수행됩니다.

???
* Now, you can explore collecting metrics from Nomad into Prometheus hands-on.
---
name: chapter-7-summary
# 📝 Chapter 7 Summary
이 장에서는 다음에 대해 배웠습니다.

* Nomad CLI를 사용하여 다음을 수행합니다.
   * Job, Allocation, Evaluation 확인
   * Allocation 로그 보기
* Nomad UI를 사용하여 동일하게 수행

Instruqt 랩에 대한 경험도 있습니다.

???
* Summary of what you did in this chapter.
