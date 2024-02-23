---
slug: add-web-server
id: hflnki1syaaa
type: challenge
title: Run and Stop a Web Server and See Alerts
teaser: |
  Deploy a web server to the Nomad cluster, stop it, and see alerts in Prometheus and Alertmanager.
notes:
- type: text
  contents: |-
    In this challenge, you will deploy a web server to the Nomad cluster.

    You will then stop the web server and see alerts generated in Prometheus and Alertmanager from the metrics that Nomad is sending them.

    You will also restart the web server and verify that the alerts are no longer active.
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
- title: Prometheus
  type: service
  hostname: nomad-client-1
  port: 9999
- title: Alertmanager
  type: service
  hostname: nomad-client-1
  path: /alertmanager
  port: 9999
difficulty: basic
timelimit: 1800
---

In this challenge, you will deploy a web server to the Nomad cluster by running the `webserver.nomad` job. You will then stop and restart it to see alerts show up and be cleared in Prometheus.

## Run the Web Server Job

The `webserver` job has already been created for you. Please view the file `webserver.nomad` on the "Config" tab and note the following:

- It defines the job `webserver`.
- It includes one task group, `webserver`.
- That task group includes a single task, `server` that uses the Docker task driver to run the image `hashicorp/demo-prometheus-instrumentation:latest`.
- It also registers the task as a service called `webserver` with Consul.

Next, run the `webserver` job on the "Server" tab:

```bash,run
cd nomad
nomad job run webserver.nomad
```

This will return results similar to what you've seen when running other jobs.

Now, check the status of the `webserver` job on the "Server" tab:

```bash,run
nomad job status webserver | grep -A 5 Allocations
```

This should return something like this:

```nocopy
Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created  Modified
ffbc5b06  72635e92  webserver   0        run      running  1m ago   45s ago
```

If you would like to see the full job status, you can leave off the `grep` command.

## Inspect Prometheus Targets and Alerts

Please do the following steps on the "Prometheus" tab. (Note that we are now only showing one tab for it.)

- Select Status -> Targets.
- You will see `webserver` and `alertmanager` appear in your list of targets.
- To see what this looks like, visit this [page](https://learn.hashicorp.com/img/nomad/operating-nomad/new-targets.png).
- Select the "Alerts" tab of the Prometheus UI.
- Note the alert that we configured for the web server. No alerts are active because our web server is running.
- To see what this looks like, visit this [page](https://learn.hashicorp.com/img/nomad/operating-nomad/alerts.png).

## Stop the Web Server to See Alerts

Next, please stop your webserver on the "Server" tab:

```bash,run
nomad job stop webserver
```

Now, let's see what Prometheus is showing on the "Prometheus" tab.

- Select the "Alerts" tab of the Prometheus UI (even if it is already selected).
- Note that we now have an active "Webserver down" alert.
- To see what this looks like, visit this [page](https://learn.hashicorp.com/img/nomad/operating-nomad/active-alert.png).

Verify that Alertmanager has received this alert as well on the "Alertmanager" tab.

- You should see that Alertmanager has received the alert and is showing it as `alertname="Webserver down"`. (You will probably want to click the rectangular Instruqt icon to temporarily hide this assignment to get the Alertmananger spread out horizontally more.)
- To see what this looks like, visit this [page](https://learn.hashicorp.com/img/nomad/operating-nomad/alertmanager-webui.png).

## Restart the Web Server

Please restart the `webserver` job on the "Server" tab:

```bash,run
nomad job run webserver.nomad
```

Then, go to the "Prometheus" tab and click the "Alerts" menu (even if it is already selected). Note that the "Webserver down" alert is no longer active. (You might have to click the "Alerts" menu a few times.)

Finally, go to the "Alertmanager" tab, click the "Alerts" tab, and verify that Alertmanager has removed the "Webserver down" alert.

Congratulations on completing the Nomad Monitoring track. Well done!
