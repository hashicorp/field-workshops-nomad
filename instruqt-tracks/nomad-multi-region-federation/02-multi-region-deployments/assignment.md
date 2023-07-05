---
slug: multi-region-deployments
id: fvjoowufjduv
type: challenge
title: Multi-Region Nomad Deployments
teaser: |
  Deploy a Nomad Job Across Two Nomad Regions
notes:
- type: text
  contents: |-
    Federated Nomad clusters are members of the same gossip cluster but not of the same raft/consensus cluster; they don't share their data stores.

    Each `region` in a multi-region deployment gets an independent copy of the job, parameterized with the values of the `region` block. Nomad regions coordinate to rollout each region's deployment using rules determined by the `strategy` block.
- type: text
  contents: |-
    A single region deployment using one of the various update strategies begins in the `running` state and ends in either the `successful` state if it succeeds, the `canceled` state if another deployment supersedes it before it is `complete`, or the `failed` state if it fails for any other reason.

    A `failed` single region deployment may automatically revert to the previous version of the job if its `update` block has the `auto_revert` setting set to `true`.
- type: text
  contents: |-
    In a multi-region deployment, regions begin in the `pending` state. This allows Nomad to determine that all regions have accepted the job before continuing.

    At this point, up to `max_parallel` regions will enter into the `running` state. When each region completes its local deployment, it enters a `blocked` state where it waits until the last region has completed the deployment.

    The final region will unblock the regions to mark them as successful.
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
In this challenge you will deploy a multi-region job. Please read the notes screens that were displayed at the beginning of this challenge for an explanation of multi-region concepts.

Inspect the "/root/nomad/jobs/multi-redis.nomad" job file in the file editor on the "Config Files" tab.

The job will be deployed to both regions. The `max_parallel` field of the `strategy` block of the `multiregion` block restricts Nomad to deploy to the regions one at a time since it is set to `1`. If either of the region deployments fail, both regions will be marked as `failed` since `on_failure` is set to `fail_all`.

The job will deploy to the regions in the the order that they have been defined in the job specification file. Since in this case,`max_parallel` is set to `1`, the job will be deployed to the `west` region before it is deployed to the `east` region regardless of whether the job is started from the west server or the east server.

The count of each task group that has `count = 0` is set to the value of the `count` attribute specified for that task group's region in the `multiregion` block.

The job's `update` block uses the default `task_states` value of the `health_check` attribute to determine if the job is healthy; if you configured a Consul service with health checks you could use that instead.

While you could deploy the job and check its status in both regions from either server, please run all of the following commands on the "Nomad_Server_West" tab, since the check script for this challenge expects them to be run there.
```
nomad job run /root/nomad/jobs/multi-redis.nomad
```
This should return something like this:
```
Job registration successful
Evaluation ID: f8b386d8-ab92-4932-7e9f-1c67403f70ee
```

Immediately watch the job status in the west region with the following command on the "Nomad_Server_West" tab:
```
watch nomad job status -region west example
```

Please focus your attention on the "Multiregion Deployment" section of the output which will change as the deployment proceeds. The west region should initially have the `running` status and the east region should have the `pending` status in that section. Within 30 seconds, you should see an allocation in the west region at the bottom of the output. About 10 seconds after that allocation enters the `running` state, the status for the west region will transition to `blocked` and the east region`s status will change to `running`. Once the east region`s deployment has completed, both regions will transition to the `successful` status. Here is an example of what this looks like during this process:

First you will see something like this:
```
Multiregion Deployment
Region  ID        Status
east    dcd0957d  pending
west    88b4cdf9  running
```

Then you will see something like this:
```
Multiregion Deployment
Region  ID        Status
east    dcd0957d  running
west    88b4cdf9  blocked
```

Finally, you will see something like this:
```
Multiregion Deployment
Region  ID        Status
east    dcd0957d  successful
west    88b4cdf9  successful
```

Type <control\>-c on a Mac or <ctrl\>-c on Windows to terminate the `watch` command.

Finally, double-check that an allocation has been run in the east region by running this command on the "Nomad_Server_West" tab:
```
nomad job status -region east example
```
You should see an allocation for the east region in the "Allocations" section at the bottom of the screen.

You can also check the status of the job and its allocations in the Nomad UI for both clusters. Note that each UI can show all federated Nomad regions, but that it only shows data for one region at a time.

In the next challenge, you will redeploy the multi-region job with some modifications and simulate the failure of one region's deployment.