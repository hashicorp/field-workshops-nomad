name: nomad-enterprise-workshop-part-?
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter ?
## Nomad Redundancy Zones

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
Nomad Redundancy Zones can increase reliability across zone failures.

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: Nomad Redundancy Zones
# Nomad Redundancy Zones

* Without Redundancy Zones
    * Server Cluster in each Availability Zone (3-5 machines per zone)
    * Or give up redundancy with a single Server in each Zone
* With Redundancy Zones
    * Servers are associated with Availability Zones
    * Nomad keeps one voting server in each Zone
    * Cluster Functionality retained across Availabity Zone Failures

???
- Redundancy Zones allows servers to be associated with a zone, and enables clusters to communicate across zones
- Without Redundancy Zones, each Zone would have an independent cluster, or just forego server redundancy
- Using Nomad Autopilot with Redundancy Zones ensures cluster operation continuity in the event of zone failures