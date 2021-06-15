name: nomad-chapter-6-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 6
## 다중 서버에 Nomad와 Consul 실행

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss Nomad clustering options.
* You'll run another Instruqt lab in which you will run a multi-server cluster that uses both Nomad and Consul.

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-6-topics
# Chapter 6 Topics

1. Nomad 클러스터링 옵션
1. Nomad와 Consul의 통합
1. Nomad 다중 서버 클러스터 실습

   * Nomad 클러스터를 수동으로 부트 스트랩
   * Consul로 Nomad Cluster 부트 스트랩
   * Consul에 작업을 등록하고 Consul Connect와의 통신을 보호하는 작업 실행


???
* This is our topics slide.

---
name: nomad-clustering-options
# Nomad Clustering Options
* Nomad에는 3 가지 클러스터링 옵션이 있습니다.
  * [Manual Clustering](https://www.nomadproject.io/guides/operations/cluster/manual.html):
      *  알려진 IP 또는 DNS 주소 사용
  * [Automated Clustering with Consul](https://www.nomadproject.io/guides/operations/cluster/automatic.html)
      * 동일한 서버에서 실행되는 Consul 클러스터를 사용합니다.
  * [Clustering with Cloud Auto-Joining](https://www.nomadproject.io/guides/operations/cluster/cloud_auto_join.html)
      * AWS, Azure 및 GCP의 클라우드 태그 사용

???
* Nomad provides 3 ways of bootstrapping clusters

---
name:  nomad-integration-with-consul
# Nomad와 Consul 통합
- 서버 및 클라이언트의 자동 클러스터링

* Job과 Task에 대한 서비스 검색
* 애플리케이션을위한 동적 구성
* Consul Connect를 사용하여 작업과 작업 그룹 간의 보안 통신

???
*  Nomad Servers and Clients can automatically find each other within the network, minimizing configuration and being more address-flexible.
*  Consul enables application service nodes to be automatically discoverable within the cluster
*  Configuration files can be dynamically created utilizing environment variables or even Vault secrets with templating
*  Consul Connect can secure communication between services deployed in public or private clouds.

---
name: nomad-consul-config
# Consul을 사용하도록 Nomad 구성
* Nomad 에이전트를 설치해도 Consul 에이전트는 설치되지 않습니다.
* 하지만 Consul 에이전트가 있고 표준 포트 8500을 사용하는 경우 Nomad 에이전트가 자동으로 찾아 연결합니다.
* 또한 Nomad 에이전트는 Consul에 서비스를 알립니다.
* 그러나 Nomad의 ACL 및 TLS를 활성화 한 경우 각 에이전트의`consul` 스탠자에 대해 몇 가지 추가 구성을 수행해야합니다.
  * https://www.nomadproject.io/docs/configuration/consul.html 

???
* Each Nomad agent will automatically connect to the local Consul agent if one is running.

---
name: nomad-service-stanza
class: smaller
# Consul에 Nomad 작업 등록
* Nomad Job 구성 파일의 'service'스탠자는 Nomad 작업을 Consul 서비스로 등록하고 상태 확인을 구성하는 데 사용됩니다.

```hcl
service {
  name = "load-balancer"
  check {
    type     = "http"
    port     = "lb"
    path     = "/_healthz"
    interval = "5s"
    timeout  = "2s"
  }
}
```

???
* The `service` stanza of the Nomad job specification file is used to register Nomad tasks as Consul services.
* See https://www.nomadproject.io/docs/job-specification/service.html for details.

---
name: nomad-and-consul-template
class: smaller
# Dynamic Templating
* Nomad는 [Consul-Template](https://github.com/hashicorp/consul-template)과 기본적으로 통합되어 Consul의 Key/Value 저장소, Vault 보안 비밀 및 환경 변수를 사용하여 파일 템플릿을 만들 수 있습니다.

```hcl
template {
  data = <<EOH
  ---
    bind_port:   {{ env "NOMAD_PORT_db" }}
    scratch_dir: {{ env "NOMAD_TASK_DIR" }}
    node_id:     {{ env "node.unique.id" }}
    service_key: {{ key "service/my-key" }}
  EOH
  destination = "local/file.yml"
}
```

???
* Nomad also provides templating using Consul Template
* In this example, the local file, file.yml, will include some interpolated environment variables of the Nomad task and the contents of the service/my-key from Consul's key/value store.

---
name: nomad-and-consul-connect
class: smaller
# Nomad & Consul Connect
* Nomad에는 [Consul Connect](https://www.consul.io/docs/connect/index.html)와의 기본 통합도 포함되어 있습니다.
* Consul Connect는 상호 TLS를 사용하여 서비스 간 연결 인증 및 암호화를 제공합니다.
* 애플리케이션은 Consul Connect를 인식하지 않고도 서비스 메시 구성에서 사이드카 프록시를 사용할 수 있습니다.
* Nomad와 Consul Connect의 통합은 Nomad 작업 그룹 간의 보안 통신을 제공합니다.
* 여기에는 작업 그룹의 모든 작업이 네트워킹 스택을 공유 할 수 있도록하는 작업에 대한 새로운 네트워킹 모드가 포함됩니다.
* 활성화되면 Nomad는 Consul Connect에서 사용하는 [Envoy] (https://www.envoyproxy.io) 프록시를 자동으로 시작합니다.




???
* Nomad also has native integration for Consul Connect

---
name: lab-nomad-multi-server-cluster
# 👩‍💻 Nomad Multi-Server Cluster Lab
* 이 실습에서는 여러 서버로 Nomad 클러스터를 구성합니다.
* 먼저 Nomad의 수동 클러스터링 옵션을 사용합니다.
* 그런 다음 Consul을 사용하여 자동 클러스터링을 활성화합니다.
* 그런 다음 작업을 Consul 서비스로 등록하고 Consul Connect를 사용하는 작업을 실행합니다.
* Consul의 서비스 검색을 통해 작업이 서로를 찾는 방법을 볼 수 있습니다.
* 이 모든 작업은 [Nomad Multi-Server Cluster](https://play.instruqt.com/hashicorp/invite/igeavsouomb2) Instruqt 트랙에서 수행됩니다.

???
* Now, you will run the Instruqt lab "Nomad Multi-Server Cluster"

---
name: lab-challenge-6.1
# 👩‍💻 Lab Challenge 6.1: Bootstrap Cluster Manually
* 이 과제에서는 클러스터를 수동으로 부트 스트랩합니다.
* 트랙의 "Bootstrap a Nomad Cluster Manually"챌린지를 클릭하여 "Nomad Multi-Server Cluster"트랙을 시작합니다.
* 지침
   * 챌린지가로드되는 동안 두 화면의 메모를 읽으십시오.
   * 첫 번째 과제를 시작하려면 녹색 "Start"버튼을 클릭하십시오.
   * 과제의 오른쪽에있는 지침을 따르십시오.
   * 모든 단계를 완료 한 후 녹색 "Check"버튼을 클릭하여 모든 작업을 올바르게 수행했는지 확인하십시오.
   * 또한 "Check"버튼을 클릭하여 미리 알림을받을 수도 있습니다.

???
* Give the students some instructions for starting their first challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminded of what they should do next.

---
name: lab-challenge-6.2
# 👩‍💻 Lab Challenge 6.2: Bootstrap with Consul

* 이 과제에서는 Consul과 함께 Nomad 클러스터를 부트 스트랩합니다.
* 지침 :
   * "Nomad Multi-Server Cluster"트랙의 "Bootstrap a Nomad Cluser with Consul"챌린지를 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 과제의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* In this challenge, you will bootstrap a Nomad cluster using Consul.

---
name: lab-challenge-6.3
# 👩‍💻 Lab Challenge 6.3: Run a Consul-enabled Job

* 이 과제에서는 작업을 Consul 서비스로 등록하고 안전한 통신을 위해 Consul Connect를 사용하는 작업을 실행합니다.
* 지침 :
   * "Nomad Multi-Server Cluster"트랙의 "Run Consul-enabled Job" 과제를 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 과제의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* In this challenge, you will run a Nomad job that registers its tasks with Consul and uses Consul Connect.
* You will then see how the tasks find each other using Consul's service discovery and communicate securely.

---
name: chapter-6-Summary
# 📝 Chapter 6 Summary

* 이 장에서 학습 한 내용은 다음과 같습니다.

  * Consul을 사용하여 Nomad 클러스터를 수동으로 부트 스트랩하는 방법
  * Nomad가 Consul에 작업 작업을 등록하는 방법
  * Nomad가 Consul Connect 프록시를 자동으로 실행하여 작업 간의 통신을보다 안전하게 만드는 방법.

???
* Summarize what we covered in the chapter
