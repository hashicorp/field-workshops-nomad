name: nomad-chapter-security-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad Security

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll provide an overview of Nomad Security

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-security-topics
# Chapter 1 Topics

1. Encryption Overview
2. Nomad Access Control Lists (ACLs)
3. Securing Nomad Clusters with TLS
4. Using Vault's PKI Secrets Engine with Nomad
5. Hands on Lab: Nomad ACLs

???
* This is our topics slide.

---
name: nomad-encryption-overview
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad Encryption Overview

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: nomad-chapter-security-encryption-overview
# Nomad Encryption Overview

There are two separate encryption systems for Nomad:
* Gossip Traffic Encryption.
* HTTP and RPC Encryption.

Together, these encrypt all of Nomad's network traffic.

???

---
name: nomad-chapter-security-encryption-gossip-1
# Gossip Traffic Encryption

.smaller[Gossip encryption is enabled by providing an encryption key when starting all servers in a region with the `-encrypt` parameter or storing the key in each server's configuration file.

The key must be 16 bytes and base64 encoded. Generate a key using the `nomad operator keygen` command.]

```bash
$ nomad operator keygen
cg8StVXbQJ0gPvMd9o7yrg==
```

???

---
name: nomad-chapter-security-encryption-http-rpc-1
# HTTP and RPC Encryption with TLS

.smaller[* TLS is used to verify the authenticity of servers and clients.
* All servers and clients should have signed key pairs configured.
* Server authenticity can be enforced using:
 * `verify_server_hostname = true` in the **tls** configuration stanza.
* All servers must have a valid certificate for:
   * `server.<region>.nomad`.
   * `localhost` ( for the local cli to validate the name).
 * TLS is used to secure the RPC calls between agents.
 ]

---
name: nomad-chapter-security-encryption-configuring-the-cli
# Configuring The Command Line Tool

.smaller[* By default HTTPS does not validate client certificates
  * No need for clients to have access to private keys
* Additional **NOMAD_CACERT** environment variable is needed.
  * This should point to the CA file used to sign the TLS certificates.

For Example:
```bash
export NOMAD_ADDR=https://127.0.0.1:4646
export NOMAD_CACERT=/path/to/ca.pem
```
]

???

---
name: nomad-chapter-security-encryption-network-isolation-tls-1
# Network Isolation with TLS

.smaller[To isolate Nomad agents on a network with TLS enable:
* `verify_https_client`.
* `verify_server_hostname`.

Agents will:
* Require client certificates for all incoming HTTPS connections.
* Verify proper names on all other certificates.

Consul will not attempt to health check agents with **`verify_https_client`** set.]

???

---
name: nomad-chapter-security-acls
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad Access Control Lists (ACL)

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: nomad-chapter-security-ACL-overview-1
# Access Control List (ACL) Overview

.small[
Nomad provides an optional Access Control List (ACL) system.
* Controls access to data and APIs.
* Capability-based
* Relies on tokens associated with policies
* Similar to the design of AWS IAM.
]

???

---
name: nomad-chapter-security-ACL-system-overview-2
# The ACL System

.small[
The ACL system is designed to be:
* Easy to use
* Fast to enforce
* Provide administrative insight.
]

---
name: nomad-chapter-security-ACL-system-overview-3
class: col-2
# The ACL System

.small[
Three major components to the ACL system:
* ACL Policies
* ACL Tokens
* ACL Capabilities
]

<br>
.center[![:scale 100%](images/acl-overview.jpg)]

???

---
name: nomad-chapter-security-ACL-policies-1
class: col-2
# ACL Policies

.small[
An ACL policy is a named set of rules.

Each policy must have:
* A unique name
* A rule set.
* A description (Optional)
]
<br>
<br>

.smaller[
```json
{
  "Name": "anonymous",
  "Description": "Allow RO",
  "Rules": "
    namespace \"default\" {
        policy = \"read\"
    }
    agent {
        policy = \"read\"
    }
    node {
        policy = \"read\"
    }"
}
```
]

---
name: nomad-chapter-security-ACL-policies-2
class: col-2
# ACL Policies

.small[
* Default = Deny/Allowlist.
* No permissions by default.
* Policies allow a set of capabilities or actions.
]

.small[
* For Example: a "readonly" policy might only grant the ability to list and inspect running jobs, but not to submit new ones.
]
???

---
name: nomad-chapter-security-ACL-policies-3
# ACL Policies
.small[
* A special `anonymous` policy can be defined for **anonymous** requests.
  * Defines capabilities for **anonymous** requests.
  * By default there is no `anonymous` policy

* An anonymous request is a request made to Nomad without the `X-Nomad-Token` header specified.

* The Nomad UI uses the anonymous policy unless an ACL is set for it.

]

