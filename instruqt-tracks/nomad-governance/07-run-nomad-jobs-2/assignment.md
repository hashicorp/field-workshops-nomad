---
slug: run-nomad-jobs-2
id: xnenoh9wjnmq
type: challenge
title: Run Nomad Jobs Restricted by Resource Quotas
teaser: |
  Learn how Nomad Resource Quotas can prevent some jobs from running all of their desired allocations.
notes:
- type: text
  contents: |-
    In this challenge, you will run some more Nomad jobs and learn how Resource Quotas can prevent some of their allocations from running.

    These are jobs that Nomad ACLs and Sentinel policies would allow to run if the namespaces they target were not already overloaded.

    You will also see that stopping a job in a namespace can allow a queued allocation to be deployed.
tabs:
- title: Config Files
  type: code
  hostname: nomad-server-1
  path: /root/nomad/
- title: Server
  type: terminal
  hostname: nomad-server-1
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 1800
---
In this challenge, you will run some more Nomad jobs and learn how Resource Quotas can prevent some of them from running all of their desired allocations.

Navigate to the /root/nomad/jobs directory by running this command on the "Server" tab:
```
cd /root/nomad/jobs
```

Next, export Alice's Nomad ACL token with this command:
```
export NOMAD_TOKEN=$(cat /root/nomad/acls/alice-token.txt | grep Secret | cut -d' ' -f7)
```

Have Alice inspect the current usage of the "dev" resource quota with this command:
```
nomad quota status dev
```
This will return the following:<br>
`
Name        = dev
Description = dev quota
Limits      = 1
Quota Limits
Region  CPU Usage  Memory Usage  Network Usage
global  0 / 2300   0 / 4100      - / inf
`<br>
which indicates that none of the "dev" resource quota is being used. ("inf" under "Network Usage" stands for infinity and means that there is no limit on network usage in the "dev" resource quota.)

Inspect the "website-dev.nomad" job specification file in the jobs directory on the "Config Files" tab and note that it wants to run a job called "website" in the "dev" namespace. The job consists of "nginx" and "mongodb" task groups that each have one task that would consume 250MHz of CPU and 512MB of memory.

However, the count for each task group is 2, so the job would consume a total of 1,000MHz of CPU and 2,048MB of RAM if Nomad is able to schedule all four tasks. Since there are currently no jobs running in the "dev" namespace and these amounts are lower than the limits of the "dev" resource quota, Nomad should be able to run the entire job.

See if that is true by running the job as Alice with this command:
```
nomad job run website-dev.nomad
```

After about 30 seconds, you should see status indicating that 2 healthy allocations were placed for both of the job's task groups.

You should see 4 allocations running at the bottom. You can also check the status of the "website" job in the "dev" namespace in the Nomad UI after providing a suitable ACL token after selecting the "ACL Tokens" menu; we recommend using Charlie's token from the charlie-token.txt file in the /root/nomad/acls directory.

You'll then need to select the "Jobs" menu and click the Instruqt refresh icon to make the Nomad UI show the namespace selector which will let you select the "dev" namespace. If you click on the "website" job in the "dev" namespace, you will see 4 Desired, Placed, and Healthy allocations.

Check the status of the dev resource quota on the "Server" tab again to see how much of the "dev" resource quota is being used:
```
nomad quota status dev
```
You should now see this:<br>
`
Name        = dev
Description = dev quota
Limits      = 1
Quota Limits
Region  CPU Usage    Memory Usage  Network Usage
global  1000 / 2300  2048 / 4100   40 / inf
`<br>
which exactly matches what we had expected.

Next, inspect the "website-qa.nomad" job specfication on the "Config Files" tab. It is very similar to the "website-dev.nomad" job specification and even uses the same job name, "website", but it targets the "qa" namespace and wants to use 1,024MB of memory for each task. This means it will want to use a total of 4,096MB of memory.

Export Bob's Nomad ACL token with this command:
```
export NOMAD_TOKEN=$(cat /root/nomad/acls/bob-token.txt | grep Secret | cut -d' ' -f7)
```

Then, have Bob check the current usage in the "qa" namespace with this command:
```
nomad quota status qa
```
This will return the following:<br>
`
Name        = qa
Description = qa quota
Limits      = 1
Quota Limits
Region  CPU Usage    Memory Usage  Network Usage
global  500 / 2300  1024 / 4100   20 / inf
`<br>

