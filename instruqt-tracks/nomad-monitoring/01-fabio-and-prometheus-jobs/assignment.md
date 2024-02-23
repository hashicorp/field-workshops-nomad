---
slug: fabio-and-prometheus-jobs
id: xnbllzec15sa
type: challenge
title: Deploy Fabio and Prometheus
teaser: |
  Run Nomad jobs that deploy Fabio and Prometheus to the Nomad cluster.
notes:
- type: text
  contents: |-
    The Nomad client and server agents collect runtime [telemetry](https://www.nomadproject.io/docs/telemetry/index.html). Operators can use this data to gain real-time visibility into their Nomad clusters and improve performance.

    Additionally, Nomad operators can set up monitoring and alerting against these metrics and export the metrics to tools like Prometheus, Grafana, Graphite, DataDog, and Circonus.

    This track will guide you through implementing the [Using Prometheus to Monitor Nomad Metrics](https://learn.hashicorp.com/tutorials/nomad/prometheus-metrics) guide.
- type: text
  contents: |-
    The setup scripts for this track have configured 4 VMs running Nomad and Consul agents. One is functioning as a server while the other 3 are functioning as clients, both with regard to Nomad and to Consul.

    We've put all the server and client configuration files and job specification files on the nomad-server VM so that you can conveniently see them in a single Instruqt tab.
- type: text
  contents: |-
    In this challenge, you will first run a job that deploys the reverse proxy server [Fabio](https://fabiolb.net) that uses [Consul](https://www.consul.io).

    You will then run a job that deploys [Prometheus](https://prometheus.io/docs/introduction/overview), an open-source systems monitoring and alerting tool.
tabs:
- title: Config
  type: code
  hostname: nomad-server
  path: /root/nomad/
- title: Server
  type: terminal
  hostname: nomad-server
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
- title: Prometheus2
  type: service
  hostname: nomad-client-2
  port: 9999
- title: Prometheus3
  type: service
  hostname: nomad-client-3
  port: 9999
difficulty: basic
timelimit: 1800
---

In this challenge, you will run jobs that deploy Fabio and Prometheus to the Nomad cluster.

That's right: We'll be monitoring Nomad with an application (Prometheus) deployed by Nomad to the Nomad cluster!

First check that the Nomad and Consul agents were deployed properly by running these commands on the "Server" tab:

```bash,run
consul members
nomad server members
nomad node status
```

The first should show 4 Consul agents, the second should show 1 Nomad server, and the third should show 3 Nomad clients.

## Run the Fabio Job

The job file, `fabio.nomad`, for Fabio has been created for you. Please inspect it on the "Config" tab and note the following:

- It defines the system job `fabio`.
- It includes one task group, `fabio`.
- That task group includes a single task, `fabio` that uses the Docker task driver to run the image `fabiolb/fabio`.

Please run the Fabio job on the "Server" tab.

```bash,run
cd nomad
nomad job run fabio.nomad
```

This should return something like this:

```nocopy
==> Monitoring evaluation "69d46d05"
Evaluation triggered by job "fabio"
Allocation "119ebcfe" created: node "ce92fbb1", group "fabio"
Allocation "4fae262f" created: node "3800d575", group "fabio"
Allocation "4febc9ef" created: node "da58f06c", group "fabio"
Evaluation status changed: "pending" -> "complete"
==> Evaluation "69d46d05" finished with status "complete"
```

Verify that the `fabio` job is running on 3 nodes:

```bash,run
nomad job status fabio | grep -A 5 Allocations
```

This should return something like this:

```nocopy
Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created     Modified
119ebcfe  ce92fbb1  fabio       0        run      running  19m23s ago  19m20s ago
4fae262f  3800d575  fabio       0        run      running  19m23s ago  19m20s ago
4febc9ef  da58f06c  fabio       0        run      running  19m23s ago  19m20s ago
```

If you would like to see the full job status, you can leave off the `grep` command.

## Visit the Fabio UI

- Click on the "**Fabio**" tab. This connects to the first Nomad client on port `9998` and shows the fabio UI.
- The Fabio UI is available on all the Nomad clients, but we only exposed a tab for the first one.
- The Fabio routing table will be empty. We have not deployed anything that fabio can route to yet.

## Run the Prometheus Job

The setup script for the server has deployed two versions of a job specification file that runs Prometheus, `prometheus1.nomad` and `prometheus2.nomad`, both of which specify the job name as `prometheus`. You'll use the first file in this challenge and use the second one in the next two challenges.

Please inspect the `prometheus1.nomad` job specification file on the "Config" tab now and note the following:

- It defines the job `prometheus`.
- It includes one task group, `monitoring`.
- That task group includes a single task, `prometheus`.
- That task uses the Docker task driver to run the image `prom/prometheus:latest` and uses a template to write out a file called `local/prometheus.yml` to the client that ends up running the task group.
- It also registers the task as a service called `prometheus` with Consul.

Please run the `prometheus1.nomad` job now on the "Server" tab:

```bash,run
nomad job run prometheus1.nomad
```

This should return something like this:

```nocopy
==> Monitoring evaluation "bdef8e9d"
Evaluation triggered by job "prometheus"
Evaluation within deployment: "4d2a259d"
Allocation "02ef03c9" created: node "da58f06c", group "monitoring"
Evaluation status changed: "pending" -> "complete"
==> Evaluation "bdef8e9d" finished with status "complete"
```

Verify that the `prometheus` job is running on 1 node:

```bash,run
nomad job status prometheus | grep -A 5 Allocations
```

This should return something like this:

```nocopy
Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created     Modified
02ef03c9  da58f06c  monitoring  0        run      running  12m54s ago  12m34s ago
```

If you would like to see the full job status, you can leave off the `grep` command.

## Visit the Prometheus UI

- Connect to the Prometheus UI on any of the Nomad clients (using tabs "Prometheus1", "Prometheus2", or "Prometheus3").
- There is only one instance of Prometheus running, but fabio routes you to the correct node.
- You might need to click the refresh icon (top right).

Use Prometheus to query how many jobs are running on your Nomad cluster in the Prometheus UI.

- Type `nomad_nomad_job_summary_running` into the query field and press your <return\> key.
- Click the "Execute" button.
- Note that you can click the rectangular icon next to the refresh icon to hide and redisplay the assignment in order to see the results more easily.
- The value of the `fabio` job is `3` since it is using the [system](https://www.nomadproject.io/docs/schedulers.html#system) scheduler type and we are running three Nomad clients in our demo cluster.
- The value of our `prometheus` job is `1` since we only deployed one instance of it.
- To see what this looks like, visit this [page](https://learn.hashicorp.com/img/nomad/operating-nomad/running-jobs.png).
- To see the description of other metrics, visit the [telemetry](https://www.nomadproject.io/docs/configuration/telemetry.html) section of the Nomad documentation.

If you go back to the "Fabio" tab and click the Instruqt refresh icon, you will now see the "prometheus" service in the routing table. (Note that you cannot visit it using the URL in the "Dest" column because Instruqt will not allow access to the Prometheus UI on the "Fabio" tab.)

In the next challenge, you will deploy the Prometheus Alertmanager to the Nomad cluster and modify the `prometheus` job to integrate the Prometheus server with Alertmanager.
