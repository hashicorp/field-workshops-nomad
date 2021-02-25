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

1. Nomad's Place in the HashiStack
1. Nomad's Business Value
1. What is Nomad?
1. Nomad Use Cases
1. Nomad Autoscaling
1. Nomad Federation
1. Nomad OSS Features
1. Nomad Enterprise Platform Features
1. Nomad Enterprise Modules


???
* Topics discussed in Chapter 1

---
name: chapter-1-nomad-place-in-hashistack
# Nomad's Place in the HashiStack
.center[![:scale 80%](images/Nomad_HashiStack_Velocity.png)]

???

* Organizations can use Nomad to run their containerized workloads across any cloud or on premise.

---
name: chapter-1-shift-to-containers
# The Shift to Containers
.center[![:scale 70%](images/Nomad_Business_Value.png)]

???
*  Lowers total cost of ownership (TCO) via bin packing
*  Runs both containerized and legacy apps (e.g. Java classes and jars)
*  Easy to operate and maintain

???
* Companies are embracing containers, but still need to run legacy applications.
* Nomad supports both.

---
name: chapter-1-nomad-business-value
# Nomad's Business Value
* Increase Hardware Utilization.
  * Increase density of running applications through bin-packing.
* Reduce Operational Overhead.
 * Empower developers to self-service their own applications with less or no assistance from operators.
* Accelerate Time To Market.
  * Run containers and legacy applications together with the same workflow on the same infrastructure.

???
*  Let's discuss the business benefits of Nomad.

---
name:  chapter1-what-is-nomad
# What is Nomad?
* A flexible, lightweight, high performing, easy to use orchestrator
* Used to deploy and manage containers and legacy applications simultaneously
* Works across data centers and cloud platforms, providing universal scheduling
* Manages services, batch functions, as well as global system services

???
* Nomad runs as a single binary in just about any environment * one of the easiest and lightweight service scheduler and manager available.
*  Used to deploy both container applications, as well as legacy applications such as Java or raw executables.
*  As an independent function, Nomad can run and communicate across data centers, and cloud platforms.  Truly cloud agnostic.
*  Can manage individual services, batch functions, or even global system services such as monitoring functions.

---
name: chapter-1-nomad-use-cases
# Nomad Use Cases
.center[![:scale 70%](images/Nomad_Use_Cases.png)]

???
* Container Workloads
* Legacy Applications
* Batch Jobs like Machine Learning

---
name: chapter-1-nomad-workload-types
# Run All Types of Workloads
.center[![:scale 100%](images/Nomad-Workload-Types.png)]

???
* Nomad can run these 3 types of workloads

---
name: chapter-1-nomad-autoscaling
class: compact
# Nomad Autoscaling
* Nomad supports two types of autoscaling:
  * **Horizontal Application Autoscaling** allows the counts of task groups to dynamically scale up and back down.
  * **Horizontal Cluster Autoscaling** allows the size of a Nomad cluster to dynamically scale out and back in.
* The latter is currently only supported in AWS using Auto Scaling Groups (ASGs).
* Both types of autoscaling are driven by APM metrics.
* The Nomad Autoscaler agent can be deployed as a Nomad job.

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
.center[![:scale 100%](images/Nomad-Federation.png)]

???
* Nomad can deploy applications seamlessly to federated clusters across multiple clouds.
* It is the first and only orchestrator on the market with complete and fully-supported federation capabilities for production.
---
name: chapter-1-nomad-oss-features
class: smaller
# Nomad Open Source Features
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
# Nomad Enterprise Platform Features
* All Open Source Features
* Automated Upgrades with Autopilot
* Automated Backups with Snapshot Agent
* Enhanced Read Scalability
* Redundancy Zones
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
# Nomad Enterprise Modules
* Nomad Enterprise Governance & Policy Module
  * Namespaces
  * Resource Quotas
  * Sentinel Policies
  * Cross-Namespace Queries
  * Audit Logging
* Nomad Multi-Cluster & Efficiency Module
  * Multi-Region Job Deployments

???
* A shared cluster can be partitioned into multiple namespaces which allow jobs and their associated objects to be isolated from each other and other users of the cluster
* Resource quotas limit resource consumption across teams or projects to reduce waste and align budgets
* Sentinel defines policies such as disallowing jobs to be submitted to production on Fridays or only allowing users to run jobs that use pre-authorized Docker images
* Cross-Namespace Queries allow the Nomad HTTP API and CLI to retrieve data from multiple namespaces.
* Audit Logging allows enterprises to proactively identify access anomalies.
* Multi-region Deployments can deploy allocations across multiple Nomad clusters/regions and roll back if deployments fail in remote clusters.
