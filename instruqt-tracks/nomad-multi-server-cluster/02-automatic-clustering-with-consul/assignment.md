---
slug: automatic-clustering-with-consul
id: o5nsu90zjf0a
type: challenge
title: Bootstrap a Nomad Cluster with Consul
teaser: Bootstrap a Nomad Cluster with 3 servers and 2 Nomad clients using automated
  clustering with Consul.
notes:
- type: text
  contents: |-
    In this challenge, you will bootstrap the Nomad cluster using automatic clustering with Consul.

    The setup scripts for this challenge have stopped the Nomad processes that were running in the first challenge, deleted their data, updated the Nomad configuration files, and added Consul configuration files.

    We are running the Consul servers on the same VMs as the Nomad servers.
- type: text
  contents: |-
    We've put all the Consul and Nomad server and client configuration files on the server1 VM so that you can conveniently see them in a single Instruqt tab.

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

In this challenge, you will configure and run a Nomad cluster using automated clustering with Consul.

Let's start by looking at the `consul-server1.json` configuration file on the "Config Files" tab on the left. This file indicates that the Consul agent will run as a server on this VM and bind to the `ens4` network interface. Additionally, it expects a total of 3 Consul servers to run and will repeatedly try to join to the Consul servers running on the `nomad-server-2` and `nomad-server-3` VMs.

We have also enabled Consul Connect since we will use it in the next challenge and set the GRPC port to 8502 as required by Consul Connect.

Next, start the `server1` Consul server in the background on the "Server 1" tab by running:

```bash,run
cd nomad
consul agent -config-file consul-server1.json > consul.log 2>&1 &
```

You should see a single line like `[1] 3194`, which gives the PID of the Consul server.

Now look at the `consul-server2.json` configuration file on the "Config Files" tab on the left. This file is very similar to `consul-server1.json` but will make the the second Consul server repeatedly try to join to the Consul servers running on the `nomad-server-1` and `nomad-server-3` VMs.

Next, start the `server2` Consul server in the background on the "Server 2" tab by running:

```bash,run
cd nomad
consul agent -config-file consul-server2.json > consul.log 2>&1 &
```

You should see a single line like `[1] 3196`, which gives the PID of the Consul server.

Now look at the `consul-server3.json` configuration file on the "Config Files" tab on the left. This file is very similar to `consul-server1.json` but will make the the third Consul server repeatedly try to join to the Consul servers running on the `nomad-server-1` and `nomad-server-2` VMs.

Next, start the `server3` Consul server in the background on the "Server 3" tab by running:

```bash,run
cd nomad
consul agent -config-file consul-server3.json > consul.log 2>&1 &
```

You should see a single line like `[1] 3198`, which gives the PID of the Consul server.

Now look at the `consul-client1.json` configuration file on the "Config Files" tab on the left. This file is very similar to `consul-server1.json` but does not include the `server` stanza and will make the the Consul client repeatedly try to join to all 3 Consul servers.

Next, start the `client1` Consul client in the background on the "Client 1" tab by running:

```bash,run
cd nomad
consul agent -config-file consul-client1.json > consul.log 2>&1 &
```

You should see a single line like `[1] 3198`, which gives the PID of the Consul client.

If you look at the `consul-client2.json` configuration file on the "Config Files" tab, you will see that is very similar to the `consul-client1` file.

Start the `client2` Consul client in the background on the "Client 2" tab by running:

```bash,run
cd nomad
consul agent -config-file consul-client2.json > consul.log 2>&1 &
```

You should see a single line like `[1] 3198`, which gives the PID of the Consul client.

Next, verify that all 5 Consul agents are running and connected to the cluster by running the following command on the "Server 3" tab:

```bash,run
consul members
```

You should see 3 servers and 2 clients listed. All should be "alive".

Now that the Consul cluster is running, we can move on to restarting the Nomad agents.

First, look at the `nomad-server1.hcl` configuration file on the "Config Files" tab on the left. This file is the same as it was for the last challenge.

Next, start the `server1` Nomad server in the background on the "Server 1" tab by running:

```bash,run
nomad agent -config nomad-server1.hcl > nomad.log 2>&1 &
```

You should see a single line like `[1] 2174`, which gives the PID of the Nomad server.

We suggest you also tail the nomad.log file by running `tail -f nomad.log`. This will show many messages including one that says "Nomad agent started!". It will also show some error messages saying "No cluster leader". That is expected at this point because we have not yet strated 3 servers. Note that depending on how quickly this command was run, the "Noamd agent started" entry may have already scrolled.

Now look at the `nomad-server2.hcl` configuration file on the "Config Files" tab. Note that it no longer has the `server_join` stanza that it had in the last challenge; it is no longer needed since the Nomad agents will automatically register themselves with Consul and discover each other.

Start the second Nomad server on the "Server 2" tab, specifing `nomad-server2.hcl` as the configuration file:

```bash,run
nomad agent -config nomad-server2.hcl > nomad.log 2>&1 &
```

At this point, if you are still tailing the nomad.log for server1, you should see a message like "nomad: serf: EventMemberJoin: server2.global".

If you look at the `nomad-server3.hcl` configuration file on the "Config Files" tab, you'll see that we have also removed the `server_join` stanza from it.

Start the third Nomad server on the "Server 3" tab, specifing `nomad-server3.hcl` as the configuration file:

```bash,run
nomad agent -config nomad-server3.hcl > nomad.log 2>&1 &
```

At this point, if you are still tailing the nomad.log for server1, you should see messages indicating that server3 joined the cluster and that server1 has been elected the cluster's leader.

To double-check that all 3 servers have joined the cluster, run this command on the "Server 3" tab:

```bash,run
nomad server members
```

You should see output listing all 3 server nodes, all 3 of which should be considered "alive", and server1 should be considered the leader of the cluster.

If clicking the Check button at the end of the challenge says you have not done this, you might have run it on one of the other tabs. Please run it again on the "Server 3" tab so that it will end up in your .bash_history file on the nomad-server-3 VM.

Now look at the `nomad-client1.hcl` configuration file on the "Config Files" tab. This file indicates that the agent will run as a client node. Similar to the server nodes, the connection to the servers is facilitated by Consul.

Next, run the first Nomad client on the "Client 1" tab:

```bash,run
nomad agent -config nomad-client1.hcl > nomad.log 2>&1 &
```

You should see a single line like `[1] 2241`, which gives the PID of the first client. You can inspect the nomad.log file by running `cat nomad.log`. This will show many messages including one that says "Nomad agent started!"

Now look at the `nomad-client2.hcl` configuration file on the "Config Files" tab. It is very similar to the `nomad-client1.hcl` file.

Start the second Nomad client on the "Client 2" tab, but specify `nomad-client2.hcl` as the configuration file:

```bash,run
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

Of course, you won't see any jobs yet. You will start one that uses Consul for service discovery and secure communication in the next challenge.
