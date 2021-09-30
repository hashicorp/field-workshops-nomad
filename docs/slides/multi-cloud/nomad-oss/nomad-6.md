name: nomad-chapter-6-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 6
## Running a Multi-Server Nomad/Consul Cluster

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

1. Nomad Clustering Options
1. Nomad's Integration with Consul
1. Nomad Multi-Server Cluster Lab
  * Bootstrap a Nomad Cluster Manually
  * Bootstrap a Nomad Cluster with Consul
  * Run a Job that Registers Tasks with Consul and Secures Their Communication with Consul Connect


???
* This is our topics slide.

---
name: nomad-clustering-options
# Nomad Clustering Options
* Nomad has 3 clustering options:
  * [Manual Clustering](https://www.nomadproject.io/guides/operations/cluster/manual.html):
      * Uses known IP or DNS addresses
  * [Automated Clustering with Consul](https://www.nomadproject.io/guides/operations/cluster/automatic.html)
      * Uses a Consul cluster running on same servers.
  * [Clustering with Cloud Auto-Joining](https://www.nomadproject.io/guides/operations/cluster/cloud_auto_join.html)
      * Uses cloud tags from AWS, Azure, and GCP

???
* Nomad provides 3 ways of bootstrapping clusters

---
name:  nomad-integration-with-consul
# Nomad's Native Integration with Consul
* Automatic Clustering of Servers and Clients
* Service Discovery for Tasks and Jobs
* Dynamic Configuration for applications
* Secure communication between jobs and task groups using Consul Connect

???
*  Nomad Servers and Clients can automatically find each other within the network, minimizing configuration and being more address-flexible.
*  Consul enables application service nodes to be automatically discoverable within the cluster
*  Configuration files can be dynamically created utilizing environment variables or even Vault secrets with templating
*  Consul Connect can secure communication between services deployed in public or private clouds.

---
name: nomad-consul-config
# Configuring Nomad to Use Consul
* Installing the Nomad agent does not install the Consul agent.
* But, if the Consul agent is present and using the standard port, 8500, the Nomad agent will automatically find and connect to it.
* Additionally, the Nomad agent will advertise its services to Consul.
* However, if you have enabled Nomad's ACLs and TLS, you will have to do some additional config of each agent's `consul` stanza.
  * See https://www.nomadproject.io/docs/configuration/consul.html for details.

???
* Each Nomad agent will automatically connect to the local Consul agent if one is running.

---
name: nomad-service-stanza
class: smaller
# Registering Nomad Tasks with Consul
* The `service` stanza of the Nomad job specification file is used to register Nomad tasks as Consul services and configure health checks.

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
* Nomad has native integration with [Consul-Template](https://github.com/hashicorp/consul-template), which allows templating of files using Consul's key/value store, Vault secrets, and environment variables.

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
# Nomad and Consul Connect
* Nomad includes native integration with [Consul Connect](https://www.consul.io/docs/connect/index.html) too.
* Consul Connect provides service-to-service connection authorization and encryption using mutual TLS.
* Applications can use sidecar proxies in a service mesh configuration without any awareness of Consul Connect.
* Nomad's integration with Consul Connect provides secure communications between Nomad task groups.
* This includes a new networking mode for jobs that allows all tasks in a task group to share their networking stack.
* When enabled, Nomad automatically launches [Envoy](https://www.envoyproxy.io) proxies used by Consul Connect.




???
* Nomad also has native integration for Consul Connect

---
name: lab-nomad-multi-server-cluster
# 👩‍💻 Nomad Multi-Server Cluster Lab
* In this lab, you'll configure a Nomad cluster with multiple servers.
* First, you'll use Nomad's manual clustering option.
* You'll then use Consul to enable automatic clustering.
* You'll then run a job that registers its tasks as Consul sevices and uses Consul Connect.
* You'll see how the tasks find each other with Consul's service discovery.
* You'll do all this in the **Nomad Multi-Server Cluster** Instruqt track.
* Your instructor will provide a link to it.

???
* Now, you will run the Instruqt lab "Nomad Multi-Server Cluster"

---
name: lab-challenge-6.1
# 👩‍💻 Lab Challenge 6.1: Bootstrap Cluster Manually
* In this challenge, you will bootstrap a cluster manually.
* Start the "Nomad Multi-Server Cluster" track by clicking the "Bootstrap a Nomad Cluster Manually" challenge of the track.
* Instructions
  * While the challenge is loading, read the notes in both screens.
  * Click the green "Start" button to start the first challenge.
  * Follow the instructions on the right side of the challenge.
  * After completing all the steps, click the green "Check" button to see if you did everything right.
  * You can also click the "Check" button for reminders.

???
* Give the students some instructions for starting their first challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminded of what they should do next.

---
name: lab-challenge-6.2
# 👩‍💻 Lab Challenge 6.2: Bootstrap with Consul

* In this challenge, you'll bootstrap the Nomad cluster with Consul.
* Instructions:
  * Click the "Bootstrap a Nomad Cluser with Consul" challenge of the "Nomad Multi-Server Cluster" track.
  * Then click the green "Start" button.
  * Follow the challenge's instructions.
  * Click the green "Check" button when finished.

???
* In this challenge, you will bootstrap a Nomad cluster using Consul.

---
name: lab-challenge-6.3
# 👩‍💻 Lab Challenge 6.3: Run a Consul-enabled Job

* In this challenge, you'll run a job that registers tasks as Consul services and uses Consul Connect for secure communication.
* Instructions:
    * Click the "Run Consul-enabled Job" challenge of the "Nomad Multi-Server Cluster" track.
    * Then click the green "Start" button.
    * Follow the challenge's instructions.
    * Click the green "Check" button when finished.

???
* In this challenge, you will run a Nomad job that registers its tasks with Consul and uses Consul Connect.
* You will then see how the tasks find each other using Consul's service discovery and communicate securely.

---
name: chapter-6-Summary
# 📝 Chapter 6 Summary

In this chapter, you learned:
* How to bootstrap a Nomad cluster manually and with Consul
* How Nomad can register tasks of jobs with Consul
* How Nomad can automatically run Consul Connect proxies to make communications between tasks more secure.

???
* Summarize what we covered in the chapter
