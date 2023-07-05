---
slug: simulate-failed-deployment
id: s7jxsy5yhxly
type: challenge
title: Simulate a Failed Deployment in One Region
teaser: |
  Deploy a multi-region job which will simulate a failed deployment in one region.
notes:
- type: text
  contents: |-
    In this challenge you will simulate a failed deployment when deploying a multi-region job.

    For further information, please check out the HashiCorp
    [Learn Guide](https://learn.hashicorp.com/tutorials/nomad/multiregion-deployments) on which this lab was based.
tabs:
- title: Config Files
  type: code
  hostname: nomad-server-1-west
  path: /root/nomad
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
In this challenge you will redeploy the multi-region job with some modifications and simulate the failure of one region's deployment.

Please open the multi-redis.nomad job file on the "Config Files" tab. It has been updated with the addition a new task group called "sidecar".

Change the `multiregion` block's `strategy` block to use  `fail_local` instead of `fail_all` for the `on_failure` parameter. Your modified job file should look like this:
```
strategy {
  max_parallel = 1
  on_failure   = "fail_local"
}
```
Please note the `template` block in the `sidecar` group. The simple script that is passed to the Docker container ensures that the allocation will always fail in the `east` region.

Save the file by clicking the disk icon above it.

Since the version of the file you edited is on the west server, please run the following command on the "Nomad_Server_West" tab as in the last challenge:
```
nomad job run /root/nomad/jobs/multi-redis.nomad
```
This should return something like this:
```
Job registration successful
Evaluation ID: 460ba9a7-21dd-8bd8-f97b-b133899e7a46
```

Check the status of the east region with this command from either server tab:
```
watch nomad job status -region east example
```
As with the previous version of the job, if you focus on the "Multiregion Deployment" section, you should initially see the deployment in the west with the `running` status and the deployment in the east with the `pending` status.

But, after 15-20 seconds, the west region should have the `blocked` status while the east region will have the `running` status.

As noted above, the sidecar task group is intentionally designed to fail in the east region. You will see failed allocations for it at the bottom of the screen. Eventually, the east region's deployment will fail because the sidecar task group fails too many times in it. When you see that, type <control\>-c on a Mac or <ctrl\>-c on Windows to terminate the `watch` command.

Since `on_failure` was set to `fail_local`, the west region actually remains in a `blocked` state. You can see that by running this command:
```
nomad job status -region west example
```
This should show something like this:
```
Multiregion Deployment
Region  ID        Status
east    6ab8ac70  failed
west    6b016109  blocked
```

At this point, you could either fix the job and redeploy or accept the west deployment in its current state. Let's do the latter on the "Nomad_Server_West" tab by running this command:
```
nomad deployment unblock -region west <deployment-id>
```
where <deployment-id\> is the deployment ID returned by the `nomad job status` command for the west region. This should return something like this:
```
Deployment "c259edd6-8fbe-1fba-8a44-9513cdf0ac2c" unblocked
```

Check the status of the west region again:
```
nomad job status -region west example
```
The west region should now have the `successful` status.

Finally, you can stop the multi-region job by using the `-global`option with the `nomad job stop` command. Do that now on the "Nomad_Server_West" tab:
```
nomad job stop -global example
```
This should return something like this:
```
==> Monitoring evaluation "ffd6ba9d"
Evaluation triggered by job "example"
==> Monitoring evaluation "ffd6ba9d"
Evaluation within deployment: "03b4bb7f"
Evaluation status changed: "pending" -> "complete"
==> Evaluation "ffd6ba9d" finished with status "complete"
```
followed by some extra text about the monitoring of the job being stopped.

Congratulations on completing the Nomad Multi-Region Federation track!