Since 1,024MB of memory is already being used and the "qa" resource quota limits the "qa" namespace to a total of 4,100MB and the "website-qa.nomad" needs 4,096MB, Nomad clearly cannot schedule all 4 allocations of the job. (There is enough CPU capacity.)

Even so, have Bob try to run it with this command:
```
nomad job run website-qa.nomad
```
This will return something like this:
```
==> Monitoring evaluation "17faede9"
    Evaluation triggered by job "website"
    Evaluation within deployment: "ecfe5ffc"
    Allocation "718aae72" created: node "89683da5", group "nginx"
    Allocation "5452e158" created: node "a9e882e3", group "nginx"
    Allocation "5f7186bd" created: node "a9e882e3", group "mongodb"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "17faede9" finished with status "complete" but failed to place all allocations:
    Task Group "mongodb" (failed to place 2 allocations):
      * Resources exhausted on 1 nodes
      * Dimension "memory" exhausted on 1 nodes
      * Quota limit hit "memory exhausted (5120 needed > 4100 limit)"
    Evaluation "f94e7499" waiting for additional capacity to place remainder

    Deployment "ecfe5ffc" in progress...

    2022-01-20T18:25:02Z
    ID          = ecfe5ffc
    Job ID      = website
    Job Version = 0
    Status      = running
    Description = Deployment is running

    Deployed
    Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
    mongodb     2        1       1        0          2022-01-20T18:32:41Z
    nginx       2        2       2        0          2022-01-20T18:32:40Z
```

Note that the Nomad failed to place 2 allocations because the running job and the four allocations of the new job would need a total of 5,120MB which is greater than the 4,096MB limit of the "qa" resource quota. (Sometimes, the message might say Nomad failed to place 1 allocation; and if you inspect the job in the Nomad UI, you might actually see 3 allocations running.)

You can also select the "qa" namespace in the Nomad UI, select the "website" in it, and confirm that only 3 of the 4 allocations of the "website" job are running while 1 of them is queued. The fact that the allocation is currently queued rather than failed is important; this means that it could still be deployed if extra memory became available within the "qa" namespace or if the memory limit of the "qa" resource quota were increased.

To see this actually happen, type `<ctrl>-c` to exit the monitor that the `nomad job run` command started and stop the "webserver-test" job by running this command on the "Server" tab:
```
nomad job stop -namespace=qa webserver-test
```
Then quickly switch back to the Nomad UI. Over the next 15-30 seconds, you should see the "Placed" number and then the "Healthy" number both change to 4, showing that Nomad completed the deployment of the "website" job in the "qa" namespace after extra memory was made available by stopping the "webserver-test" job in the same namespace.

Recall from the first challenge that the total capacity of the 3 Nomad clients in your cluster is 11.25GB of memory and 6,900MHz of CPU capacity. So, your cluster ostensibly has enough memory on the 3 Nomad clients to run both the "website" and the "webserver-test" jobs in the "qa" namespace along with the "website" job in the "dev" namespace and the "catalogue" job in the "default" namespace.

However, it is important to keep in mind that some memory and CPU capacity is needed by the OS and the Nomad client itself on each of the 3 Nomad clients. So, if Nomad had allowed the QA team to run both the "website" and "webserver-test" jobs in the "qa" namespace, the Dev team might have been adversely affected if they had later tried to run some other jobs.

Finally, to see the status of the website jobs in both the Dev and the QA namespaces, run these command:
```
export NOMAD_TOKEN=$(cat /root/nomad/acls/bootstrap.txt | grep Secret | cut -d' ' -f7)
nomad job status -namespace=* website
```
This uses Nomad Enterprise's [Cross-Namespace Queries](https://www.nomadproject.io/docs/enterprise#cross-namespace-queries) feature.

It should return data like this:
```
Prefix matched multiple jobs

ID       Namespace  Type     Priority  Status   Submit Date
website  dev        service  40        running  2020-07-24T03:10:34Z
website  qa         service  50        running  2020-07-24T03:11:55Z
```
Cross-namespace queries like this allow Nomad operators to quickly do queries across multiple namespaces and then run other namespace-specific queries to get more details.

Note that using `*` in a cross-namespace query will only return data from namespaces that the current ACL token has access to. That is why we first exported the bootstrap token.

In this challenge, you saw how resource quotas can prevent jobs that violate them from running all of their desired allocations. You also saw that stopping a job in a namespace can allow a queued allocation to be deployed.

Congratulatons on completing the Nomad Enterprise Governance track!