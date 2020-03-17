name: chapter-3-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 3
## Stateful Workloads with Host Volumes

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* This chapter covers running stateful workloads with Nomad Host Volumes.

---
layout: true

.footer[
- Copyright &copy; 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-3-topics
# Stateful Workloads with Nomad Host Volumes
* Stateful Workloads Overview
* Stateful Workloads Hands on Track

---
name: nomad-stateful-workloads-overview
## Stateful Workloads Overview

Nomad applications are generally deployed in 2 configurations:

* Stateful
* Stateless

**Stateless** applications are relatively easy to deploy as the state is thrown away after the job has run.

**Stateful** applications on the other hand require somewhere to store data when they are running

???

---
name: nomad-stateful-workloads-overview-2
## Stateful Workloads Overview

Nomad allows for mounting persistant data volumes in 2 ways:

* Local Storage Volumes
* Remote Storage Volumes

These can be presented by using:

**[Host Volume Mounts](https://nomadproject.io/docs/configuration/client/#host_volume-stanza)**

**[Docker Volume Drivers](https://nomadproject.io/docs/drivers/docker/#inlinecode-volumes-16)**

???

---
name: nomad-stateful-workloads-overview-3
## Stateful Workloads Overview

Nomad host volumes allows you to mount any directory on a client into an allocation.
These directories could be any one of the following:

* Simple Local Directory (/opt/coolapp/data/)
* NFS Mountpoint (mount -t nfs 10.10.0.10:/backups /var/backups)
* GlusterFS (gfs1.gluster-host.intern:/datastore /mnt/datastore)

These mounts can then be connected to [tasks](https://nomadproject.io/docs/job-specification/task/) within a [task group](https://nomadproject.io/docs/job-specification/group/)

???

---
name: nomad-stateful-workloads-overview-4
## Stateful Workloads Overview

Nomads Docker task driver support enables the integration of software-defined storage (SDS) solutions like Portworx to support Docker stateful workloads.

Nomad does **NOT** manage storage pools or replication. The SDS provider should manage that.

???

---
name: nomad-stateful-workloads-overview-5
## Stateful Workloads Hands on Track

Some hands on experience using host volumes for Stateful applications in nomad can be found here:

(https://instruqt.com)


???