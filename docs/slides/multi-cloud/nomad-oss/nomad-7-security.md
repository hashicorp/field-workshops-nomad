name: nomad-chapter-7-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 7
## Nomad Security

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll provide an overview of Nomad Security

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-7-topics
# Chapter 7 Topics

1. Encryption Overview
2. Nomad Access Control Lists (ACLs)
3. Securing Nomad Clusters with TLS
4. Vault PKI Secrets Engine
5. Hands on LAB Nomad ACLs

???
* This is our topics slide.

---
name: nomad-chapter-7-overview
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 7 - Section 1
## Nomad Security Overview

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: nomad-chapter-7-encryption-overview
# Nomad Encryption Overview

There are two separate encryption systems for Nomad:
* Gossip Traffic Encryption.
* HTTP and RPC Encryption.

Enabling encryption of all its network traffic.

???

---
name: omad-chapter-7-encryption-gossip-1
# Nomad Gossip Traffic Encryption

.smaller[Gossip encryption is enabled by providing an encryption key when starting the server with the `encrypt` parameter or stored in the server configuration file of every server in the region.

The key must be 16 bytes and base64 encoded. Generate a key using the `nomad operator keygen` command.]

```bash
$ nomad operator keygen
cg8StVXbQJ0gPvMd9o7yrg==
```

???

---
name: nomad-chapter-7-encryption-http-rpc-1
# Nomad HTTP and RPC Encryption with TLS

.smaller[* TLS is used to verify the authenticity of servers and clients.
* All servers and clients should have signed key pairs configured.
* Server authenticity can be enforced using:
 * `verify_server_hostname = true` in the **tls** configuration stanza.]

---
name: nomad-chapter-7-encryption-http-rpc-2
# Nomad HTTP and RPC Encryption with TLS

.smaller[* The setting `verify_server_hostname` enforces hostname verification for outbound connections.
* All servers must have a valid certificate for:
  * `server.<region>.nomad`.
  * `localhost` ( for the local cli to validate the name).
* TLS is used to secure the RPC calls between agents.]

???

---
name: nomad-chapter-7-encryption-configuring-the-cli
# Nomad Configuring The Command Line Tool

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
name: nomad-chapter-7-encryption-network-isolation-tls-1
# Nomad Network Isolation with TLS

.smaller[To isolate Nomad agents on a network with TLS enable:
* `verify_https_client`.
* `verify_server_hostname`.

Agents will:
* Require client certificates for all incoming HTTPS connections.
* Verify proper names on all other certificates.

Consul will not attempt to health check agents with **`verify_https_client`** set as it is unable to use client certificates.]

???

---
name: nomad-chapter-7-acls
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 7 - Section 2
## Nomad Access Control Lists (ACL)

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: chapter-7-acls-topics
# Access Control List Topics

1. ACL Overview
2. The ACL System
3. ACL Policies
4. ACL Tokens
5. ACL Capabilities.

???
* This is our topics slide.

---
name: nomad-chapter-7-ACL-overview-1
# Access Control Overview

.small[
* Nomad provides an optional Access Control List (ACL) system.
    * Controls access to data and APIs. 
    * Capability-based
    * Relies on tokens associated with policies
    * Similar to the design of AWS IAM.
]

???

---
name: nomad-chapter-7-ACL-system-overview-2
# The ACL System

.small[
The ACL system is designed to be:
* Easy to use
* Fast to enforce 
* Provide administrative insight.
]

---
name: nomad-chapter-7-ACL-system-overview-3
class: col-2
# The ACL System
.small[
Three major components to the ACL system:
* ACL Policies
* ACL Tokens
* ACL Capabilities
]
.center[![:scale 100%](images/acl-overview.jpg)]

???

---
name: nomad-chapter-7-ACL-policies-1
class: col-2
# ACL Policies
.small[
An ACL policy is a named set of rules.

Each policy must have:
* A unique name
* A rule set.
* A description (Optional)

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
    }
  "}
