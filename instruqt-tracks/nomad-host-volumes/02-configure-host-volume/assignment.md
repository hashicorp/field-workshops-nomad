---
slug: configure-host-volume
id: 49myxhxhxunr
type: challenge
title: Configure a Nomad Host Volume
teaser: |
  Configure a Nomad host volume on one client.
notes:
- type: text
  contents: |-
    In this challenge, you will configure a [Nomad Host Volume](https://nomadproject.io/docs/configuration/client/#host_volume-stanza) on one of the Nomad clients, nomad-client-1.

    By configuring the host volume on a single Nomad client, we ensure that Nomad will schedule any task group that wants to use this host volume on the client that has it.
tabs:
- title: Nomad 1 Config
  type: code
  hostname: nomad-client-1
  path: /etc/nomad.d/nomad-client1.hcl
- title: Client 1
  type: terminal
  hostname: nomad-client-1
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 900
---

In this challenge, you will configure a Nomad host volume on one of the Nomad clients, nomad-client-1, to persistently store data from a MySQL database.

Begin by inspecting the new version of the first Nomad client's configuration file, "nomad-client1.hcl" on the "Nomad 1 Config" tab. Alternatively, you could run `cat /etc/nomad.d/nomad-client1.hcl` on the "Client 1" tab.

You will see that the setup script for this challenge has added the following stanza under the `client` stanza:

```nocopy
host_volume "mysql" {
  path      = "/opt/mysql/data"
  read_only = false
}
```

This tells Nomad that it should make a host volume with the name `mysql` on the path "/opt/mysql/data" available to jobs allocations deployed to Nomad Client 1. Setting `read_only` to `false` means that tasks will be able to write data to the host volume.

Note that we are only adding the `host_volume` stanza on Client 1. As a consequence, when a task group of a job indicates that it wants to use the `mysql` host volume, that task group will be deployed to Client 1. This ensures that if we stop and re-run a job, it will still be able to find the data that it had persisted to the host volume.

A host volume with a specific name should only be deployed to one Nomad client unless an external tool is used to replicate data between host volumes with the same name on different clients.

Next, please create the directory needed by the host volume by running this command on the "Client 1" tab:

```bash,run
mkdir -p /opt/mysql/data
```

Restart Nomad Client 1 with this command:

```bash,run
systemctl restart nomad
```

Finally, after waiting about 15 seconds check that the host volume has been loaded by the client:

```bash,run
nomad node status -short -self
```

This will return something like the following:

```nocopy
ID              = 6665b0c4-31e8-0e0c-2ab2-618acae820f2
Name            = client1
Class           = <none>
DC              = dc1
Drain           = false
Eligibility     = eligible
Status          = ready
CSI Controllers = <none>
CSI Drivers     = <none>
Host Volumes    = mysql
CSI Volumes     = <none>
Drivers         = docker,exec
```

Verify that "mysql" is listed in the "Host Volumes" row.

Please visit the Nomad UI, select "Clients" on the left-side menu, select the row with "client1", and scroll down. You will see that the client1 node has the "mysql" host volume listed with source "/opt/mysql/data". (If you don't see the left-side menu, make your browser window wider or hide the Instruqt assignment by clicking the picture frame icon next to the refresh icon to the right of the Nomad UI tab.)

Please record the ID of the "client1" node which is at the top of the current screen next to "Clients". When you run the job that deploys the MySQL database before and after writing data to it, you will be asked to check that the ID of the node to which the job's allocation is deployed matches this ID.

Note that the Nomad UI has a Storage menu on the left-hand menu, but this is for volumes mounted by CSI plugins. So, you will not see your host volume under it.

In the next challenge, you will run a job that deploys a MySQL database that uses the host volume.
