---
slug: verify-nomad-cluster-health
id: yoyb5xrvcdpz
type: challenge
title: Verify the Health of Your Nomad Enterprise Cluster
teaser: |
  Verify the health of the Nomad Enterprise cluster that has been deployed for you.
notes:
- type: text
  contents: |-
    In this challenge, you will verify the health of the Nomad Enterprise cluster that has been deployed for you by the track's setup scripts. This will include checking the health of a Consul cluster that has been set up on the same VMs.

    In later challenges, you will enable Nomad Enterprise's [Audit Logging](https://www.nomadproject.io/docs/enterprise#audit-logging) and define Nomad [Namespaces](https://learn.hashicorp.com/tutorials/nomad/namespaces), [Resource Quotas](https://learn.hashicorp.com/tutorials/nomad/quotas), [Nomad ACLs](https://learn.hashicorp.com/tutorials/nomad/access-control), and [Sentinel Policies](https://learn.hashicorp.com/tutorials/nomad/sentinel).

    You will then run jobs and learn how Sentinel policies and resource quotas restrict them. You'll also run a [Cross-Namespace Query](https://www.nomadproject.io/docs/enterprise#cross-namespace-queries)
tabs:
- title: Config Files
  type: code
  hostname: nomad-server-1
  path: /root/nomad/
- title: Server
  type: terminal
  hostname: nomad-server-1
- title: Client 1
  type: terminal
  hostname: nomad-client-1
- title: Client 2
  type: terminal
  hostname: nomad-client-2
- title: Client 3
  type: terminal
  hostname: nomad-client-3
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 1200
---
In this challenge, you will verify the health of the Nomad Enterprise cluster that has been deployed for you by the track's setup scripts. This will include checking the health of a Consul cluster that has been set up on the same VMs.

The cluster is running 1 Nomad/Consul server and 3 Nomad/Consul clients. Each of these has 3.75GB of memory and 1 virtual CPU with 2,300MHz of CPU capacity. This means that the total capacity of the 3 Nomad clients is 11.25GB of memory and 6,900MHz of CPU capacity.

The cluster is using Nomad 1.0.0 and Consul 1.9.0.

First, verify that all 4 Consul agents are running and connected to the cluster by running this command on the "Server" tab:
```
consul members
```
You should see 4 Consul agents.

Check that the Nomad server is running by running this command on the "Server" tab:
```
nomad server members
```
You should see 1 Nomad server.

Check the status of the Nomad client nodes by running this command on the "Server" tab:
```
nomad node status
```
You should see 3 Nomad clients.

In the next challenge, you will enable Nomad Enterprise's audit logging.