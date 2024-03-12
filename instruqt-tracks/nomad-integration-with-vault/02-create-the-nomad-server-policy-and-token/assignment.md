---
slug: create-the-nomad-server-policy-and-token
id: 9ae3r87b3nl9
type: challenge
title: Create a Vault Policy and Token for the Nomad Server
teaser: |
  Create a Vault policy and token for use by the Nomad server.
notes:
- type: text
  contents: |-
    <b>Create the Nomad Server's Policy and Token</b>
    <hr />

    To use Nomad's [Vault integration](https://nomadproject.io/docs/vault-integration), you must provide a [Vault token](https://www.vaultproject.io/docs/concepts/tokens) to your Nomad server.

    The recommended approach is to give the Nomad server a periodic token with the ability to create tokens for Nomad jobs that are derived from a token role. This approach limits the Vault secrets that applications orchestrated by Nomad can read.

    In this challenge, you will create a policy and token that give the Nomad server the Vault permissions it needs.
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
A policy named nomad-server-policy.hcl has been created for you in the vault directory of the "Files" tab. Click on the file to view how the policy has been setup.

We are going to be mainly using files in the vault directory, so let's change the directory on the "Server" tab using the command:
```
cd /root/hashistack/vault
```
Next, write the nomad-server policy to Vault using the command:
```
vault policy write nomad-server nomad-server-policy.hcl
```
You should now see a message telling you that you succeeded.

Run the following command to create a token for your Nomad server:
```
vault token create -policy nomad-server -period 72h -orphan > /root/hashistack/nomad/nomad-token.txt
```

Click on the "Files" tab and navigate to the "/root/hashistack/nomad/nomad-token.txt" file to see the output.

Our next challenge will be to create a Vault token role that the Nomad server will use when creating Vault tokens for jobs that it runs.

Click the "Check" button in the lower right to complete the challenge.