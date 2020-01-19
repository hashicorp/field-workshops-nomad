name: extra-credit-lab-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad OSS Workshop
## Extra Credit Lab: Monitoring Nomad

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* Concluding slides

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: monitoring-nomad-with-prometheus
# Monitoring Nomad With Prometheus
* The Nomad client and server agents collect runtime [telemetry](https://www.nomadproject.io/docs/telemetry/index.html).
* Operators can use this data to gain real-time visibility into their Nomad clusters and improve performance.
* The metrics can be exported to tools like Prometheus, Grafana, Graphite, DataDog, and Circonus.

???
* We have an extra credit lab for those who finish the other labs early

---
name: monitoring-nomad-with-prometheus-lab
class: compact
# 👩‍💻 Monitoring Nomad With Prometheus Lab
* This track will guide you through implementing the [Using Prometheus to Monitor Nomad Metrics](https://www.nomadproject.io/guides/operations/monitoring-and-alerting/prometheus-metrics.html) guide.
* In the lab, you will do the following with Nomad:
  * Deploy [Fabio](https://fabiolb.net) and [Prometheus](https://prometheus.io/docs/introduction/overview) to a Nomad cluster.
  * Deploy the Prometheus [Alertmanager](https://prometheus.io/docs/alerting/alertmanager) to the cluster
  * Deploy a web server to the Nomad cluster, stop it, and see alerts generated in Prometheus and Alertmanager.
* You'll do all this in the "Nomad Monitoring" Instruqt track:
https://instruqt.com/hashicorp/tracks/nomad-monitoring

???
* We have an extra credit lab for those who finish the other labs early
