---
slug: stop-and-restart-job
id: n3iyjgwrgm8q
type: challenge
title: Stop and Restart the Database Job
teaser: |
  Stop and restart the job that ran the database and validate that the item you added is still in the database.
notes:
- type: text
  contents: |-
    In this challenge, you will stop and re-run the "mysql-server" job and verify that the item you added is still in the database table.

    When the job is restarted, it will be run on the first Nomad client again because that is the only client that has the "mysql" host volume deployed.
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

In this challenge, you will stop and re-run the "mysql-server" job and verify that the item you added is still in the database table.

First, stop and purge the "mysql-server" job by running the following command on the "Server" tab:

```bash,run
nomad job stop -purge mysql-server
```

The `-purge` option removes the job completely so that it will not show up in the Nomad UI or in any status commands.

After 10 seconds, verify that no jobs are running:

```bash,run
nomad status
```

This should return "No running jobs".

If you refresh the Nomad UI, you can confirm that there are no longer any jobs listed.

Navigate to the /root/nomad directory with this command:

```bash,run
cd /root/nomad
```

Re-run the job with this command:

```bash,run
nomad job run mysql.nomad
```

After waiting 30 seconds, verify that the job has been successfully deployed with this command:

```bash,run
nomad job status mysql-server
```

The Status field in the first section should show that the job is running. You should also see that there is 1 healthy instance of the "mysql-server" task group in the "Deployed" section and that a single allocation is running in the "Allocations" section.

Please inspect the ID of the node that the allocation was deployed to and compare it to the ID of the client1 node that you recorded earlier. They should match. If so, this proves that the "mysql-server" task group was deployed to the same Nomad client (client1) both times that you ran the job.

Finally, connect to the MySQL database by running this command on the "Server" tab:

```bash,run
mysql -h mysql-server.service.consul -u web -ppassword -D itemcollection
```

Then run the same query you ran earlier:

```bash,run
select * from items;
```

You should see the row with "glove" that you added in the last challenge. This proves that the MySQL data written by the "mysql.nomad" job was correctly persisted and is still available to the job after being stopped, purged, and re-run.

Quit MySQL by typing

```bash,run
exit
```

Congratulations on completing the Nomad Host Volumes track.
