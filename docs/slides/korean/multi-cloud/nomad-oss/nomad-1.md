name: nomad-overview
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 1
## Nomad Overview

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll provide an overview of Nomad
* The current release is 0.12.x

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-1-topics
# Chapter 1 Topics

1. HashiStack에서의 Nomad 포지션
1. Nomad의 비즈니스적 가치
1. Nomad란 무엇일까요?
1. Nomad 사용 사례
1. Nomad Autoscaling
1. Nomad Federation
1. Nomad OSS 기능
1. Nomad Enterprise 기능
1. Nomad Enterprise 모듈


???
* Topics discussed in Chapter 1

---
name: chapter-1-nomad-place-in-hashistack
# HashiStack에서의 Nomad 포지션
.center[![:scale 80%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad_HashiStack_Velocity.png)]

???

* Organizations can use Nomad to run their containerized workloads across any cloud or on premise.

---
name: chapter-1-shift-to-containers
# Container 런타임 환경으로의 이동
.center[![:scale 70%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad_Business_Value.png)]

???
*  Lowers total cost of ownership (TCO) via bin packing
*  Runs both containerized and legacy apps (e.g. Java classes and jars)
*  Easy to operate and maintain

???
* Companies are embracing containers, but still need to run legacy applications.
* Nomad supports both.

---
name: chapter-1-nomad-business-value
# Nomad의 비즈니스적 가치
* 하드웨어 활용율 향상
  * Bin-packing을 통해 실행되는 애플리케이션 밀도를 높임
* 운영 오버헤드 감소
   * 개발자가 운영자의 지원을 거의, 또는 전혀 받지 않고도 애플리케이션을 실행할 수 있는 플랫폼 환경을 구성
* Accelerate Time To Market.
  * 동일한 인프라에서 동일한 워크 플로우로 컨테이너와 레거시 애플리케이션을 함께 실행

???
*  Let's discuss the business benefits of Nomad.

---
name:  chapter1-what-is-nomad
# Nomad란 무엇일까요?
* 유연하고 가볍운 고성능의 사용하기 쉬운 오케스트레이터
* 컨테이너와 레거시 애플리케이션을 동시에 배포하고 관리하는 데 사용
* 데이터 센터 및 클라우드 플랫폼에서 작동하고 범용 스케줄링 제공
* 서비스, 배치 기능과 글로벌 시스템 서비스 형태의 배포 관리

???
* Nomad runs as a single binary in just about any environment * one of the easiest and lightweight service scheduler and manager available.
*  Used to deploy both container applications, as well as legacy applications such as Java or raw executables.
*  As an independent function, Nomad can run and communicate across data centers, and cloud platforms.  Truly cloud agnostic.
*  Can manage individual services, batch functions, or even global system services such as monitoring functions.

---
name: chapter-1-nomad-use-cases
# Nomad 사용 사례
.center[![:scale 70%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad_Use_Cases.png)]

???
* Container Workloads
* Legacy Applications
* Batch Jobs like Machine Learning

---
name: chapter-1-nomad-workload-types
# Run All Types of Workloads
.center[![:scale 100%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-Workload-Types.png)]

???
* Nomad can run these 3 types of workloads

---
name: chapter-1-nomad-autoscaling
class: compact
# Nomad Autoscaling
* 다음 두가지 형태의 Autoscaling을 지원 합니다. :
  * **Horizontal Application Autoscaling** 을 사용하여 동작하는 작업(배포) 그룹의 수를 동적으로 확장하고 축소합니다.
  * **Horizontal Cluster Autoscaling** 을 사용하여 Nomad 클러스터의 크기를 동적으로 확장하고 축소합니다.
      * AWS, Azure, GCP에 공식 플러그인이 제공됩니다.
      * Digital Ocean, Openstack Senlin, Hetzner Cloud에 커뮤니티 플러그인이 제공됩니다.
* 두 유형 모두 APM 측정 항목에 의해 구동 됩니다.
* Nomad Autoscaler 에이전트는 Nomad에 Job 으로 배포됩니다.

???
* Nomad supports two types of autoscaling:
  * Horizontal application autoscaling
  * Horizontal cluster autoscaling
* The latter is currently only supported in AWS.
* Both types of autoscaling are driven by APM metrics.
* The Nomad Autoscaler agent can be deployed as a Nomad job.

---
name: chapter-1-nomad-federation
# Federation Made Real
.center[![:scale 100%](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss/images/Nomad-Federation.png)]

???
* Nomad can deploy applications seamlessly to federated clusters across multiple clouds.
* It is the first and only orchestrator on the market with complete and fully-supported federation capabilities for production.
---
name: chapter-1-nomad-oss-features
class: smaller
# Nomad OSS 기능
* Namespaces
* Service/Batch Schedulers
* Flexible Task Drivers
* Device Plugins
* Multi-Update Strategies
* Multi-Region Federation
* Autoscaling
* Container Storage Interface Plugins
* Container Network Interface Plugins
* Access Control System
* Web UI
* Consul & Vault Integration

???
* Service and Batch Schedulers enable both short and long-lived workloads
* Task drivers like docker, podman, java, exec
* Device Plugins allow community members to extend Nomad functionality to other drivers and devices including NVIDIA GPUs for compute-intensive workloads
* Enables various update strategies such as rolling, blue-green and canary
* Nomad Clusters can be federated across multiple cloud regions and on-prem datacenters
* Autoscaling supports horizontal scaling of both applications (changing task group count) and of clusters (changing # of Nomad clients)
* Supports CSI and CNI plugins for maximum flexibility of storage and networking.
* ACLs to control access to data and APIs
* Web UI included out-of-the-box
* Native integration with other HashiCorp products Consul and Vault
*

---
name: chapter-1-nomad-enterprise-platform-features
# Nomad Enterprise 기능
* All Open Source Features
* Automated Upgrades with Autopilot
* Automated Backups with Snapshot Agent
* Enhanced Read Scalability
* Redundancy Zones (Non-voting)
* Multiple Vault Namespaces

???
* All Open Source Features are included in Enterprise
* Autopilot Upgrades
* Automated backups with Nomad's Snapshot agent
* Servers can act as a non-voting member of the cluster to help provide read scalability
* Nomad attempts to parition servers according to specified redundancy zone, and will aim to keep one voting server per zone
* A single Nomad cluster can access multiple namespaces of a Vault cluster.

---
name: chapter-1-nomad-enterprise-modules
class: compact
# Nomad Enterprise 모듈 (기본+)
* Nomad Enterprise Governance & Policy Module
  * Resource Quotas
  * Sentinel Policies
  * Cross-Namespace Queries
  * Audit Logging
* Nomad Multi-Cluster & Efficiency Module
  * Multi-Region Job Deployments
  * Dynamic Application Sizing

???
* A shared cluster can be partitioned into multiple namespaces which allow jobs and their associated objects to be isolated from each other and other users of the cluster
* Resource quotas limit resource consumption across teams or projects to reduce waste and align budgets
* Sentinel defines policies such as disallowing jobs to be submitted to production on Fridays or only allowing users to run jobs that use pre-authorized Docker images
* Cross-Namespace Queries allow the Nomad HTTP API and CLI to retrieve data from multiple namespaces.
* Audit Logging allows enterprises to proactively identify access anomalies.
* Multi-region Deployments can deploy allocations across multiple Nomad clusters/regions and roll back if deployments fail in remote clusters.