???
The special `anonymous` policy can be defined to grant capabilities to requests which are made anonymously. An anonymous request is a request made to Nomad without the `X-Nomad-Token` header specified. This can be used to allow anonymous users to list jobs and view their status, while requiring authenticated requests to submit new jobs or modify existing jobs. By default, there is no `anonymous` policy set meaning all anonymous requests are denied.

---
name: nomad-chapter-security-ACL-tokens-0
# ACL Tokens
.small[
## Standard Tokens
* A client ACL token can be associated with multiple policies.
* A request is allowed if any of the associated policies grant the capability.

## Management tokens
* Cannot be associated with policies.
* They are granted all capabilities.
]
???

---
name: nomad-chapter-security-ACL-tokens-1
# ACL Tokens

* ACLs perform the following roles:
  * Authenticate Requests
  * Authorize Actions
* Each ACL token contains these items:
  * Accessor ID
  * Secret ID
  * Name (Optional)

???
ACL tokens are used to authenticate requests and determine if the caller is authorized to perform an action. Each ACL token has a public Accessor ID which is used to identify the token, a Secret ID which is used to make requests to Nomad, and an optional human readable name. All client type tokens are associated with one or more policies, and can perform an action if any associated policy allows it. Tokens can be associated with policies which do not exist, which are the equivalent of granting no capabilities. The management type tokens cannot be associated with policies, but can perform any action.

---
name: nomad-chapter-security-ACL-tokens-2
# ACL Tokens
## Example Token
```json
{
    "Name": "Readonly token",
    "Type": "client",
    "Policies": ["readonly"],
    "Global": false
}
```
???
When ACL tokens are created, they can be optionally marked as Global. This causes them to be created in the authoritative region and replicated to all other regions. Otherwise, tokens are created locally in the region the request was made and not replicated. Local tokens cannot be used for cross-region requests since they are not replicated between regions.

---
name: nomad-chapter-security-ACL-tokens-3
# ACL Tokens
* Tokens are created locally by default.
  * They are not replicated to other regions.
* If `"Global": True` is set:
  * They are created in the authoritative region.
  * They are replicated to **all** other regions.
* Local tokens cannot make cross-region requests.

???
When ACL tokens are created, they can be optionally marked as Global. This causes them to be created in the authoritative region and replicated to all other regions. Otherwise, tokens are created locally in the region the request was made and not replicated. Local tokens cannot be used for cross-region requests since they are not replicated between regions.

---
name: nomad-chapter-security-ACL-capabilities-1
# ACL Capabilities

* ACL Capabilities are the set of actions that can be performed on a Nomad cluster.
  * List Jobs
  * Submit Jobs
  * Query Nodes
  * etc.


???
Capabilities are the set of actions that can be performed. This includes listing jobs, submitting jobs, querying nodes, etc.

---
name: nomad-chapter-security-ACL-capabilities-2
# ACL Capabilities
.small[
* Client tokens are granted capabilities with ACL Policies.
* Management tokens are granted **ALL** capabilities
]
???
A management token is granted all capabilities, while client tokens are granted specific capabilities via ACL Policies.

---
name: nomad-chapter-security-ACL-capabilities-3
class: table
# ACL Capabilities and Scope

ACL Rules Available for Policies:

.smaller[
Policy | Scope
------- | -------------------
namespace | Job related operations by namespace
agent | Utility operations in the Agent API
node | Node-level catalog operations
operator | Cluster-level operations in the Operator API
quota | Quota specification related operations
host_volume | Host Volume related operations
]
???
The following table summarizes the ACL Rules that are available for constructing policy rules

---
name: nomad-chapter-security-ACL-multi-region-configuration-1
# Multi-Region Configuration.
.small[
Nomad supports multi-datacenter and multi-region configurations.
* Single-Region, Multi-datacenter Configuration.
  * Servers in the region replicate state.
* Multi-Region Configuration
  * One set of servers for each region.
  * Regions operate independantly.
  * Regions are loosely coupled.

]
???
Nomad supports multi-datacenter and multi-region configurations. A single region is able to service multiple datacenters, and all servers in a region replicate their state between each other. In a multi-region configuration, there is a set of servers per region. Each region operates independently and is loosely coupled to allow jobs to be scheduled in any region and requests to flow transparently to the correct region.

