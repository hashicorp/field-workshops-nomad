---
slug: create-a-vault-token-role
id: wdbsmnqndyul
type: challenge
title: Create a Vault Token Role
teaser: |
  Create a Vault token role that Nomad can give to jobs.
notes:
- type: text
  contents: |-
    <b>Create a Vault Token Role</b>
    <hr />

    At this point, you must create a [Vault Token Role](https://www.vaultproject.io/api-docs/auth/token#create-update-token-role) that Nomad can give to jobs that it runs. The token role allows you to restrict which Vault policies can be used by Nomad jobs, limiting the Vault secrets the jobs can read.
- type: text
  contents: |-
    We will use the following token role:
    ```
    {
      "allowed_policies": "access-tables",
      "token_explicit_max_ttl": 0,
      "name": "nomad-cluster",
      "orphan": true,
      "token_period": 259200,
      "renewable": true
    }
    ```

    Note that the "access-tables" policy is listed under the `allowed_policies` key. We have not created this policy yet, but it will be used by our web job to retrieve database credentials.
- type: text
  contents: |-
    To allow all policies except those you explicitly prohibit to be used by jobs, specify the `disallowed_policies` key instead and list the policies that should not be granted. If you take this approach, be sure to include the `nomad-server` policy. An example of this is shown below:
    ```
    {
      "disallowed_policies": "nomad-server",
      "token_explicit_max_ttl": 0,
      "name": "nomad-cluster",
      "orphan": true,
      "token_period": 259200,
      "renewable": true
    }
    ```
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
If you did not read all 3 notes screens while this challenge was starting, please do that now by clicking the "notes" button in the upper right corner. After reading all of them, click the "X" button to hide the notes.

Click on the "Files" tab and take a look at the "/root/hashistack/vault/nomad-cluster-role.json" policy. Create the token role named "nomad-cluster" by running the following command on the "Server" tab:
```
vault write auth/token/roles/nomad-cluster @nomad-cluster-role.json
```
You should now see a message telling you that you succeeded.

Our next challenge will be to reconfigure Nomad to enable the Vault integration.

Click the "Check" button in the lower right to complete the challenge.