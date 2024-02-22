---
slug: verify-nomad-cluster-health
id: 57cynq1an6nw
type: challenge
title: Verify the Health of Your Nomad Cluster
teaser: |
  Verify the health of the Nomad cluster that has been deployed for you.
notes:
- type: text
  contents: |-
    Nomad supports stateful workloads with 3 options:
      * [Nomad Host Volumes](https://nomadproject.io/docs/configuration/client/#host_volume-stanza) that are managed by Nomad and can be used with any Nomad task driver
      * [Docker Volume Drivers](https://docs.docker.com/engine/extend/plugins_volume/#create-a-volumedriver) such as Portworx that are externally managed and can only be used with the Docker task driver
      * [CSI Plugins](https://github.com/container-storage-interface/spec/blob/master/spec.md) that are also externally managed but can be used with any Nomad task driver.

    In this track, you will use Nomad Host Volumes to persist data for a MySQL database.
- type: text
  contents: |-
    In this challenge, you will verify the health of the Nomad cluster that has been deployed for you by the track's setup scripts. This will include checking the health of a Consul cluster that has been set up on the same VMs.

    In later challenges, you will configure a Nomad host volume on one of the Nomad clients, run a MySQL database in a Nomad job that uses it, add some data to the database, stop and purge the job, re-run the job, and verify that the data you added is still present.
tabs:
- title: Server
  type: terminal
  hostname: nomad-server-1
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 1200
---

In this challenge, you will verify the health of the Nomad cluster that has been deployed for you by the track's setup scripts. This will include checking the health of a Consul cluster that has been set up on the same VMs.

The cluster is running 1 Nomad/Consul server and 3 Nomad/Consul clients with Nomad 1.0.0 and Consul 1.9.0.

First, verify that all 4 Consul agents are running and connected to the cluster by running this command on the "Server" tab:

```bash,run
consul members
```

You should see 4 Consul agents with the "alive" status.

Check that the Nomad server is running by running this command on the "Server" tab:

```bash,run
nomad server members
```

You should see 1 Nomad server with the "alive" status.

Check the status of the Nomad client nodes by running this command on the "Server" tab:

```bash,run
nomad node status
```

You should see 3 Nomad clients with the "ready" status.

You can also check the status of the Nomad server and clients in the Nomad and Consul UIs.

In the next challenge, you will configure a Nomad host volume on one of the Nomad clients.
