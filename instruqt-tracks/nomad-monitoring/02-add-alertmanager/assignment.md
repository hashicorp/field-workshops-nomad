---
slug: add-alertmanager
id: mfn1tpbqydzx
type: challenge
title: Deploy Alertmanager
teaser: |
  Run a Nomad job that deploys Alertmanager to the Nomad cluster.
notes:
- type: text
  contents: |-
    In this challenge, you will deploy the Prometheus [Alertmanager](https://prometheus.io/docs/alerting/alertmanager) to the Nomad cluster.

    You will then modify the `prometheus` job to integrate the Prometheus server with Alertmanager and redeploy Prometheus.
tabs:
- title: Config
  type: code
  hostname: nomad-server
  path: /root/nomad/
- title: Server
  type: terminal
  hostname: nomad-server
- title: Consul UI
  type: service
  hostname: nomad-server
  port: 8500
- title: Nomad UI
  type: service
  hostname: nomad-server
  port: 4646
- title: Fabio UI
  type: service
  hostname: nomad-client-1
  port: 9998
- title: Prometheus1
  type: service
  hostname: nomad-client-1
  port: 9999
difficulty: basic
timelimit: 1800
---

In this challenge, you will deploy the Prometheus Alertmanager to the Nomad cluster and modify the `prometheus` job to integrate the Prometheus server with Alertmanager.

NOTE: Prometheus sends alerts to Alertmanager. Alertmanager sends out notifications to designated receivers.

We have added a tab for the Consul UI for those who would like to see the services registered by Nomad for some of the tasks it starts.

## Run the Alertmanager Job

The `alertmanager` job has already been created for you. Please view the file called `alertmanager.nomad` on the "Config" tab and note the following:

- It defines the job `alertmanager`.
- It includes one task group, `alerting`.
- That task group includes a single task, `alertmanager`.
- That task uses the Docker task driver to run the image `prom/alertmanager:latest`.
- It also registers the task as a service called `alertmanager` with Consul.

Next, run the `alertmanager` job on the "Server" tab:

```bash,run
cd nomad
nomad job run alertmanager.nomad
```

You should see something like this:

```nocopy
==> Monitoring evaluation "a988ec2e"
Evaluation triggered by job "alertmanager"
Evaluation within deployment: "feb7f088"
Allocation "bd0b5024" created: node "72635e92", group "alerting"
Evaluation status changed: "pending" -> "complete"
==> Evaluation "a988ec2e" finished with status "complete"
```

Check the status of the `alertmanager` job on the "Server" tab:

```bash,run
nomad job status alertmanager | grep -A 5 Allocations
```

You should see something like this:

```nocopy
Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created   Modified
bd0b5024  72635e92  alerting    0        run      running  3m8s ago  2m51s ago
```

If you would like to see the full job status, you can leave off the `grep` command.

## Modify and Re-run the Prometheus Job

Please view the job specification file called `prometheus2.nomad` on the "Config" tab. We added a few important sections to this job file that were not in `prometheus1.nomad`:

- We added another template stanza that defines an alerting rule for our web server. Prometheus will send out an alert if it detects the `webserver` service has disappeared. This writes the file `local/webserver_alert.yml` to the client that ends up running the task group.
- We added an `alerting` block as well as a `rule_files` block to make Prometheus aware of Alertmanager and the rule we have defined to our Prometheus configuration file, `local/prometheus.yml`.
- We have configured Prometheus to scrape Alertmanager and our web server in addition to the Nomad metrics that it was already scraping.

Please run the modified `prometheus` job on the "Server" tab.

```bash,run
nomad job run prometheus2.nomad
```

You should see output similar to what you saw when you ran other jobs.

Next, check the status of the `prometheus` job

```bash,run
nomad job status prometheus | grep -A 5 Allocations
```

You should see one `running` allocation and one `complete` allocation. If you would like to see the full job status, you can leave off the `grep` command.
