---
slug: nomad-and-consul-connect
id: pywd2lxhuxkf
type: challenge
title: Nomad's Integration with Consul and Consul Connect
teaser: Run a Nomad job with tasks that find each other using Consul's service discovery
  and communicate securely using Consul Connect.
notes:
- type: text
  contents: |-
    In this challenge, you will run a job that uses Nomad's native integration with Consul. The job's tasks will use Consul's service registration, service discovery, and secure service-to-service communication (using Consul Connect).

    This challenge is based on the [Nomad Consul Connect Example](https://www.nomadproject.io/docs/integrations/consul-connect/) in the Nomad documentation.

    For additional information about Consul Connect, see the [Consul Connect](https://www.consul.io/docs/connect/index.html) documentation.
tabs:
- title: Config Files
  type: code
  hostname: nomad-server-1
  path: /root/nomad/
- title: Server 1
  type: terminal
  hostname: nomad-server-1
- title: Server 2
  type: terminal
  hostname: nomad-server-2
- title: Server 3
  type: terminal
  hostname: nomad-server-3
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
- title: Consul UI
  type: service
  hostname: nomad-server-1
  port: 8500
- title: Dashboard-1
  type: service
  hostname: nomad-client-1
  port: 9002
- title: Dashboard-2
  type: service
  hostname: nomad-client-2
  port: 9002
difficulty: basic
timelimit: 1800
---

In this challenge, you will run a job that uses Nomad's native integrations with Consul and Consul Connect. The job's tasks will use Consul's service registration, service discovery, and secure service-to-service communication (using Consul Connect).

In order to support Consul Connect, Nomad adds a new networking mode for jobs that enables tasks in the same task group to share their networking stack. When Connect is enabled, Nomad launches an Envoy proxy alongside the application in the job file. The proxy (Envoy) provides secure communication with other applications in the Nomad cluster.

First, examine the Nomad job specification file, connect.nomad that we have placed in the /root/nomad directory. You can use the code editor on the "Config Files" tab.

This job specification file defines two task groups:

1. The `api` task group runs a counting service API in a container running the `hashicorpnomad/counter-api` Docker image on port 9001 on the bridge network.
2. The `dashboard` task group runs a web dashboard in a container running the `hashicorpnomad/counter-dashboard` Docker image on port 9002 on the bridge network.

The `api` task group registers itself with Consul as the `count-api` service listening on port 9001. It runs on the bridge network and therefore has an isolated network namespace with an interface bridged to the host it runs on. It does not define any ports in its network because it is only accessible via Consul Connect. The Envoy proxy will automatically route traffic sent to the service using port 9001 to the port inside the network namespace dynamically selected by Nomad.

The `dashboard` task group registers itself with Consul as the `count-dashboard` service. It runs on the bridge network and uses the static forwarded port, 9002, which asks Nomad to use external port 9002 for the service and to forward requests to the same port inside the task group's own network namespace.

With this job, a web browser can connect to the dashboard using `http://<host_ip>:9002`. The dashboard uses Consul Connect to make calls to the api service through a sidecar proxy. The `upstreams` stanza in the `proxy` stanza indicates that the sidecar proxy will listen on port 8080 inside the dashboard task group's network namespace. This means that requests to the dashboard on port 9002 will be forwarded to the sidecar proxy on port 8080.

The `dashboard` task within the `dashboard` task group uses the `COUNTING_SERVICE_URL` environment variable set to `http://${NOMAD_UPSTREAM_ADDR_count_api}`. This uses Nomad's interpolation to tell the dashboard application inside the Docker container what dynamic IP and port to use to talk to the sidecar proxy.

Summarizing, Nomad will automatically deploy two Consul Connect proxies to allow the dashboard web application to communicate securely with the count-api service. Consul Connect tells the dashboard proxy how to find the count-api proxy.

Now, that we've explored the connect.nomad job specification, you can run the job. Please do this on the "Server 1" tab by running:

```bash,run
cd nomad
nomad job run connect.nomad
```

You should see something like this:

```nocopy
==> Monitoring evaluation "fdf1c932"
Evaluation triggered by job "countdash"
Evaluation within deployment: "ab006141"
Allocation "8dff276a" created: node "f94fc4ad", group "api"
Allocation "f4225a5f" created: node "f94fc4ad", group "dashboard"
Evaluation status changed: "pending" -> "complete"
==> Evaluation "fdf1c932" finished with status "complete"
```

Finally, use the dashboard web application on the "Dashboard 1" or the "Dashboard 2" tab. We have exposed tabs for both of the Nomad clients because we don't know in advance which client Nomad will schedule the task groups on.

As you watch the app, you should see the counter climb.

You can also look at the tasks associated with proxies in both the Nomad and the Consul UIs.

Congratulations on completing the Nomad Multi-Server Cluster track!
