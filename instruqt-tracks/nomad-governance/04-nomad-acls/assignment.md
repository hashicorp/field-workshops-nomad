---
slug: nomad-acls
id: nytk9bz4fmj8
type: challenge
title: Create Nomad ACL Policies and Tokens
teaser: |
  Enable Nomad's ACL system and create ACL policies and tokens for the Dev and QA teams.
notes:
- type: text
  contents: |-
    In this challenge, you will enable Nomad's ACL system and define ACL policies and tokens for the Dev and QA teams that will be using the "dev" and "qa" namespaces.

    Nomad ACLs are also required by Nomad Sentinel policies.
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
In this challenge, you will enable Nomad's ACL system and define ACL policies and tokens for the Dev and QA teams that will be using the "dev" and "qa" namespaces.

Nomad ACLs are also required to use Nomad Sentinel policies since only users with the suitable ACL policies can apply Sentinel policies.

## Enable the ACL System
Start by reviewing the "nomad-server1.hcl", "nomad-client1.hcl", "nomad-client2.hcl", and "nomad-client3.hcl" files on the "Config Files" tab. Notice that the following stanza has been added to the bottom of each file:<br>
`
acl {
  enabled = true
}
`<br>

This stanza is needed on Nomad servers and clients when enabling the Nomad ACL system. You are looking at copies of the actual files that have been placed in the /etc/nomad.d directory on the server and all 3 clients.

Navigate to the /root/nomad/acls directory on the "Server" tab with this command:
```
cd /root/nomad/acls
```

Restart the Nomad server on the "Server" tab with this command:
```
systemctl restart nomad
```

After waiting about 15 seconds, bootstrap the Nomad ACLs system by running this command on the "Server" tab:
```
nomad acl bootstrap | tee bootstrap.txt
```
This will return something like this:<br>
`
Accessor ID  = 5b7fd453-d3f7-6814-81dc-fcfe6daedea5
Secret ID    = 9184ec35-65d4-9258-61e3-0c066d0a45c5
Name         = Bootstrap Token
Type         = management
Global       = true
Policies     = n/a
Create Time  = 2020-03-09 14:20:57.209983275 +0000 UTC
Create Index = 68
Modify Index = 68
`<br>
The actual Nomad boostrap token is the value of the "Secret ID" field.

Export the bootstrap token with these commands on the "Server" tab:
```
export NOMAD_TOKEN=$(cat bootstrap.txt | grep Secret | cut -d' ' -f7)
echo "export NOMAD_TOKEN=$NOMAD_TOKEN" >> /root/.bash_profile
```
The second command ensures that the bootstrap token will be exported in later challenges.

Verify that you can still use the Nomad CLI by running `nomad status` which should return "No running jobs".

Next, you should restart all 3 of the Nomad clients on the "Client 1", "Client 2", and "Client 3" tabs:
```
systemctl restart nomad
```

## Create ACL Policies and Tokens
Next, inspect the "acl-anonymous.hcl", "acl-dev.hcl", "acl-qa.hcl", and "acl-override.hcl" Nomad ACL policies in the "acls" directory on the "Config Files" tab. The first allows any user to list jobs in the "default" namespace and read information about agents and nodes. The "dev" and "qa" policies give the same permissions but add the ability to write to the "dev" and "qa" namespaces respectively. The "acl-override.hcl" Nomad ACL allows a user to submit jobs and override soft-mandatory failures of Sentinel policies.

Add the "anoymous" ACL policy to your Nomad cluster by running this command on the "Server" tab:
```
nomad acl policy apply -description "restricted access for users without ACL tokens" anonymous acl-anonymous.hcl
```
This should return 'Successfully wrote "anonymous" ACL policy!'.

Add the "dev" ACL policy to your Nomad cluster by running this command on the "Server" tab:
```
nomad acl policy apply -description "access for users with dev ACL tokens" dev acl-dev.hcl
```
This should return 'Successfully wrote "dev" ACL policy!'.

Add the "qa" ACL policy to your Nomad cluster by running this command on the "Server" tab:
```
nomad acl policy apply -description "access for users with qa ACL tokens" qa acl-qa.hcl
```
This should return 'Successfully wrote "qa" ACL policy!'.

Add the "override" ACL policy to your Nomad cluster by running this command on the "Server" tab:
```
nomad acl policy apply -description "override soft-mandatory Sentinel policies" override acl-override.hcl
```
This should return 'Successfully wrote "override" ACL policy!'.

Complete this challenge by adding ACL tokens for use by a developer, Alice, a QA engineer, Bob, and an infrastructure manager, Charlie.

Create Alice's token and assign the "dev" policy to it with this command on the "Server" tab:
```
nomad acl token create -name="alice" -policy=dev | tee alice-token.txt
```
This will return something like this:<br>
`
Accessor ID  = <accessor id>
Secret ID    = <token>
Name         = alice
Type         = client
Global       = false
Policies     = [dev]
Create Time  = <timestamp>
Create Index = 106
Modify Index = 106
`<br>

We had you use the `tee` command to write Alice's token to a file for later use.

Create Bob's token and assign the "qa" policy to it with this command on the "Server" tab:
```
nomad acl token create -name="bob" -policy=qa | tee bob-token.txt
```
This will return something like this:<br>
`
Accessor ID  = <accessor id>
Secret ID    = <token>
Name         = bob
Type         = client
Global       = false
Policies     = [qa]
Create Time  = <timestamp>
Create Index = 109
Modify Index = 109
`<br>

We had you use the `tee` command to write Bob's token to a file for later use.

Create Charlie's token and assign the "override" policy to it with this command on the "Server" tab:
```
nomad acl token create -name="charlie" -policy=override | tee charlie-token.txt
```
This will return something like this:<br>
`
Accessor ID  = <accessor id>
Secret ID    = <token>
Name         = charlie
Type         = client
Global       = false
Policies     = [override]
Create Time  = <timestamp>
Create Index = 109
Modify Index = 109
`<br>

We had you use the `tee` command to write Charlie's token to a file for later use.

Each user's ACL token is the value of the "Secret ID" field returned by the above commands.

To become familiar with the Nomad CLI commands for ACLs, we suggest you run the following commands on the "Server" tab:
```
nomad acl policy list
nomad acl policy info dev
nomad acl token list
```

The first of these should show the "anonymous", "dev", "qa", and "override" policies.

The second should show the name, description, and actual rules for the "dev" Sentinel policy.

The third should show the "Bootstrap", "alice", "bob", and "charlie" tokens.

We also suggest you run this command:<br>
`
nomad acl token info <accessor_id>
`<br>
replacing <accessor_id\> with Alice's or Bob's Accessor ID. You will see complete information for their token including the actual token itself (the "Secret ID" field).

In the next challenge, you will define and enable some Sentinel policies to place restrictions on jobs that can be run in your Nomad cluster.