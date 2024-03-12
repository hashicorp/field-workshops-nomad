---
slug: deploy-an-application
id: o6kmjfztauxg
type: challenge
title: Deploy a Web Application
teaser: |
  Deploy a web application with the appropriate policy and templating.
notes:
- type: text
  contents: |-
    <b>Deploy a Web Application with Nomad</b>
    <hr />

    Now we are ready to deploy our web application and give it the necessary Vault policy and configuration to communicate with our database.
- type: text
  contents: |-
    When you look at the job specification for the web job, you will see the following "vault" stanza:
    ```
    vault {
      policies = ["access-tables"]
    }
    ```

    This assigns the job the "access-tables" policy so that it can request database credentials from Vault.
- type: text
  contents: |-
    We are using the "template" stanza's vault integration to populate a configuration file that our application needs.

    The underlying tool being used is [Consul Template](https://learn.hashicorp.com/consul/developer-configuration/consul-template), which is built into Nomad and can populate files with data from Consul's key/value store and from Vault secrets.
- type: text
  contents: |-
    The "template" stanza of the job specification for the web job includes the following:
    ```
    {{ with secret "database/creds/accessdb" }}
      DB_USERNAME="{{ .Data.username }}"
      DB_PASSWORD="{{ .Data.password }}"
    {{ end }}
    ```

    This tells the Consul Template sub-system of Nomad to retrive the dynamically generated username and password for the database from the "database/creds/accessdb" path on the Vault server and to store the "username" and "password" keys of that secret in the given variables within the task.
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
- title: Application
  type: service
  hostname: hashistack-client-1
  port: 3000
difficulty: basic
timelimit: 1200
---
If you did not read all 4 notes screens while this challenge was starting, please do that now by clicking the "notes" button in the upper right corner. After reading all of them, click the "X" button to hide the notes.

The Nomad job file has been also been created for you and you can take a look at it by clicking on the "Files" tab and navigating to the "/root/hashistack/nomad/web.nomad" file.

Note that the job's "vault" stanza indicates that the job can use the "access-tables" policy.

Run the Nomad job by running the command:
```
nomad run /root/hashistack/nomad/web.nomad
```
Click on the "Nomad" tab and wait until the job has been successfully deployed in the Nomad UI as indicated by a green bar in the Summary column for the "web" job in the list of jobs. Alternatively, you can run the `nomad status web` command until it shows the status of the web job as "running" and the "demo" task group has 1 healthy allocation.

After waiting about 30 seconds, confirm that the application is accessing the database by running two commands on the "Server" tab.

First, use the dig command to query the SRV record of your service and obtain the port it is using:
```
dig +short SRV web.service.consul.
```
The response should look similar to:<br>
`
1 1 3000 hashistack-client-1.node.instruqt.consul.
`<br>

Next curl your service at the appropriate port and names path:
```
curl http://web.service.consul:3000/api | jq
```
The response should return json from the api.

Finally, click on the "Application" tab to view the web application. All of the content, links and image locations come from the database. You should see all 6 HashiCorp products.

Click the "Check" button in the lower right to complete the challenge.

Congratulations on finishing the Nomad Integration with Vault track!