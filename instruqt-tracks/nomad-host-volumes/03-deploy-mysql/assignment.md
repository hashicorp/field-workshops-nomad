---
slug: deploy-mysql
id: emokaatynnav
type: challenge
title: Deploy a MySQL Database
teaser: |
  Run a Nomad job that deploys a MySQL database.
notes:
- type: text
  contents: |-
    In this challenge, you will run a Nomad job that deploys a MySQL database that uses the host volume you configured in the last challenge.

    You will learn how to give a task group in a job access to a specific host volume and how to expose the host volume to tasks.
tabs:
- title: Nomad Job
  type: code
  hostname: nomad-server-1
  path: /root/nomad/mysql.nomad
- title: Server
  type: terminal
  hostname: nomad-server-1
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

In this challenge, you will run a Nomad job that deploys a MySQL database that uses the host volume you configured in the last challenge.

Begin by inspecting the "mysql.nomad" job specification file on the "Nomad Job" tab. Alternatively, you could run `cat /root/nomad/mysql.nomad` on the "Server" tab.

Note that the task group, "mysql-server", includes the following [volume](https://nomadproject.io/docs/job-specification/volume/) stanza:

```nocopy
volume "mysql_volume" {
  type      = "host"
  read_only = false
  source    = "mysql"
}
```

Setting the `type` to "host" and `source` to "mysql" tells Nomad that the task group wants to use a host volume called "mysql". (The other choice for `type` is "csi" which indicates that a CSI plugin should be used.)

As mentioned in the previous challenge, Nomad will deploy the "mysql-server" task group to Nomad Client 1 since that is the only client that has mounted the "mysql" host volume.

The job's "mysql-server" task includes the following [volume_mount](https://nomadproject.io/docs/job-specification/volume_mount/) stanza:

```nocopy
volume_mount {
  volume      = "mysql_volume"
  destination = "/var/lib/mysql"
  read_only   = false
}
```

Setting `volume` to "mysql_volume" tells Nomad that the task wants to use the volume "mysql_volume" that the job added to the task's task group.

Additionally, the `destination` parameter tells Nomad to mount the host volume on the path "/var/lib/mysql" inside the task's allocation (which in this case means inside the Docker container running MySQL). Note that this path is different from the path of the host volume on the Nomad client itself which is "/opt/mysql/data".

Setting `read_only` to `false` allows the task to write to the host volume. Note that some tasks might be allowed to write data while other tasks might only be allowed to read data from a particular host volume. However, if a host volume had its `read_only` parameter set to `true`, then no tasks could write to it.

Next, navigate to the root/nomad directory by running this command on the "Server" tab:

```bash,run
cd /root/nomad
```

Now, please run the "mysql.nomad" job by running this command on the "Server" tab:

```bash,run
nomad job run mysql.nomad
```

After waiting about 15 seconds, please check the status of the job on the "Server" tab with this command:

```bash,run
nomad job status mysql-server
```

The Status field in the first section should show that the job is running. You should also see that there is 1 healthy instance of the "mysql-server" task group in the "Deployed" section and that a single allocation is running in the "Allocations" section.

Please inspect the ID of the node that the allocation was deployed to and compare it to the ID of the client1 node that you recorded earlier. They should match. (If you forgot to record the ID of the client1 node, you can visit the Clients section of the Nomad UI again.)

You can also check the status of the job in the Nomad UI, but you might need to click the Instruqt refresh icon after selecting that tab. You should see a single running allocation with a single task.

If you click on the "mysql-server" task group of the job in the UI and scroll down, you will see a "Volume Requirements" section which shows that the "mysql_volume" with source "mysql" is required and has permissions "Read/Write".

If you click on the allocation, click on the "mysql-server" task, and scroll down, you will see that the "mysql_volume" volume is exposed on the destination, "var/lib/mysql".

Finally, you should check that data has been written to the /opt/mysql/data on the "Client 1" tab with this command:

```bash,run
ls /opt/mysql/data
```

You should see various files listed in what had been an empty directory.

In the next challenge, you will write some data to the MySQL database.
