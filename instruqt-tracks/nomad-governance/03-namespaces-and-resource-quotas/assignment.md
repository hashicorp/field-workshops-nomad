---
slug: namespaces-and-resource-quotas
id: htwquippdfjj
type: challenge
title: Configure Nomad Namespaces and Resource Quotas
teaser: |
  Configure Default, Dev, and QA Nomad namespaces and resource quotas
notes:
- type: text
  contents: |-
    In this challenge, you will create "default", "dev", and "qa" resource quotas.

    You will then apply the "default" resource quota to the pre-existing "default" namespace, and create the "dev" and "qa" namespaces. You will apply the "dev" and "qa" resource quotas to the corresponding namespaces when creating them.
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
timelimit: 1200
---
In this challenge, you will configure Default, Dev, and QA Nomad namespaces and resource quotas.

Start by inspecting the "quota-default.hcl", "quota-dev.hcl", and "quota-qa.hcl" resource quota specifications in the quotas directory on the "Config Files" tab. These are written in the HashiCorp Configuration Language (HCL). The first sets global limits of 2,300 MHz of CPU capacity and 3,100 MB of memory while the others set global limits of 2,300 MHz of CPU capacity and 4,100 MB of memory.

The resource quota specification files are all in the /root/nomad/quotas directory, so please navigate to it with this command:
```
cd /root/nomad/quotas
```

Next, create the "default" resource quota by running this command on the "Server" tab:
```
nomad quota apply quota-default.hcl
```
This should return 'Successfully applied quota specification "default"!'.

Now create the "dev" resource quota by running this command on the "Server" tab:
```
nomad quota apply quota-dev.hcl
```
This should return 'Successfully applied quota specification "dev"!'.

Then create the "qa" resource quota by running this command on the "Server" tab:
```
nomad quota apply quota-qa.hcl
```
This should return 'Successfully applied quota specification "qa"!'.

Now that you've created the resource quotas, you can apply the "default" resource quota to the pre-existing "default" namespace and create the "dev" and "qa" namespaces. You will apply the "dev" and "qa" resource quotas to the corresponding namespaces when creating them.

Apply the "default" resource quota to the "default" namespace with this command on the "Server" tab:
```
nomad namespace apply -quota default -description "default namespace" default
```
This should return 'Successfully applied namespace "default"!'.

Create the "dev" namespace and apply the "dev" resource quota to it with this command:
```
nomad namespace apply -quota dev -description "dev namespace" dev
```
This should return 'Successfully applied namespace "dev"!'.

Create the "qa" namespace and apply the "qa" resource quota to it with this command:
```
nomad namespace apply -quota qa -description "qa namespace" qa
```
This should return 'Successfully applied namespace "qa"!'.

To become familiar with the Nomad CLI commands for namespaces and resource quotas, we suggest you run the following commands on the "Server" tab:
```
nomad namespace list
nomad namespace status dev
nomad quota list
nomad quota inspect qa
```

The first of these should show the "default", "dev", and "qa" namespaces.

The second command should show this:<br>
`
Name        = dev
Description = dev namespace
Quota       = dev
Quota Limits
Region  CPU Usage  Memory Usage  Network Usage
global  0 / 4600   0 / 4100      - / inf
`<br>

The third command should show the "default", "dev", and "qa" resource quotas.

The last command should show a JSON document with information about the resource quota's limits and current usage. There is also a `nomad quota status` command that gives back streamlined information more like what the `nomad namespace status` command gives.

In the next challenge, you will enable Nomad's ACL system and define ACL policies and tokens which are applicable to Nomad namespaces and resource quotas and required by Nomad Sentinel policies.