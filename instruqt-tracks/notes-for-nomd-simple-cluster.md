`nomad agent -config server.hcl > nomad.log 2>&1 &`
[1] 2174

`nomad agent -config client1.hcl > nomad.log 2>&1 &`
[1] 2241

`nomad agent -config client2.hcl > nomad.log 2>&1 &`
[1] 2065

`nomad server members`
Name                 Address      Port  Status  Leader  Protocol  Build   Datacenter  Region
server.global  10.132.0.71  4648  alive   true    2         0.10.2  dc1         global

`nomad node status`
ID        DC   Name            Class   Drain  Eligibility  Status
9a7264c1  dc1  client2  <none>  false  eligible     ready
3ab46eb3  dc1  client1  <none>  false  eligible     ready

`nomad job init`
Example job file written to example.nomad

`nomad job run example.nomad`
==> Monitoring evaluation "a92992e6"
    Evaluation triggered by job "example"
    Evaluation within deployment: "9a068215"
    Allocation "a8ae5e06" created: node "3ab46eb3", group "cache"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "a92992e6" finished with status "complete"

`nomad status example`
ID            = example
Name          = example
Submit Date   = 2019-12-23T16:55:09Z
Type          = service
Priority      = 50
Datacenters   = dc1
Status        = running
Periodic      = false
Parameterized = false

Summary
Task Group  Queued  Starting  Running  Failed  Complete  Lost
cache       0       0         1        0       0         0

Latest Deployment
ID          = 9a068215
Status      = running
Description = Deployment is running

Deployed
Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
cache       1        1       0        0          2019-12-23T17:05:09Z

Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created    Modified
a8ae5e06  3ab46eb3  cache       0        run      running  2m46s ago  2m39s ago

`nomad alloc status <alloc>`
ID                  = a8ae5e06-18dc-9ff0-b709-dd7b22e3d8c8
Eval ID             = a92992e6
Name                = example.cache[0]
Node ID             = 3ab46eb3
Node Name           = nomad-client-1
Job ID              = example
Job Version         = 0
Client Status       = running
Client Description  = Tasks are running
Desired Status      = run
Desired Description = <none>
Created             = 4m46s ago
Modified            = 1m46s ago
Deployment ID       = 9a068215
Deployment Health   = unhealthy

Task "redis" is "running"
Task Resources
CPU        Memory           Disk     Addresses
2/500 MHz  984 KiB/256 MiB  300 MiB  db: 10.132.0.67:28145

Task Events:
Started At     = 2019-12-23T16:55:16Z
Finished At    = N/A
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                  Type             Description
2019-12-23T16:58:09Z  Alloc Unhealthy  Task not running for min_healthy_time of 10s by deadline
2019-12-23T16:55:16Z  Started          Task started by client
2019-12-23T16:55:09Z  Driver           Downloading image
2019-12-23T16:55:09Z  Task Setup       Building Task Directory
2019-12-23T16:55:09Z  Received         Task received by client

`nomad alloc logs <alloc> redis`
1:C 23 Dec 16:55:16.733 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 3.2.12 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

1:M 23 Dec 16:55:16.734 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
1:M 23 Dec 16:55:16.734 # Server started, Redis version 3.2.12
1:M 23 Dec 16:55:16.734 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
1:M 23 Dec 16:55:16.734 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
1:M 23 Dec 16:55:16.734 * The server is now ready to accept connections on port 6379


`nomad job stop example`
==> Monitoring evaluation "58518629"
    Evaluation triggered by job "example"
    Evaluation within deployment: "89cae9d1"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "58518629" finished with status "complete"
