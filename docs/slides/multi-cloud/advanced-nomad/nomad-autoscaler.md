name: chapter-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad Autoscaler

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
This is a title slide for the Nomad Autoscaler chapter.

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-autoscaler-topics
class: compact
# Nomad Autoscaler
* The [Nomad Autoscaler](https://www.nomadproject.io/docs/autoscaling) currently supports three types of autoscaling:
  * **Horizontal Application Autoscaling** allows the counts of task groups to dynamically scale up and back down.
  * **Horizontal Cluster Autoscaling** allows the size of a Nomad cluster to dynamically scale out and back in. (Supported in AWS and Azure)
  * **Dynamic Application Sizing** allows optimization of resource consumption with sizing recommendations from Nomad. (Nomad Enterprise only)
* All autoscaling types are driven by APM metrics.
* The Nomad Autoscaler agent can be deployed as a Nomad job.

???
* In this chapter, you'll learn about the Nomad Autoscaler.
* It supports two types of autoscaling, both driven by APM metrics.
* The Nomad Autoscaler agent can be deployed as a Nomad job.

---
name: autoscaling-plugins
class: compact
# Nomad Autoscaler Plugins
* The Nomad Autoscaler supports 3 types of plugins:
  * [APM Plugins](https://www.nomadproject.io/docs/autoscaling/plugins/apm) query Appliation Performance Management (APM) systems to retrieve values of various metrics that are used to determine if scaling actions should be taken.
  * [Strategy Plugins](https://www.nomadproject.io/docs/autoscaling/plugins/strategy) compare the current state of the system against the desired state specified in [Autoscaling Policies](https://www.nomadproject.io/docs/autoscaling/policy) to generate scaling actions.
  * [Target Plugins](https://www.nomadproject.io/docs/autoscaling/plugins/target) determine which Nomad resource (task group or cluster) should be autoscaled.
  * HashiCorp customers and partners will eventually be able to write their own plugins.

???
* The Nomad Autoscaler has a flexible plug-and-play system that supports 3 types of plugins
* HashiCorp customers and partners will eventually be able to write their own plugins.

---
name: autoscaling-apm-plugins
# Nomad Autoscaler APM Plugins
* The Nomad Autoscaler provides the following APM plugins out of the box.
 * The [Nomad](https://www.nomadproject.io/docs/autoscaling/plugins/apm#nomad-apm-plugin) plugin queries the Nomad API for metric data.
 * The [Prometheus](https://www.nomadproject.io/docs/autoscaling/plugins/apm#prometheus-apm-plugin) plugin consumes Prometheus metrics.
 * The [Datadog](https://www.nomadproject.io/docs/autoscaling/plugins/apm#datadog-apm-plugin) plugin consumes Datadog metrics.

???
* The default APM plugins
---
name: autoscaling-strategy-plugins
# Nomad Autoscaler Strategy Plugins
* The Nomad Autoscaler provides the [Target Value  Strategy](https://www.nomadproject.io/docs/autoscaling/plugins/strategy#target-value-strategy-plugin) plugin out of the box.
  * It performs count calculations in order to keep specified APM metrics near a specified value.
* The Nomad Autoscaler also provides the [Dynamic Application Sizing Average](https://www.nomadproject.io/docs/autoscaling/plugins/strategy#dynamic-application-sizing-average-strategy-plugin), the [Dynamic Application Sizing Max](https://www.nomadproject.io/docs/autoscaling/plugins/strategy#dynamic-application-sizing-max-strategy-plugin), and the [Dynamic Application Sizing Percentile](https://www.nomadproject.io/docs/autoscaling/plugins/strategy#dynamic-application-sizing-percentile-strategy-plugin) strategy plugins for use with Dynamic Application Sizing.

???
* The default strategy plugins
---
name: autoscaling-target-plugins
# Nomad Autoscaler Target Plugins
* The Nomad Autoscaler provides the following target  plugins out of the box.
 * The [Nomad Task Group Target](https://www.nomadproject.io/docs/autoscaling/plugins/target#nomad-task-group-target) plugin targets Nomad task groups.
 * The [Dynamic Application Sizing Nomad Task Target](https://www.nomadproject.io/docs/autoscaling/plugins/target#dynamic-application-sizing-nomad-task-target) plugin targets cpu and memory resource allocations of specific tasks.
 * The [AWS AutoScaling Group Target](https://www.nomadproject.io/docs/autoscaling/plugins/target#aws-autoscaling-group-target) plugin targets AWS AutoScaling Groups (ASGs) controlling a set of Nomad clients.
 * The [Azure Virtual Machine Scale Set Target](https://www.nomadproject.io/docs/autoscaling/plugins/target#azure-virtual-machine-scale-set-target) plugin targets Azure Load Balancers controlling a set of Nomad clients.

???
* The default target plugins

---
name: autoscaling-policies
# Nomad Autoscaler Policies
* Nomad autoscaling is driven by [Policies](https://www.nomadproject.io/docs/autoscaling/policy) defined in the `scaling` stanza of a task group in a Nomad job specification file or in the autoscaler agent's own configuration files.
* The `scaling` stanza uses the [Nomad Task Group Target](https://www.nomadproject.io/docs/autoscaling/plugins/target#nomad-task-group-target) plugin to scale the task group's count up and down or the [Dynamic Application Sizing Nomad Task Target](https://www.nomadproject.io/docs/autoscaling/plugins/target#dynamic-application-sizing-nomad-task-target) plugin to make sizing recommendations for the resources used by tasks.
* An autoscaler configuration file would be used with other targets such as the AWS AutoScaling Group Target and the Azure Virtual Machine Scale Set Target plugins.

???
* Nomad autoscaling is driven by policies.

---
name: autoscaling-policy-details
class: compact, smaller
# Autoscaler Policy Details
* The `scaling` stanza of a task group specifies `enabled`, `min`, and `max` parameters and a `policy` map.
* The `policy` map includes the following options:
  * `evaluation_interval` specifies how often the policy is evaluated.
  * The `cooldown` specifies a period during which no scaling actions should be taken immediately after a scaling action is taken. This avoids flapping.
  * The `target` specifies the autoscaling target. In a policy specified by the `scaling` stanza of a task group, this would generally not be specified since it defaults to the Nomad Task Group Target.
  * The `check` specifies a check to be executed to determine if a scaling action is required.
      * The `check` specifies the APM plugin (`source`) and the Strategy plugin (`strategy`) to use and the `query` to run against the first.  

???
* Autoscaling policy details

---
name: autoscaling-policy-example
class: compact, smaller
# An Autoscaler Example
```hcl
scaling {
  enabled = true
  min     = 1
  max     = 10
  policy {
    cooldown            = "1m"
    evaluation_interval = "30s"
    check "avg_sessions" {
      source   = "prometheus"
      query    = "scalar(open_connections_example_cache)"
      strategy "target-value" { target = 10 }
    }
  }
}
```

???
* This shows an example of a complete `scaling` stanza

---
name: autoscaling-demos
# Autoscaler Demos
* There are several Nomad Autoscaler demos that you can run yourself:
  * The [Horizontal App Scaling](https://github.com/hashicorp/nomad-autoscaler/tree/master/demo/vagrant) demo demonstrates horizontal application autoscaling by scaling the task group count of a web application in Nomad job. It runs in a Vagrant environment.
  * The [Dynamic Application Sizing](https://github.com/hashicorp/nomad-autoscaler/tree/master/demo/vagrant/dynamic-app-sizing) demo also runs in Vagrant.
  * The [Remote](https://github.com/hashicorp/nomad-autoscaler/tree/master/demo/remote) demo demonstrates both horizontal application and horizontal cluster autoscaling. It scales both the task group count of a web application and the number of Nomad clients behind an AWS Auto Scaling Group or an Azure Virtual Machine Scale Set.

???
* Two Nomad Autoscaler demos
---
name: chapter-Summary
# 📝 Chapter Summary
* In this chapter you learned about the following aspects of the Nomad Autoscaler:
  * The types of autoscaling it can do.
  * The types of plugins (APM, Strategy, and Target) plugins it supports and includes out of the box.
  * How autoscaling policies determine what scaling actions to take.
* You also learned about several Nomad Autoscaler demos you can run on your own.


???
* You now know a lot more about Nomad's Autoscaler than you did yesterday.
