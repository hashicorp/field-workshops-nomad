name: nomad-chapter-6-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 6
## Nomad Monitoring and Logging

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll provide an overview of Nomad monitoring and logging

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-6-topics
# Chapter 6 Topics

1. Monitoring Nomad Jobs
2. Monitoring Nomad Allocations
3. Monitoring Resource Utilization
4. Inspecting Allocation Logs

???
* This is our topics slide.

---
class: img-right-full

![start](images/jukan-tateisi-bJhT_8nbUA0-unsplash.jpg)

# Getting Started

- [<u>Reference Material ][1]</u>
- [<u>Estimated Time to Complete][2]</u>
- [<u>Challenge][3]</u>
- [<u>Solution][4]</u>
- [<u>Prerequisites][5]</u>
- [<u>Steps][6]</u>
- [<u>Next Steps][7]</u>

This guide explains how to configure [<u>Prometheus][8]</u> to integrate with a Nomad cluster and Prometheus [<u>Alertmanager][9]</u>. 

???
While this guide introduces the basics of enabling [<u>telemetry][10]</u> and alerting, a Nomad operator can go much further by customizing dashboards and integrating different [<u>receivers][11]</u> for alerts.

---
name: reference-material
# Reference Material

- [<u>Configuring Prometheus][13]</u>
- [<u>Telemetry Stanza in Nomad Agent Configuration][14]</u>
- [<u>Alerting Overview][15]</u>
- [_Using Prometheus to Monitor Nomad Metrics_](https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html)

---
name: estimated-time-to-complete

# Estimated Time to Complete

25 minutes

---
name: challenge

# Challenge

Think of a scenario where a Nomad operator needs to deploy Prometheus to collect metrics from a Nomad cluster.

- The operator must enable telemetry on the Nomad servers and clients as well as configure Prometheus to use Consul for service discovery.
- The operator must also configure Prometheus Alertmanager so notifications can be sent out to a specified [<u>receiver][18]</u>.

---
name: solution

# Solution

Deploy Prometheus with a configuration that accounts for a highly dynamic environment.