```
]

---
name: nomad-chapter-7-ACL-policies-2
class: col-2
# ACL Policies
.left-column[
.small[
* Default = Deny/Whitelist.
* No permissions by default.
* Policies allow a set of capabilities or actions.
]]

.right-column[
.small[
**For Example:**

a "readonly" policy might only grant the ability to list and inspect running jobs, but not to submit new ones.
]]
???

---
name: nomad-chapter-7-ACL-policies-3
# ACL Policies
.small[
## Standard Tokens
* A client ACL token can be associated with multiple policies.
* A request is allowed if any of the associated policies grant the capability.

## Management tokens 
* Cannot be associated with policies.
* They are granted all capabilities.
]
---
name: nomad-chapter-7-ACL-policies-4
# ACL Policies
.small[
A special `anonymous` policy can be defined for **anonymous** requests.
* Defines capabilities for **anonymous** requests.
* By default there is no `anonymous` policy

An anonymous request is a request made to Nomad without the `X-Nomad-Token` header specified.

]

???
The special `anonymous` policy can be defined to grant capabilities to requests which are made anonymously. An anonymous request is a request made to Nomad without the `X-Nomad-Token` header specified. This can be used to allow anonymous users to list jobs and view their status, while requiring authenticated requests to submit new jobs or modify existing jobs. By default, there is no `anonymous` policy set meaning all anonymous requests are denied.

---
name: nomad-chapter-7-ACL-tokens-1
class: col-2
# ACL Tokens
.small[
.left-column[
## Tokens Role
* Authenticate Requests
* Authorize Actions
]
.right-column[
## Contains
* Accessor ID
* Secret ID
* Name (Optional)
]]

???
ACL tokens are used to authenticate requests and determine if the caller is authorized to perform an action. Each ACL token has a public Accessor ID which is used to identify the token, a Secret ID which is used to make requests to Nomad, and an optional human readable name. All client type tokens are associated with one or more policies, and can perform an action if any associated policy allows it. Tokens can be associated with policies which do not exist, which are the equivalent of granting no capabilities. The management type tokens cannot be associated with policies, but can perform any action.

---
name: nomad-chapter-7-ACL-tokens-2
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
name: nomad-chapter-7-ACL-tokens-3
# ACL Tokens
* Tokens created locally by default.
  * Not replicated to other regions.
* If `"Global": True`
  * Created in the Authoritive region.
  * Replicated to **all** other regions.
* Local tokens unable to request cross-region.

???
When ACL tokens are created, they can be optionally marked as Global. This causes them to be created in the authoritative region and replicated to all other regions. Otherwise, tokens are created locally in the region the request was made and not replicated. Local tokens cannot be used for cross-region requests since they are not replicated between regions.

---
name: nomad-chapter-7-ACL-capabilities-1
class: col-2
# ACL Capabilities.
.small[
.left-column[
ACL Capabilities are the set of actions that can be performed on a Nomad cluster.
]
.right-column[
* List Jobs
* Submitting Jobs
* Querying Nodes
* etc.
]
]
???
Capabilities are the set of actions that can be performed. This includes listing jobs, submitting jobs, querying nodes, etc.

---
name: nomad-chapter-7-ACL-capabilities-2
# ACL Capabilities.
.small[
* Client tokens are granted capabilities with ACL Policies.
* Management tokens are granted **ALL** capabilities
]
???
A management token is granted all capabilities, while client tokens are granted specific capabilities via ACL Policies.

---
name: nomad-chapter-7-ACL-capabilities-3
# ACL Capabilities and Scope.

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
name: nomad-chapter-7-ACL-multi-region-configuration-1
# Multi-Region Configuration.
.small[
Nomad supports multi-datacenter and multi-region configurations.
* Single-Region Multi-datacenter Configuration.
  * Servers in a region replicate state.
* Multi-Region Configuration
  * Set of servers per region.
  * Regions operate independantly
  * Regions loosely coupled

]
???
Nomad supports multi-datacenter and multi-region configurations. A single region is able to service multiple datacenters, and all servers in a region replicate their state between each other. In a multi-region configuration, there is a set of servers per region. Each region operates independently and is loosely coupled to allow jobs to be scheduled in any region and requests to flow transparently to the correct region.

When ACLs are enabled, Nomad depends on an "authoritative region" to act as a single source of truth for ACL policies and global ACL tokens. The authoritative region is configured in the server stanza of agents, and all regions must share a single authoritative source. Any ACL policies or global ACL tokens are created in the authoritative region first. All other regions replicate ACL policies and global ACL tokens to act as local mirrors. This allows policies to be administered centrally, and for enforcement to be local to each region for low latency.

Global ACL tokens are used to allow cross region requests. Standard ACL tokens are created in a single target region and not replicated. This means if a request takes place between regions, global tokens must be used so that both regions will have the token registered.

---
name: nomad-chapter-7-ACL-multi-region-configuration-2
# Multi-Region Configuration.
.small[
Nomad depends on an "Authorative Region" when ACLS are enabled
* Authoritive Region Source of Truth:
  * ACL Policies
  * Global ACL tokens.
* All Regions Replicate ACL policies and Global ACL tokens
  * Central policy administration.
  * local policy enforcement

]
???

When ACLs are enabled, Nomad depends on an "authoritative region" to act as a single source of truth for ACL policies and global ACL tokens. The authoritative region is configured in the server stanza of agents, and all regions must share a single authoritative source. Any ACL policies or global ACL tokens are created in the authoritative region first. All other regions replicate ACL policies and global ACL tokens to act as local mirrors. This allows policies to be administered centrally, and for enforcement to be local to each region for low latency.

Global ACL tokens are used to allow cross region requests. Standard ACL tokens are created in a single target region and not replicated. This means if a request takes place between regions, global tokens must be used so that both regions will have the token registered.


---
name: nomad-chapter-7-tls
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 7 - Section 3
## Securing Nomad Clusters with TLS

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: nomad-chapter-7-template
# Template.
PLACEHOLDER

???

---
name: nomad-chapter-7-vault-pki
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 7 - Section 4
## Vault PKI Secrets Engine

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???

---
name: nomad-chapter-7-template
# Template.
PLACEHOLDER

???

---
name: nomad-chapter-7-ACL-instruqt-track
# Instruqt Track for Nomad Security (ACLs)

To get some hands on time with ACLs in Nomad go over to the following track

<https://instruqt.com/hashicorp/tracks/nomad-acls>

???