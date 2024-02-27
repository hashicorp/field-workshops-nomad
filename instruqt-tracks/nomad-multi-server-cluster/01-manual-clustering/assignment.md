---
slug: manual-clustering
id: dafvdpzgb1gm
type: challenge
title: Bootstrap a Nomad Cluster Manually
teaser: |
  Bootstrap a Nomad cluster with 3 servers and 2 Nomad clients using manual clustering.
notes:
- type: text
  contents: |-
    This track will show you how to bootstrap a Nomad cluster that has three servers and two clients in two different ways. You will also learn how easy it is to register Nomad tasks as Consul services and secure them with Nomad's native integration with [Consul Connect](https://www.nomadproject.io/docs/integrations/consul-connect/).

    In this first challenge, you will bootstrap the Nomad cluster using manual clustering.

    In the next challenge, you will use automatic clustering with Consul.
- type: text
  contents: |-
    We've put all the server and client configuration files on the server1 VM so that you can conveniently see them in a single Instruqt tab.

    However, if you decide to edit any of the configuration files for any reason, be sure to do so on the tab that matches the file you change.
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
- title: Client 1
  type: terminal
  hostname: nomad-client-1
- title: Client 2
  type: terminal
  hostname: nomad-client-2
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 1800
---

In this challenge, you will bootstrap a Nomad cluster with 3 servers and 2 Nomad clients using manual clustering.

Let's start by looking at the `nomad-server1.hcl` configuration file on the "Config Files" tab on the left. You'll see that we are calling this server node `server1`, configuring the agent as a server, and indicating that we expect three servers in the cluster with the `bootstrap_expect` setting.

Next, start server1 in the background on the "Server 1" tab by running:

```bash,run
cd nomad
nomad agent -config nomad-server1.hcl > nomad.log 2>&1 &
```

You should see a single line like `[1] 2174`, which gives the PID of the Nomad server.

We suggest you also tail the nomad.log file by running `tail -f nomad.log`. This will show many messages including one that says "Nomad agent started!". It will also show some error messages saying "No cluster leader". That is expected at this point because we have not yet strated 3 servers.

Now, look at the `nomad-server2.hcl` configuration file on the "Config Files" tab. Note that it is is similar to `nomad-server1.hcl` but has a `server_join` stanza indicating that server2 should repeatedly try to join server1 until it succeeds.

Start the second Nomad server on the "Server 2" tab, specifing `nomad-server2.hcl` as the configuration file:

```bash,run
cd nomad
nomad agent -config nomad-server2.hcl > nomad.log 2>&1 &
```

At this point, if you are still tailing the nomad.log for server1, you should see a message like "nomad: serf: EventMemberJoin: server2.global".

If you look at the `nomad-server3.hcl` configuration file on the "Config Files" tab, you'll see that it also includes a `server_join` stanza indicating that server3 should repeatedly try to join server1 until it succeeds.

Start the third Nomad server on the "Server 3" tab, specifing `nomad-server3.hcl` as the configuration file:

```bash,run
cd nomad
nomad agent -config nomad-server3.hcl > nomad.log 2>&1 &
```

At this point, if you are still tailing the nomad.log for server1, you should see messages indicating that server3 joined the cluster and that server1 has been elected the cluster's leader.

To double-check that all 3 servers have joined the cluster, run this command on the "Server 3" tab:

```bash,run
nomad server members
```

You should see output listing all 3 server nodes, all 3 of which should be considered "alive". server1 should be considered the leader of the cluster.

If clicking the Check button at the end of the challenge says you have not done this, you might have run it on one of the other tabs. Please run it again on the "Server 3" tab so that it will end up in your .bash_history file on the nomad-server-3 VM.

Now, look at the `nomad-client1.hcl` configuration file on the "Config Files" tab. This file indicates that the agent will run as a client node and connect to the `nomad-server-1` server.

Next, run the first Nomad client on the "Client 1" tab:

```bash,run
cd nomad
nomad agent -config nomad-client1.hcl > nomad.log 2>&1 &
```

You should see a single line like `[1] 2241`, which gives the PID of the first client. You can inspect the nomad.log file by running `cat nomad.log`. This will show many messages including one that says "Nomad agent started!"

Now, look at the `nomad-client2.hcl` configuration file on the "Config Files" tab. It is very similar to the `nomad-client1.hcl` file.

Start the second Nomad client on the "Client 2" tab, but specify `nomad-client2.hcl` as the configuration file:

```bash,run
cd nomad
nomad agent -config nomad-client2.hcl > nomad.log 2>&1 &
```

You should see a single line like `[1] 2065`, which gives the PID of the second client. As with the first client, you can inspect the nomad.log file by running `cat nomad.log`.

Check the status of the Nomad client nodes on the "Server 3" tab:

```bash,run
nomad node status
```

You should see two client nodes. (The command only shows client nodes, so the servers are not listed.)

If clicking the Check button at the end of the challenge says you have not done this, you might have run it on one of the other tabs. Please run it again on the "Server 3" tab so that it will end up in your .bash_history file on the nomad-server-3 VM.

You can now inspect the servers and clients in the Nomad UI. You might initially see a "Server Error" message in the UI saying that "A server error prevented data from being sent to the client". Just click on the "Go to Clients" button. You should then see the UI and can inspect the servers and clients that you started.

Of course, you won't see any jobs yet.
