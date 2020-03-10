name: nomad-enterprise-workshop-part-?
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter ?
## Nomad Automated Upgrades

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
This section discusses Nomad's ability to automatically upgrade an entire cluster of Nomad servers in an automatic and controlled fashion. This can sometimes be referred to as "upgrade migration"

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
class: img-right
name: Automated Upgrade Flow 1
# Upgrade Process

.smaller[
* Existing Cluster, all on 0.10.1
]

![:scale 100%](images/Upgrade-Start.png)

???
- Starting with a basic cluster, all on the same version

---
class: img-right
name: Automated Upgrade Flow 2
# Upgrade Process

.smaller[
* Existing Cluster, all on 0.10.1
* New Servers Introduced
]

![:scale 100%](images/Introduce-New-Servers.png)

???
- New Servers are introduced with newer version
- Great use of Terraform

---
class: img-right
name: Automated Upgrade Flow 3
# Upgrade Process

.smaller[
* Existing Cluster, all on 0.10.1
* New Servers Introduced
* Quorum Achieved, Old Servers Demoted
]

![:scale 100%](images/Demote-Old-Servers.png)

???
- Once enough new servers are introduced, quorum achieved
- Nomad automatically demotes old servers
- Note:  This is default operation and can be overridden

---
class: img-right
name: Automated Upgrade Flow 4
# Upgrade Complete

.smaller[
* Existing Cluster, all on 0.10.1
* New Servers Introduced
* Quorum Achieved, Old Servers Demoted
* Old Servers Removed
]

![:scale 100%](images/Upgraded-Servers.png)

???
- Once the new servers have been promoted old servers can be decommissioned