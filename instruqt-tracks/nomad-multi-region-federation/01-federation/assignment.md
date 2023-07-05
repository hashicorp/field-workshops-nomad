---
slug: federation
id: dzxndvx3dmex
type: challenge
title: Federate Two Nomad Clusters
teaser: |
  Nomad 0.12 introduced a breakthrough Multi-Cluster Deployment feature, which makes Nomad the first and only orchestrator on the market with complete and fully-supported federation capabilities for production.
notes:
- type: text
  contents: |-
    Nomad 0.12 introduced a breakthrough Multi-Cluster Deployment feature, which makes Nomad the first and only orchestrator on the market with complete and fully-supported federation capabilities for production.

    In this challenge you will federate two Nomad Clusters which will enable you to submit jobs or interact with the Nomad API, targeting any region, from any server, even if that server resides in a different region.
tabs:
- title: Config Files
  type: code
  hostname: nomad-server-1-west
  path: /root/nomad/
- title: Nomad_Server_West
  type: terminal
  hostname: nomad-server-1-west
- title: Nomad_Server_East
  type: terminal
  hostname: nomad-server-1-east
- title: Nomad_UI_West
  type: service
  hostname: nomad-server-1-west
  port: 4646
- title: Nomad_UI_East
  type: service
  hostname: nomad-server-1-east
  port: 4646
difficulty: basic
timelimit: 1800
---
The setup scripts of this track have already deployed two Nomad clusters for you in GCP. One is designated as the "west" region/cluster while the other is designated as the "east" region/cluster. They each have one server and two clients running Nomad 1.0.0 and Consul 1.9.0.

You'll have a total of 5 tabs in all 3 challenges of this track:
  * The "Config Files" tab will let you view the Nomad and Consul configuration files and edit a job specification file.
  * The "Nomad_Server_West" and "Nomad_Server_East" tabs will let you run Nomad CLI commands on both servers.
  * The "Nomad_UI_West" and "Nomad_UI_East" tabs will let you view the Nomad UI from either server.

Start by verifying the health of the nomad cients with this command on the "Nomad_Server_West" and "Nomad_Server_East" tabs:
```
nomad node status
```
This command should return two nodes in each region. If it does not, wait 15-30 seconds and try it again.

Then check the status of the servers in each region with this command:
```
nomad server members
```

On the "Nomad_Server_East" tab, federate the two regions by using the server join command:
```
nomad server join <nomad-server-west-ip>:4648
```
replacing <nomad-server-west-ip\> with the IP of the server in the West region. This should return "Joined 1 servers successfully".

Verify that the clusters have been federated by running the following command on both server tabs:
```
nomad server members
```
The output of the command in each region should show the servers from both regions. Note, however, that if you run `nomad node status` in either cluster, you will only see the Nomad agent nodes for that cluster.

From the Nomad cluster in the west region, run the `nomad status` command to check the status of jobs in the east region. (You should see no running jobs at this point)
```
nomad status -region=east
```
You are also able to run `nomad status -region=west` from the east server. As you can see, Nomad regions are addressable from other regions, a key value of federation. Allowing control over many clusters from a single point of access ensures a holistic view and easier management of all your Nomad clusters.

You can also check the status of the servers and clients in the Nomad UI for both clusters.

In the next challenge, you will run a multi-region job.