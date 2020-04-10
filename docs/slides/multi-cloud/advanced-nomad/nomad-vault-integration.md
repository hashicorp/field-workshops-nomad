name: chapter-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 3
## Nomad Vault Integration

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* This chapter covers the integration of Nomad with Vault.
* It also covers Nomad templates which the integration uses.

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-topics
# Nomad's Integration with Vault
* Nomad integrates seamlessly with [Vault](https://www.vaultproject.io/), allowing applications deployed by Nomad jobs to retrieve Vault secrets.
* Nomad servers and clients coordinate with Vault to provide Nomad tasks a Vault token that only has the Vault policies that the tasks need.
* Nomad clients handle renewal of these Vault tokens.
* Finally, Nomad's [template](https://nomadproject.io/docs/job-specification/template/) stanza makes it easy for tasks to retrieve secrets from Vault.
* For more information, see the Vault Integration [overview](https://nomadproject.io/docs/vault-integration/) and [guide](https://nomadproject.io/docs/integrations/vault-integration/).
* The Instruqt track at the end of this chapter implements that guide.

???
* Nomad has seamless integration with Vault.
* This makes it easy for applications deployed by Nomad jobs to retrieve secrets from Vault.

---
name: configuring-nomad-servers-for-vault
class: compact
# Nomad Server Vault Configuration
* Each Nomad server should include the [`vault`](https://nomadproject.io/docs/configuration/vault/) stanza in its configuration file.
* The minimum configuration sets `enabled` to `true` and sets `address` to the address of the Vault cluster in the format `protocol://host:port`.
* Some other important parameters are:
  * `create_from_role`, which indicates which Vault token role the Nomad server should create tokens from.
  * `token`, which gives the Nomad server a parent Vault token to use to derive child tokens for jobs from the token role specified in `create_from_role`.
  * `namespace`, which indicates the Vault namespace to use.
* There are also TLS parameters required if the Vault server is using TLS.

???
* Each Nomad server should include the `vault` stanza in its configuration file.
* Be sure to set `enabled` to true and to specify the address of your Vault server or cluster.

---
name: nomad-server-config-example
# Nomad Server Vault Configuration Example
* Here is an example of configuring a Nomad server to connect to a Vault cluster:

```hcl
vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
  create_from_role = "nomad-cluster"
  token = "debecfdc-9ed7-ea22-c6ee-948f22cdd474"
  namespace = "Sales"
}
```

* Note that we are using Consul's DNS address of the active Vault server.

???
* Here is an example `vault` stanza on a Nomad server.

---
name: configuring-nomad-clients-for-vault
# Nomad Client Vault Configuration
* Each Nomad client should also include a `vault` stanza similar to but simpler than the one specified on the Nomad servers.
* However, the `create_from_role` and `token` parameters should not be specified on Nomad clients.
* A typical client configuration without TLS looks like the one below.

```hcl
vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
}
```

???
* Each Nomad client also needs a `vault` stanza, but it will be simpler.
* It often suffices to just set `enabled` to `true` and to specify the Vault cluster address.
* However, if Vault namespaces are being used, you would also want to set the `namespace` parameter.

---
name: vault-job-stanza
# Vault Stanza in Job Specifications
* The [`vault`](https://nomadproject.io/docs/job-specification/vault/) stanza of Nomad job specification files allows jobs, task groups, and tasks to tell Nomad that they need Vault tokens.
* Nomad retrieves a suitable Vault token from the Vault cluster based on the `policies` parameter and handles token renewal.
* Nomad clients make a Vault token available to tasks by writing it to the `vault_token` path under the [secrets](https://nomadproject.io/docs/runtime/environment/#secrets) directory of each task and by setting a `VAULT_TOKEN` environment variable in the task.
* If the Nomad cluster is configured to use a Vault namespace, a `VAULT_NAMESPACE` environment variable will also be set for the task.

???
* The `vault` stanza of Nomad job specification files allows jobs, task groups, and tasks to tell Nomad that they need Vault tokens.
* Nomad takes care of retrieving tokens for jobs, task groups, and tasks and also renews those tokens as needed.
* The tokens are exposed to tasks in two ways.
* If needed, the Vault namespace being used is also exposed to the tasks.

---
name: vault-job-stanza-example
# Example of a Vault Stanza in a Job
* Here is an example of a `vault` stanza in a Nomad job specification file:

```hcl
vault {
  policies = ["access-tables"]
}
```

* Note that this example only specifies the `policies` parameter, which often suffices.
* Other parameters like `change_mode` and `change_signal` tell Nomad what to do if the Vault token changes.

???
* Jobs that want to retrieve Vault secrets need to include a `vault` stanza that indicate what Vault policies the generated tokens should possess.
* Additionally, this stanza can indicate what Nomad should do if the Vault token changes. Normally, this would not happen since the initial token would be renewed.
* But if a Vault outage occurred, the original token might no longer be valid; in this case, Nomad would request a new token and share it with the task.
* The task might then need to be restarted.
* But it is also possible to have Nomad send a signal such as `SIGUSR1` or `SIGINT` to the task.

---
name: nomad-template-with-vault
# Using Nomad Templates to Retrieve Secrets
* Nomad's [`template`](https://nomadproject.io/docs/job-specification/template/) stanza can be used by a task to retrieve secrets from Vault.
* The next slide shows an example from the Instruqt lab you will be starting in a few minutes.
* It is reading dynamically generated database credentials from Vault's [Database](https://www.vaultproject.io/docs/secrets/databases) secrets engine using the Vault path, `database/creds/accessdb`.
* The secret has `username` and `password` keys which are injected into the task as environment variables called `DB_USERNAME` and `DB_PASSWORD`.
* The credentials are also written to the file "secrets/file.env".

???
* Nomad's `template` stanza can be used by a task to retrieve secrets from Vault.

---
name: nomad-template-with-vault
# An Example vault Stanza in a Job Specification
```hcl
template {
  data = <<EOT
{{ with secret "database/creds/accessdb" }}
DB_USERNAME="{{ .Data.username }}"
DB_PASSWORD="{{ .Data.password }}"
{{ end }}
  EOT
  destination = "secrets/file.env"
  env         = true
}
```

???
* Here is an example from the Instruqt track you will start in a few minutes.
* See the previous slide for explanation.
* Note that the full template stanza in the lab also retrieves the host and port of the database from Consul.

---
name: lab-nomad-vault-integration
class: compact
# 👩‍💻 Nomad Vault Integration Lab
* In this lab, you'll deploy a web application and a PostgreSQL database with Nomad.
* You'll then use Nomad's Vault integration to provide the web application credentials for the database that are dynamically generated by Vault.
* The database credentials are retrieved into the web app's task using a Nomad template.
* You'll do this using the Instruqt track "Nomad Integration with Vault" at this URL:<br>
https://play.instruqt.com/hashicorp/tracks/nomad-integration-with-vault

???
* Now, you can explore Nomad's integration with Vault hands-on
* You'll be running the Instruqt track "Nomad Integration with Vault"

---
name: chapter-Summary
# 📝 Chapter 3 Summary

In this chapter you did the following:
* Learned about Nomad's integration with Vault
* Learned how to use Nomad templates.
* Actually ran an Instruqt lab in which you used Nomad to deploy a web application that retrieved a dynamically-generated database password from Vault so that it could talk to a database also deployed by Nomad.

???
* You now know a lot more about Nomad's integration with Vault and templates than you did yesterday.
