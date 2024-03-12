---
slug: verify-agents
type: challenge
title: Verify that the Agents are Running
teaser: |
  Verify that all of the server and client agents are configured and running.
notes:
- type: text
  contents: |-
    <b>Nomad Integration with Vault</b>
    <hr />

    In this track, you are going to explore how [Nomad](https://nomadproject.io) integrates seamlessly with [Vault](https://www.vaultproject.io) and allows your application to retrieve dynamic credentials for a database.

    You will deploy a web application that needs to authenticate against a [PostgreSQL](https://www.postgresql.org/docs) database and display data from a table to the user.
tabs:
- title: Files
  type: code
  hostname: hashistack-server
  path: /root/hashistack/
- title: Server
  type: terminal
  hostname: hashistack-server
- title: Nomad
  type: service
  hostname: hashistack-server
  port: 4646
- title: Consul
  type: service
  hostname: hashistack-server
  port: 8500
- title: Vault
  type: service
  hostname: hashistack-server
  port: 8200
difficulty: basic
timelimit: 1200
---
Before we begin, let's verify that our Nomad, Consul and Vault servers and both clients are running.

Run all the following commands on the "Server" tab.

let's check the Nomad Server by running:
```
nomad server members
```
You should see a message confirming 1 Nomad server is up and running.

Next, check the Nomad client nodes by running:
```
nomad node status
```
You should see two Nomad client nodes.

Now let's check the Consul Server and clients by running:
```
consul members
```
You should see three members, a server and two clients.

Finally let's make sure Vault is up and running:
```
vault status
```
You should see a small table of Keys and Values. The "Sealed" key should be "false" because we have already unsealed it for you.

Our next challenge will be to create the Nomad token policy for Vault.

Click the "Check" button in the lower right to complete the challenge.