When ACLs are enabled, Nomad depends on an "authoritative region" to act as a single source of truth for ACL policies and global ACL tokens. The authoritative region is configured in the server stanza of agents, and all regions must share a single authoritative source. Any ACL policies or global ACL tokens are created in the authoritative region first. All other regions replicate ACL policies and global ACL tokens to act as local mirrors. This allows policies to be administered centrally, and for enforcement to be local to each region for low latency.

Global ACL tokens are used to allow cross region requests. Standard ACL tokens are created in a single target region and not replicated. This means if a request takes place between regions, global tokens must be used so that both regions will have the token registered.

---
name: nomad-chapter-security-ACL-multi-region-configuration-2
# Multi-Region Configuration.
.small[
Nomad depends on an "Authoritative Region" when ACLs are enabled
* Authoritative Region is the Source of Truth For:
  * ACL Policies
  * Global ACL tokens
* All Regions Replicate ACL Policies and Global ACL Tokens
  * Central policy administration
  * Local policy enforcement

]
???

When ACLs are enabled, Nomad depends on an "authoritative region" to act as a single source of truth for ACL policies and global ACL tokens. The authoritative region is configured in the server stanza of agents, and all regions must share a single authoritative source. Any ACL policies or global ACL tokens are created in the authoritative region first. All other regions replicate ACL policies and global ACL tokens to act as local mirrors. This allows policies to be administered centrally, and for enforcement to be local to each region for low latency.

Global ACL tokens are used to allow cross region requests. Standard ACL tokens are created in a single target region and not replicated. This means if a request takes place between regions, global tokens must be used so that both regions will have the token registered.


---
name: nomad-chapter-security-tls
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Securing Nomad Clusters with TLS

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: nomad-chapter-security-TLS-overview-1
# Nomad TLS Overview

* Securing Nomad's cluster communication is not only important for security but can even ease operations by preventing mistakes and misconfigurations.
* Nomad optionally uses mutual TLS (mTLS) for all HTTP and RPC communication.


---
name: nomad-chapter-security-TLS-overview-2
# Nomad TLS Overview

.small[
Nomad's use of mTLS provides the following benefits:
* Prevents unauthorized Nomad access
* Prevents observing or tampering with Nomad communication
* Prevents client/server role or region misconfigurations
* Prevents other services from masquerading as Nomad agents
]

???

---
name: nomad-chapter-security-TLS-overview-3
# Nomad TLS Overview
.small[
Nomad's use of mTLS has the benefit that it prevents region misconfiguration.

**It Verifies that:**
* The node is in the expected Region.
* The node is configured for the role.

It prevents other services with access to certificates from the same CA from impersonating Nomad agents.
]

???
Preventing region misconfigurations is a property of Nomad's mTLS not commonly found in the TLS implementations on the public Internet. While most uses of TLS verify the identity of the server you are connecting to based on a domain name such as example.com, Nomad verifies the node you are connecting to is in the expected region and configured for the expected role (e.g. client.us-west.nomad). This also prevents other services who may have access to certificates signed by the same private CA from masquerading as Nomad agents. If certificates were identified based on hostname/IP then any other service on a host could masquerade as a Nomad agent.

---
name: nomad-chapter-security-TLS-certificates-1
# Certificates

* Certificate Requirements:
  * Certificates must be signed by a **Private** CA.
  * All certificates must be signed by the same CA.

???

---
name: nomad-chapter-security-TLS-certificates-2
# Node Certificates

* Nomad hosts are ephemeral, so creating a certificate for each hostname has no security benefit.
* To provide the security needed, certificates must be signed with their region and role:
  * `client.global.nomad` client node for global region
  * `server.us-west.nomad` server node for us-west region

???

---
name: nomad-chapter-security-TLS-certificates-3
# Node Certificates

* Adding `localhost` and `127.0.0.1` as subject alternate names (SANs) will allow tools like curl to communicte with the Nomad HTTP API endpoints from the same host.
* Adding the DNS resolvable hostname as a SAN will allow remote HTTP requests from third party tools.

???

---
name: nomad-chapter-security-TLS-certificates-4
class: col-2
# TLS Configuration

Adding TLS configuration to the server and client configurations:
* Copy the CA, Certificate and keyfile to the server.
* Edit the config hcl file and add the `tls` block.

<br>
```json

tls {
  http = true
  rpc  = true

  ca_file   = "nomad-ca.pem"
  cert_file = "server.pem"
  key_file  = "server-key.pem"

  verify_server_hostname = true
  verify_https_client    = true
}
```

???

---
name: nomad-chapter-security-vault-pki
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Using Vault's PKI Secrets Engine with Nomad

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: nomad-chapter-security-vault-pki-1
# Vault PKI Secrets Engine Integration

* Securing your Nomad nodes with TLS certificates is an important part of managing your cluster.

