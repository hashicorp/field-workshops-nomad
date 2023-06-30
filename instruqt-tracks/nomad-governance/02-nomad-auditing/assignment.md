---
slug: nomad-auditing
id: lvayny03n4fy
type: challenge
title: Enable Nomad Enterprise Audit Logging
teaser: |
  Learn how to enable Nomad Enterprise audit logging.
notes:
- type: text
  contents: |-
    In this challenge, you will enable Nomad Enterprise's [Audit Logging](https://www.nomadproject.io/docs/enterprise#audit-logging) on your server and clients, giving Nomad operators complete records about all user-issued actions in Nomad.

    With Nomad audit logging, enterprises can proactively identify access anomalies, ensure enforcement of their security policies, and diagnose cluster behavior by viewing preceding user operations.

    In the next challenge, you will configure Nomad namespaces and resource quotas.
tabs:
- title: Config Files
  type: code
  hostname: nomad-server-1
  path: /root/nomad/
- title: Server
  type: terminal
  hostname: nomad-server-1
- title: Client 1
  type: terminal
  hostname: nomad-client-1
- title: Client 2
  type: terminal
  hostname: nomad-client-2
- title: Client 3
  type: terminal
  hostname: nomad-client-3
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 1200
---
In this challenge, you will enable Nomad Enterprise's audit logging on your server and clients, giving Nomad operators complete records about all user-issued actions in Nomad.

## Enable Audit Loggiong
Start by reviewing the "nomad-server1.hcl", "nomad-client1.hcl", "nomad-client1.hcl", and "nomad-client1.hcl" files on the "Config Files" tab. Notice that the following stanza has been added to the bottom of each file:
```
audit {
  enabled = true
}
```

This stanza is needed on Nomad servers and clients when enabling Nomad Enterprise audit logging. You are looking at copies of the actual files that have been placed in the /etc/nomad.d directory on the server and all 3 clients.

While the above stanza is very short, it actually does more than you might think since Nomad uses the following defaults for audit logging:
```
audit {
  enable = true
  sink "audit" {
    type               = "file"
    delivery_guarantee = "enforced"
    format             = "json"
    path               = "/[data_dir]/audit/audit.log"
  }
}
```
where `[data_dir]` is the data directory specified in the Nomad agent configuration.

In our case, that directory is "/tmp/nomad/server1" for the server, "/tmp/nomad/client1" for nomad-client-1, "/tmp/nomad/client2" for nomad-client-2, and "/tmp/nomad/client3" for nomad-client-3. The audit log for each agent (server or client) is only accessible at this time from the file system on the agent's host.

It is also possible to configure various properties of the sink including:
  * Whether delivery is guaranteed or not.
  * The path of the audit log.
  * Rotation settings.

Note that it is also possible to configure filters to limit which events are actually capture in the audit logs. For instance, you might be less concerned about read operations than write operations.

Restart the Nomad server on the "Server" tab with this command:
```
systemctl restart nomad
```

After waiting 15 seconds, you should restart all 3 of the Nomad clients on the "Client 1", "Client 2", and "Client 3" tabs:
```
systemctl restart nomad
```

## Inspect Audit Logs
Now, you will invoke a few Nomand CLI commands and inspect the associated audit log entries.

Run the following Nomad command to list running jobs on the "Server" tab:
```
nomad job status
```

Now, run the following command to inspect the end of the audit log on the server:
```
cat /tmp/nomad/server1/audit/audit.log | jq .
```
You should see the following OperationReceived log entry:
```
{
  "created_at": <date>,
  "event_type": "audit",
  "payload": {
    "id": <id>,
    "stage": "OperationReceived",
    "type": "audit",
    "timestamp": <timestamp>,
    "version": 1,
    "auth": {
      ...
    },
    "request": {
      "id": <id>,
      "operation": "GET",
      "endpoint": "/v1/jobs",
      "namespace": {
        "id": "default"
      },
      "request_meta": {
        ...
      },
      "node_meta": {
        "ip": "10.132.0.33:4646"
      }
    }
  }
}
```
followed by the OperationComplete log entry:<br>
```
{
  "created_at": <date>,
  "event_type": "audit",
  "payload": {
    "id": <id>,
    "stage": "OperationComplete",
    "type": "audit",
    "timestamp": <timestamp>,
    "version": 1,
    "auth": {
      ...
    },
    "request": {
      "id": <id>,
      "operation": "GET",
      "endpoint": "/v1/jobs",
      "namespace": {
        "id": "default"
      },
      "request_meta": {
        "remote_address": "127.0.0.1:38742",
        "user_agent": "Go-http-client/1.1"
      },
      "node_meta": {
        "ip": "10.132.0.33:4646"
      }
    },
    "response": {
      "status_code": 200
    }
  }
}
```

We have deleted some of the data for formatting reasons.

Next, run `nomad node status` on the "Client 1" tab and then examine the audit log on that tab:
```
cat /tmp/nomad/client1/audit/audit.log | jq .
```
You will again see OperationReceived and OperationComplete log entries.

Feel free throughout this track to inspect the audit logs on the server or any of the clients after running any Nomad commands on them. Or just inspect the audit logs after completing the track.

In the next challenge, you will configure Nomad namespaces and resource quotas.