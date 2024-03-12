---
slug: deploy-a-database
type: challenge
title: Deploy a Database
teaser: |
  Deploy a PostgreSQL database with Nomad.
notes:
- type: text
  contents: |-
    <b>Deploy a Database with Nomad</b>
    <hr />

    The next few steps will involve configuring a connection between Vault and our database, so let's deploy one that we can connect to.
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
A Nomad job has been created for you to deploy a PostgreSQL database. Click on the "Files" tab and navigate to the "/root/hashistack/nomad/db.nomad" file to see the details of the job.

We are deploying a pre-populated PostgreSQL database docker container to either client. We are mapping the container port 5432 to a static port 5432 on the host.

Click on the "Server" tab and run the job using the following command:
```
nomad run /root/hashistack/nomad/db.nomad
```
After waiting about 30 seconds, verify the job is running with the following command:
```
nomad status database
```
You should see a summary of the database job that shows its status as "running". If it is not running, wait 15 seconds and re-run the command. Eventually, the "db" task group should have 1 healthy allocation. You can also explore the job details in the Nomad UI on the "Nomad" tab.

Our next challenge will be to configure the Vault Database Secrets Engine.

Click the "Check" button in the lower right to complete the challenge.