* To increase the level of security that TLS provides you need to:
  * Have a short TTL for each certificate.
  * Regularly rotate these certificates.

* In previous slides, we discussed what is needed to accomplish this. This can take a long time with many manual steps.

???

---
name: nomad-chapter-security-vault-pki-2
# Vault PKI Secrets Engine Integration
* When your clusters and regions start growing in number, this process becomes cumbersome and will lead to mistakes.
* Nomad can make use of [Consul Template](https://github.com/hashicorp/consul-template) to integrate with Vault's [PKI secrets engine](https://www.vaultproject.io/docs/secrets/pki).
* This allows:
  * Automatic Generation of dynamic certificates for each node
  * Automatic renewal of these certificates for each node
  * A unique relativly short TTL certificate per node
  * Automatic certificate rotation by Consul Template

???

---
name: nomad-chapter-security-lab
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad ACLs Lab

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: lab-nomad-acls
# 👩‍💻 Nomad ACLs Lab
* In this lab, you'll configure a Nomad cluster to use ACLs.
* You'll also see how ACLs allow some users to do things like running jobs while only allowing other users to monitor them.
* You'll do this in the first challenge, "Run the Nomad Servers and Clients", of the **Nomad Access Control Lists (ACLs)** Instruqt track.
* Your instructor will provide a link to it.

???
* Now, you can configure ACLs for a Nomad cluster in another Instruqt track.
* We'll be running the Instruqt track "Nomad Access Control Lists (ACLs)"

---
name: lab-challenge-1.1
# 👩‍💻 Lab Challenge 1.1: Run Servers and Clients

* Start the "Nomad Access Control Lists (ACLs)" track by clicking the "Run the Nomad Servers and Clients" challenge of the track.
* While the challenge is loading, read the notes in both screens.
* Click the green "Start" button to start the first challenge.
* Follow the instructions on the right side of the challenge.
* After completing all the steps, click the green "Check" button to see if you did everything right.
* You can also click the "Check" button for reminders.

???
* Give the students some instructions for starting their first challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminded of what they should do next.

---
name: lab-challenge-1.2
# 👩‍💻 Lab Challenge 1.2: Configure Server ACLs

* In this challenge, you'll configure ACLs for the Nomad servers.
* Instructions:
  * Click the "Configure Nomad Server ACLs" challenge of the "Nomad Access Control Lists (ACLs)" track.
  * Then click the green "Start" button.
  * Follow the challenge's instructions.
  * Click the green "Check" button when finished.

???
* In this challenge, you will configure ACLs for the Nomad servers.

---
name: lab-challenge-1.3
# 👩‍💻 Lab Challenge 1.3: Configure Client ACLs

* In this challenge, you'll configure ACLs for the Nomad clients.
* Instructions:
    * Click the "Configure Nomad Client ACLs" challenge of the "Nomad Access Control Lists (ACLs)" track.
    * Then click the green "Start" button.
    * Follow the challenge's instructions.
    * Click the green "Check" button when finished.

???
* In this challenge, you will configure ACLs for the Nomad clients.

---
name: lab-challenge-1.4
# 👩‍💻 Lab Challenge 1.4: Bootstrap Nomad ACLs

* In this challenge, you'll bootstrap the ACL system for your Nomad cluster.
* Instructions:
    * Click the "Bootstrap Nomad ACLs" challenge of the "Nomad Access Control Lists (ACLs)" track.
    * Then click the green "Start" button.
    * Follow the challenge's instructions.
    * Click the green "Check" button when finished.

???
* In this challenge, you will bootstrap the ACL system for your Nomad cluster.

---
name: lab-challenge-1.5
# 👩‍💻 Lab Challenge 1.5: Use Nomad ACLs

* In this challenge, you'll see how Nomad ACLs allow one user to run jobs while only allowing another user to monitor them.
* Instructions:
    * Click the "Use Nomad ACLs" challenge of the "Nomad Access Control Lists (ACLs)" track.
    * Then click the green "Start" button.
    * Follow the challenge's instructions.
    * Click the green "Check" button when finished.

???
* In this challenge, you will see how Nomad ACLs allow one user to run jobs while only allowing another user to monitor them

---
name: chapter-security-Summary
# 📝 Chapter 1 Summary

In this chapter, you learned a lot about Nomad security, including:
1. Nomad Encryption
2. Nomad Access Control Lists (ACLs)
3. Securing Nomad Clusters with TLS
4. Using Vault's PKI Secrets Engine with Nomad

You also did a hands-on lab in which you configured a cluster to use Nomad ACLs.

???
* Summarize what we covered in the security chapter
