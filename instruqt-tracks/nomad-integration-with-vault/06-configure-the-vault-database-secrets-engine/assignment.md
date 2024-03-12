---
slug: configure-the-vault-database-secrets-engine
id: pbrxi1ehqaqh
type: challenge
title: Configure the Vault Database Secrets Engine
teaser: |
  Allow Vault to generate dynamic credentials for the PostgreSQL database.
notes:
- type: text
  contents: |-
    <b>Configure Vault's Database Secrets Engine</b>
    <hr />

    We are using Vault's [Database Secrets Engine](https://www.vaultproject.io/docs/secrets/databases) in this challenge so that we can generate dynamic credentials for our PostgreSQL database. We'll start by enabling the database secrets engine for Vault.
- type: text
  contents: |-
    You will set up the database secrets engine's connection with the following data:
    ```
    {
      "plugin_name": "postgresql-database-plugin",
      "allowed_roles": "accessdb",
      "connection_url": "postgresql://{{username}}:{{password}}@database.service.consul:5432/postgres?sslmode=disable",
      "username": "demo",
      "password": "demo"
    }
    ```
- type: text
  contents: |-
    We have specified "accessdb" in the `allowed_roles` key of our connection information. We will create the "accessdb" role for the database secrets engine soon.

    The information in the database connection in the previous note allows Vault to connect to our database and create users with specific privileges.

    In a production setting, it is recommended to give Vault credentials with enough privileges to generate database credentials dynamically and to manage their lifecycle.
- type: text
  contents: |-
    When you create the "accessdb" role, you will use the following SQL in the "creation_statements" parameter:
    ```
    CREATE USER "{{name}}" WITH ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
    ALTER USER "{{name}}" WITH SUPERUSER;
    ```

    In our case, the dynamic database user will have broad privileges that include the ability to read from the tables that our application will need to access.
- type: text
  contents: |-
    Finally, we need to create the "access-tables" policy that was referenced in the "allowed_policies" key of the token role we created earlier. Tokens given this policy will be able to read dynamic database credentials from the "database/creds/accessdb" path in Vault.
    ```
    path "database/creds/accessdb" {
      capabilities = ["read"]
    }
    ```

    The Nomad "web" job will be assigned this policy.
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
If you did not read all 5 notes screens while this challenge was starting, please do that now by clicking the "notes" button in the upper right corner. After reading all of them, click the "X" button to hide the notes.

Let's start off by enabling the Database Secrets Engine by running the following command on the "Server" tab;
```
vault secrets enable database
```
You should see a message indicating success.

A database connection file has been created for you. Take a look at it by clicking on the "Files" tab and navigating to the "/root/hashistack/vault/connection.json" file.

Run the following command to configure the connection between the database secrets engine and our database:
```
vault write database/config/postgresql @connection.json
```
If the operation is successful, there will be no output.

Click on the "Files" tab and navigate to the "/root/hashistack/vault/accessdb.sql" file. Recall from the previous step that we specified accessdb in the allowed_roles key of our connection information.

Run the following command to create the role:
```
vault write database/roles/accessdb db_name=postgresql creation_statements=@accessdb.sql default_ttl=1h max_ttl=24h
```
You should see a message indicating success.

Finally, let's verify that we can generate PostgreSQL credentials from the database secrets engine by running the following command:
```
vault read database/creds/accessdb
```
You should see a table listing a username and password.

A policy file that allows retrieval of PostgreSQL credentials from the database secrets engine has been created for you. Take a look at it by clicking on the "Files" tab and navigating to the "/root/hashistack/vault/access-tables-policy.hcl" file. We need to create this policy to restrict who can request dynamic credentials from the database secrets engine.

Create the access-tables policy with the following command:
```
vault policy write access-tables access-tables-policy.hcl
```
You should see a success message as confirmation.

Our next challenge will be to deploy the web application with Nomad.

Click the "Check" button in the lower right to complete the challenge.