- Integrate service discovery into the configuration file to avoid using hard-coded IP addresses.
- Place the Prometheus deployment behind [<u>fabio][20]</u> (this will allow easy access to the Prometheus web interface by allowing the Nomad operator to hit any of the client nodes at the / path.

---

# Prerequisites

To perform the tasks described in this guide, you need to have a Nomad environment with Consul installed.

- You can use this [<u>repo][22]</u> to easily provision a sandbox environment.
- This guide will assume a cluster with one server node and three client nodes.

**Please Note:** This guide is for demo purposes and is only using a single server node.

- In a production cluster, 3 or 5 server nodes are recommended.
- The alerting rules defined in this guide are for instructional purposes.
- Please refer to [<u>Alerting Rules][23]</u> for more information.

---
name: steps
class: title
background-image: url(tech-background-01.png)

# Steps

---
class: compact, col-2
# Step 1: Enable Telemetry on Nomad Servers and Clients 

Add the stanza below in your Nomad client and server configuration files.

- If you have used the provided repo in this guide to set up a Nomad cluster, the configuration file will be `/etc/nomad.d/nomad.hcl`.

``` go
telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
```

- After making this change, restart the Nomad service on each server and client node.

---
class:compact, col-2

# Step 2: Create a Job for Fabio

Create a job for Fabio and name it `fabio.nomad`

- Note that the `type` option is set to [<u>`system`][28]</u> so that fabio will be deployed on all client nodes. 
- We have also set `network_mode` to `host` so that fabio will be able to use Consul for service discovery.

```go
job "fabio" {
  datacenters = ["dc1"]
*  type = "system"

  group "fabio" {
    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
      }

      resources {
        cpu    = 100
        memory = 64
        network {
          mbits = 20
          port "lb" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
```

???
To learn more about fabio and the options used in this job file, see [<u>Load Balancing with Fabio][27]</u>.

---
class:compact, col-2

# Step 3: Run the Fabio Job

Register our fabio job:

```shell
*$ nomad job run fabio.nomad
==> Monitoring evaluation "7b96701e"
    Evaluation triggered by job "fabio"
    Allocation "d0e34682" created: node "28d7f859", group "fabio"
    Allocation "238ec0f7" created: node "510898b6", group "fabio"
    Allocation "9a2e8359" created: node "f3739267", group "fabio"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "7b96701e" finished with status "complete"
```

You should be able to visit any one of your client nodes at port `9998` and see the web interface for fabio.

- The routing table will be empty since we have not yet deployed anything that fabio can route to.
- Accordingly, if you visit any of the client nodes at port `9999` at this point, you will get a `404` HTTP response.
- That will change soon.

---
class:compact, col-2

# Step 4: Create a Job for Prometheus

Create a job for Prometheus and name it `prometheus.nomad`

``` go
job "prometheus" {
  datacenters = ["dc1"]
  type = "service"

  group "monitoring" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    ephemeral_disk {
      size = 300
    }
```

---
class:compact

# ...continued

```go
    task "prometheus" {
*      template {
        change_mode = "noop"
        destination = "local/prometheus.yml"
        data = <<EOH
---
global:
  scrape_interval:     5s
  evaluation_interval: 5s

scrape_configs:

  - job_name: 'nomad_metrics'

    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['nomad-client', 'nomad']

    relabel_configs:
    - source_labels: ['__meta_consul_tags']
      regex: '(.*)http(.*)'
      action: keep

    scrape_interval: 5s
    metrics_path: /v1/metrics
    params:
      format: ['prometheus']
EOH
```

---
class:compact, col-2

# ...continued

```go
      }
      driver = "docker"
      config {
        image = "prom/prometheus:latest"
        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml"
        ]
        port_map {
          prometheus_ui = 9090
        }
      }
      resources {
        network {
          mbits = 10
          port "prometheus_ui" {}
        }
      }
      service {
        name = "prometheus"
        tags = ["urlprefix-/"]
        port = "prometheus_ui"
        check {
          name     = "prometheus_ui port alive"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
```

Notice we are using the [<u>`template`][31]</u> stanza to create a Prometheus configuration using [<u>environment][32]</u> variables.

- In this case, we are using the environment variable `NOMAD_IP_prometheus_ui` in the [<u>`consul_sd_configs`][33]</u> section to ensure Prometheus can use Consul to detect and scrape targets. This works in our example because Consul is installed alongside Nomad.
- Additionally, we benefit from this configuration by avoiding the need to hard-code IP addresses. 
- If you did not use the repo provided in this guide to create a Nomad cluster, be sure to point your Prometheus configuration to a Consul server you have set up.

The [<u>`volumes`][34]</u> option allows us to take the configuration file we dynamically created and place it in our Prometheus container.

---
class:compact, col-2

# Step 5: Run the Prometheus Job

We can now register our job for Prometheus:

```shell
*$ nomad job run prometheus.nomad
==> Monitoring evaluation "4e6b7127"
    Evaluation triggered by job "prometheus"
    Evaluation within deployment: "d3a651a7"
    Allocation "9725af3d" created: node "28d7f859", group "monitoring"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "4e6b7127" finished with status "complete"
```

Prometheus is now deployed.

- You can visit any of your client nodes at port `9999` to visit the web interface.
- There is only one instance of Prometheus running in the Nomad cluster, but you are automatically routed to it regardless of which node you visit because fabio is deployed and running on the cluster as well.

---
class: compact, col-2

# ...continued

At the top menu bar, click on **Status** and then **Targets**.

- You should see all of your Nomad nodes (servers and clients) show up as targets.
- Please note that the IP addresses will be different in your cluster.
![prometheus-targets](https://www.nomadproject.io/assets/images/prometheus-targets-e2a7832d.png)

---
class: compact, col-2

# ...continued

Let's use Prometheus to query how many jobs are running in our Nomad cluster.

- On the main page, type `nomad_nomad_job_summary_running` into the query section.
- You can also select the query from the drop-down list.

![running-jobs](https://www.nomadproject.io/assets/images/running-jobs-564b55df.png)

You can see that the value of our fabio job is `3` since it is using the [<u>**system**][36]</u> scheduler type. This makes sense because we are running three Nomad clients in our demo cluster.

- The value of our Prometheus job, on the other hand, is `1` since we have only deployed one instance of it.
- To see the description of other metrics, visit the [<u>telemetry][37]</u> section.

---
class:compact, col-2
# Step 6: Deploy Alertmanager

Now that we have enabled Prometheus to collect metrics from our cluster and see the state of our jobs, let's deploy [<u>**Alertmanager**][39]</u>.

- Keep in mind that Prometheus sends alerts to Alertmanager.
- It is then Alertmanager's job to send out the notifications on those alerts to any designated [<u>**receiver**][40]</u>.

Create a job for Alertmanager and name it `alertmanager.nomad`

```go

job "alertmanager" {
  datacenters = ["dc1"]
  type = "service"

  group "alerting" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    ephemeral_disk {
      size = 300
    }
```

---
class:compact

# ...continued

``` go
    task "alertmanager" {
      driver = "docker"
      config {
        image = "prom/alertmanager:latest"
        port_map {
          alertmanager_ui = 9093
        }
      }
      resources {
        network {
          mbits = 10
          port "alertmanager_ui" {}
        }
      }
      service {
        name = "alertmanager"
        tags = ["urlprefix-/alertmanager strip=/alertmanager"]
        port = "alertmanager_ui"
        check {
          name     = "alertmanager_ui port alive"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
```

---
class:compact, col-2

# Step 7: Configure Prometheus to Integrate with Alertmanager

Now that we have deployed Alertmanager, let's slightly modify our Prometheus job configuration to allow it to recognize and send alerts to it.

- Note that there are some rules in the configuration that refer a to a web server we will deploy soon.

Below is the same Prometheus configuration we detailed above, but we have added some sections that hook Prometheus into the Alertmanager and set up some Alerting rules.

```go
job "prometheus" {
  datacenters = ["dc1"]
  type = "service"

  group "monitoring" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    ephemeral_disk {
      size = 300
    }
```

---
class:compact

# ...continued

``` go
    task "prometheus" {
      template {
        change_mode = "noop"
        destination = "local/webserver_alert.yml"
        data = <<EOH
---
groups:
- name: prometheus_alerts
  rules:
  - alert: Webserver down
    expr: absent(up{job="webserver"})
    for: 10s
    labels:
      severity: critical
    annotations:
      description: "Our webserver is down."
EOH
      }

      template {
        change_mode = "noop"
        destination = "local/prometheus.yml"
        data = <<EOH
---
global:
  scrape_interval:     5s
  evaluation_interval: 5s
```

---
class:compact

# ...continued

``` go
alerting:
  alertmanagers:
  - consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['alertmanager']

rule_files:
  - "webserver_alert.yml"

scrape_configs:

  - job_name: 'alertmanager'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['alertmanager']

  - job_name: 'nomad_metrics'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['nomad-client', 'nomad']

    relabel_configs:
    - source_labels: ['__meta_consul_tags']
      regex: '(.*)http(.*)'
      action: keep

    scrape_interval: 5s
    metrics_path: /v1/metrics
    params:
      format: ['prometheus']

  - job_name: 'webserver'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
      services: ['webserver']

    metrics_path: /metrics
EOH
      }
      driver = "docker"
      config {
        image = "prom/prometheus:latest"
        volumes = [
          "local/webserver_alert.yml:/etc/prometheus/webserver_alert.yml",
          "local/prometheus.yml:/etc/prometheus/prometheus.yml"
        ]
        port_map {
          prometheus_ui = 9090
        }
      }
      resources {
        network {
          mbits = 10
          port "prometheus_ui" {}
        }
      }
      service {
        name = "prometheus"
        tags = ["urlprefix-/"]
        port = "prometheus_ui"
        check {
          name     = "prometheus_ui port alive"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
```

---
class:compact, col-2

Notice we have added a few important sections to this job file:

- We added another template stanza that defines an [<u>alerting rule][42]</u> for our web server. Namely, Prometheus will send out an alert if it -etects the `webserver` service has disappeared.
- We added an `alerting` block to our Prometheus configuration as well as a `rule_files` block to make Prometheus aware of Alertmanager as well -s the rule we have defined.
- We are now also scraping Alertmanager along with our web server.

---
class:compact, col-2

# Step 8: Deploy Web Server

Create a job for our web server and name it `webserver.nomad`

```go
job "webserver" {
  datacenters = ["dc1"]

  group "webserver" {
    task "server" {
      driver = "docker"
      config {
        image = "hashicorp/demo-prometheus-instrumentation:latest"
      }

      resources {
        cpu = 500
        memory = 256
        network {
          mbits = 10
          port  "http"{}
        }
      }
```

```go
      service {
        name = "webserver"
        port = "http"

        tags = [
          "testweb",
          "urlprefix-/webserver strip=/webserver",
        ]

        check {
          type     = "http"
          path     = "/"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
```

---
class:compact, col-2

# ...continued

At this point, re-run your Prometheus job. After a few seconds, you will see the web server and Alertmanager appear in your list of targets.

![new-targets](https://www.nomadproject.io/assets/images/new-targets-7e2bcd93.png)

You should also be able to go to the **Alerts** section of the Prometheus web interface and see the alert that we have configured. No alerts are active because our web server is up and running.

![alerts](https://www.nomadproject.io/assets/images/alerts-ee875c5e.png)

---
class:compact, col-2

# Step 9: Stop the Web Server

Run `nomad stop webserver` to stop our webserver.

- After a few seconds, you will see that we have an active alert in the **Alerts** section of the web interface.

![active-alert-cfcc7e45.png](https://www.nomadproject.io/assets/images/active-alert-cfcc7e45.png)

We can now go to the Alertmanager web interface to see that Alertmanager has received this alert as well.

- Since Alertmanager has been configured behind fabio, go to the IP address of any of your client nodes at port `9999` and use `/alertmanager` as the route.
- An example is shown below:

```go
< client node IP >:9999/alertmanager
```

---
# continued
You should see that Alertmanager has received the alert.

![alertmanager-webui-612ce20c.png](https://www.nomadproject.io/assets/images/alertmanager-webui-612ce20c.png ) 

---

# Next Steps

Read more about Prometheus [<u>Alertmanager][46]</u> and how to configure it to send out notifications to a [<u>receiver][47]</u> of your choice.

[1]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#reference-material
[2]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#estimated-time-to-complete
[3]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#challenge
[4]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#solution
[5]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#prerequisites
[6]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#steps
[7]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#next-steps
[8]: https://prometheus.io/docs/introduction/overview/
[9]: https://prometheus.io/docs/alerting/alertmanager/
[10]: https://www.nomadproject.io/docs/configuration/telemetry.html
[11]: https://prometheus.io/docs/alerting/configuration/#%3Creceiver%3E
[12]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#reference-material
[13]: https://prometheus.io/docs/introduction/first_steps/#configuring-prometheus
[14]: https://www.nomadproject.io/docs/configuration/telemetry.html
[15]: https://prometheus.io/docs/alerting/overview/
[16]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#estimated-time-to-complete
[17]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#challenge
[18]: https://prometheus.io/docs/alerting/configuration/#%3Creceiver%3E
[19]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#solution
[20]: https://fabiolb.net/
[21]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#prerequisites
[22]: https://github.com/hashicorp/nomad/tree/master/terraform#provision-a-nomad-cluster-in-the-cloud
[23]: https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
[24]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#steps
[25]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-1-enable-telemetry-on-nomad-servers-and-clients
[26]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-2-create-a-job-for-fabio
[27]: https://learn.hashicorp.com/guides/load-balancing/fabio
[28]: https://www.nomadproject.io/docs/schedulers.html#system
[29]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-3-run-the-fabio-job
[30]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-4-create-a-job-for-prometheus
[31]: https://www.nomadproject.io/docs/job-specification/template.html
[32]: https://www.nomadproject.io/docs/runtime/environment.html
[33]: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#%3Cconsul_sd_config%3E
[34]: https://www.nomadproject.io/docs/drivers/docker.html#volumes
[35]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-5-run-the-prometheus-job
[36]: https://www.nomadproject.io/docs/schedulers.html#system
[37]: https://www.nomadproject.io/docs/configuration/telemetry.html
[38]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-6-deploy-alertmanager
[39]: https://prometheus.io/docs/alerting/alertmanager/
[40]: https://prometheus.io/docs/alerting/configuration/#%3Creceiver%3E
[41]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-7-configure-prometheus-to-integrate-with-alertmanager
[42]: https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
[43]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-8-deploy-web-server
[44]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#step-9-stop-the-web-server
[45]: https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html#next-steps
[46]: https://prometheus.io/docs/alerting/alertmanager/
[47]: https://prometheus.io/docs/alerting/configuration/#%3Creceiver%3E
