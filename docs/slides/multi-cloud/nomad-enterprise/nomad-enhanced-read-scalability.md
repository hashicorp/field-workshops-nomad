name: nomad-enterprise-workshop-part-1?
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter ?
## Nomad Enhanced Read Scalability

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???


---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: Scaling Readbility
# Increasing Read Scalability

* Add Non-Voting Servers to Cluster
* Receives Replicated Data, But Never Promoted
* Improves Scheduling Abilities and Read Performance
* Configured in server Stanza with `non_voting_server` Parameter
