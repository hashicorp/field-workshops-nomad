---
slug: reconfigure-the-nomad-server
type: challenge
title: Reconfigure the Nomad Server
teaser: |
  Enable the Vault integration on the Nomad server.
notes:
- type: text
  contents: |-
    <b>Reconfigure the Nomad Server</b>
    <hr />

    At this point, you are ready to edit the "vault" stanza in the Nomad server's configuration file, "/root/hashistack/nomad/nomad.hcl". You will add the token you generated two challenges ago and also enable the Vault integration.
- type: text
  contents: |-
    The "vault" stanza will end up looking like this:
    ```
    vault {
      enabled = true
      address = "http://active.vault.service.consul:8200"
      task_token_ttl = "1h"
      create_from_role = "nomad-cluster"
      token = "s.1234567890abcdefghijklmnop"
    }
    ```

    The Nomad server will renew the token automatically since it is a periodic token.
- type: text
  contents: |-
    Nomad's Vault integration also needs be enabled on the Nomad clients, but this has already been done for you. The "vault" stanza on the clients looks like this:
    ```
    vault {
      enabled = true
      address = "http://active.vault.service.consul:8200"
    }
    ```

    Note that the Nomad clients are not given a Vault token.
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

Click on the "Files" tab and navigate to the "/root/hashistack/nomad/nomad-token.txt" file. Copy the value of the `token` field from the file. Click on the "server.hcl" file in the same directory. Find the "vault" stanza at the bottom and replace <b><your nomad server token\></b> with your token. Also, change <b>enabled = false</b> to <b>enabled = true</b> within the "vault" stanza.

<b>Remember to save the file by clicking the save icon on the "Files" tab!</b>

Note that token could also have been provided as an environment variable called VAULT_TOKEN instead of including it in the "vault" stanza.

Note that the `create_from_role` key in the "vault" stanza is set to the "nomad-cluster" token role that you created in the last challenge. So, we are using both the token you created two challenges ago and the token role you created in the last challenge.

Next, restart the Nomad server by running;
```
systemctl restart nomad
```
The Nomad server is now integrated with Vault and its Vault token will be renewed automatically.

Our next challenge will be to deploy a PostgeSQL database with a Nomad job.

Click the "Check" button in the lower right to complete the challenge.