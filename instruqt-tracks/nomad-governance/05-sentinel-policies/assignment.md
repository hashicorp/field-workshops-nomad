---
slug: sentinel-policies
id: zgyyakltglat
type: challenge
title: Create Nomad Sentinel Policies
teaser: |
  Create 3 Nomad Sentinel policies to restrict drivers, Docker images, and Docker networks.
notes:
- type: text
  contents: |-
    In this challenge, you will create 3 Nomad Sentinel policies:
      * allow-docker-and-java-drivers.sentinel restricts which Nomad drivers can be used.
      * restrict-docker-images.sentinel limits the Docker images that can be used by the Docker driver.
      * prevent-docker-host-network.sentinel prevents Docker containers from using the host network of the Nomad clients they run on.
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
In this challenge, you will create 3 Nomad Sentinel policies that will restrict which Nomad drivers can be used, which Docker images can be used by the Docker driver, and prevent Docker containers from using the host network of the Nomad clients they run on.

Start by reviewing the "allow-docker-and-java-drivers.sentinel", "restrict-docker-images.sentinel", and "prevent-docker-host-network.sentinel" Sentinel policies in the sentinel directory on the "Config Files" tab.

The "allow-docker-and-java-drivers" Sentinel policy only allows Nomad's Docker and Java task drivers to be used in jobs.

The "restrict-docker-images" Sentinel policy restricts the Docker images that can be used in jobs to the nginx and mongo images which run a specific web server and database respectively. The policy also mandates that a specific tag starting with a number be specified, preventing the "latest" tag from being used. This avoids nasty surprises when a new release is added.

The "prevent-docker-host-network" Sentinel policy prevents Docker containers from using the host network of the Nomad clients they are run on.

You will create the first of these Sentinel policies with the "hard-mandatory" enforcement level and the others with the "soft-mandatory" enforcement level. This means that absolutely no Nomad task drivers except for the Docker and Java drivers will be allowed but that Nomad administrators will be able to override failures of the other two Sentinel policies.

Navigate to the /root/nomad/sentinel directory on the "Server" tab with this command:
```
cd /root/nomad/sentinel
```

Add the "allow-docker-and-java-drivers" Sentinel policy on the "Server" tab with this command:
```
nomad sentinel apply -description "Only allow the Docker and Java drivers" -level hard-mandatory allow-docker-and-java-drivers allow-docker-and-java-drivers.sentinel
```
This should return 'Successfully wrote "allow-docker-and-java-drivers" Sentinel policy!'.

Add the "restrict-docker-images" Sentinel policy on the "Server" tab with this command:
```
nomad sentinel apply -description "Restrict allowed Docker images" -level soft-mandatory restrict-docker-images restrict-docker-images.sentinel
```
This should return 'Successfully wrote "restrict-docker-images" Sentinel policy!'.

Add the "prevent-docker-host-network" Sentinel policy on the "Server" tab with this command:
```
nomad sentinel apply -description "Prevent Docker containers running with host network mode" -level soft-mandatory prevent-docker-host-network prevent-docker-host-network.sentinel
```
This should return 'Successfully wrote "prevent-docker-host-network" Sentinel policy!'.

To become familiar with the Nomad CLI commands for Sentinel policies, we suggest you run the following commands on the "Server" tab:
```
nomad sentinel list
nomad sentinel read restrict-docker-images
```

The first will list the 3 Sentinel policies you created while the second will show the "restrict-docker-images" policy including its name, scope, enforcement level, description, and its actual policy (rules).

In the next challenge, you will run jobs in the 3 namespaces and see how the resource quotas and Sentinel policies restrict what they can do.