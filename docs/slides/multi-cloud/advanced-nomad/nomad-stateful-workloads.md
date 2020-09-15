name: chapter-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Stateful Workloads with Nomad

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* This chapter covers running stateful workloads with Nomad.
* It includes using Nomad Host Volumes, Docker volume drivers, and Container Storage Interface (CSI) plugins.

---
layout: true

.footer[
- Copyright &copy; 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-topics
# Stateful Workloads with Nomad
* Stateful Workloads Overview
* Using Nomad Host Volumes
* Using [Portworx](https://docs.portworx.com/install-with-other/nomad) with a Docker Volume Driver
* Using Container Storage Interface (CSI) plugins
* Stateful Workloads Hands-on Labs

???
* Here are the topics we will cover in this chapter.

---
name: types-of-workload
# Types of Workloads

* Nomad workloads are generally deployed in 2 configurations:
  * Stateful
  * Stateless

* **Stateless** workloads are relatively easy to deploy as the state is thrown away after the job has run.
* **Stateful** workloads on the other hand need to store state that can be used if the job is run again.

???
* There are 2 kinds of workloads or applications: stateless and stateful.
* The latter have extra requirements and complexity.

---
name: nomad-storage-volume-options
# Storage Volume Options

* Nomad allows mounting persistant storage in 3 ways:
  * [Nomad Host Volumes](https://nomadproject.io/docs/configuration/client/#host_volume-stanza) deployed to Nomad clients and managed by Nomad.
  * [Docker Volume Drivers](https://www.nomadproject.io/docs/drivers/docker#volume_driver) such as Portworx that are deployed to Nomad clients but are externally managed.
  * [Container Storage Interface (CSI)](https://www.nomadproject.io/docs/internals/plugins/csi) plugins that expose externally managed storage.
* The first and third can be used with several Nomad task drivers, but the second can only be used with the Docker task driver.

???
* Nomad 0.12 offers three choices for mounting persistent data volumes: Host Volumes, Docker Volume Drivers, and CSI plugins.

---
name: nomad-host-volumes
# Using Nomad Host Volumes

* Nomad **Host Volumes** allows you to mount any directory on a Nomad client into allocations.
* These directories can be any of the following:
  * Simple Local Directory (/opt/coolapp/data/)
  * NFS Mountpoint (mount -t nfs 10.10.0.10:/backups /var/backups)
  * GlusterFS (gfs1.gluster-host.intern:/datastore /mnt/datastore)
* These mounts can be used by [tasks](https://nomadproject.io/docs/job-specification/task/) within a [task group](https://nomadproject.io/docs/job-specification/group/) for several [task drivers](https://nomadproject.io/docs/drivers).

???
* Nomad host volumes work with multiple task drivers, including docker, exec, and java.
* They use storage volumes mounted on the Nomad clients.

---
name: nomad-host-volumes-configurationon-client
# Configuring Host Volumes on Nomad Clients
* The `host_volume` stanza is added to the `client` stanza of Nomad configuration files to define host volumes.

```hcl
client {
  enabled = true
  host_volume "mongodb_mount" {
    path      = "/opt/mongodb/data"
    read_only = false
  }
}
```

???
* The [host_volume](https://nomadproject.io/docs/configuration/client/#host_volume-stanza) stanza is added to the `client` stanza of Nomad configuration files to define host volumes.

---
name: nomad-volumes-configurationon-in-jobs
class: smaller
# Using Host Volumes in Nomad Jobs
* The [volume](https://nomadproject.io/docs/job-specification/volume) stanza is added to task groups to use a host volume mounted on the client.

```hcl
volume "mongodb_vol" {
  type = "host"
  source = "mongodb_mount"
}
```
* The [volume_mount](https://nomadproject.io/docs/job-specification/volume_mount) stanza is added to tasks to allow a task to use the task group's volume.

```hcl
volume_mount {
  volume = "mongodb_vol"
  destination = "/data/db"
}
```

???
* The `volume` and `volume_mount` stanzas are added to task groups and tasks respectively to use Nomad host volumes in jobs.

---
name: using-docker-volume-drivers
## Using Docker Volume Drivers
* Nomad's [Docker Task Driver](https://nomadproject.io/docs/drivers/docker) enables the integration of software-defined storage (SDS) solutions like [Portworx](https://docs.portworx.com/install-with-other/nomad) through [Docker Volume Drivers](https://docs.docker.com/engine/extend/plugins_volume/#create-a-volumedriver) to support stateful Docker workloads.
  * Docker volume drivers are enabled with the [volume_driver](https://nomadproject.io/docs/drivers/docker/#volume_driver) stanza.
  * Volumes are mounted using the [volumes](https://nomadproject.io/docs/drivers/docker/#volumes) or [mounts](https://nomadproject.io/docs/drivers/docker/#mounts) stanza.
  * Alternatively, you can use the [mounts](https://nomadproject.io/docs/drivers/docker/#mounts) stanza instead of the above stanzas to exercise more control over volume definitions.
* Nomad does **NOT** manage storage pools or replication for Docker volume drivers. The SDS provider should manage that.

???
* Nomad's Docker driver can be used with external storage solutions using Docker volume drivers.
* Nomad does not manage the storage pools or replication of data in these external storage solutions.

---
name: csi-plugins
class: compact
# Using CSI Plugins
* Nomad 0.11.0 added support for [Container Storage Interface (CSI)](https://www.nomadproject.io/docs/internals/plugins/csi) plugins.
* You can run CSI plugins as Nomad jobs that mount volumes created by your storage providers.
* Examples include AWS EBS volumes, Azure disks, and GCP persistent disks.
* Since the CSI plugins are written by the storage vendors, any CSI plugin that supports Kubernetes can also be used with Nomad.
* The CSI plugins are run as Nomad jobs.
* Since volumes are registered with CSI plugins using the `nomad volume register` command, no configuration changes are needed on Nomad clients.

???
* Nomad 0.11 added support for CSI Plugins.

---
name: csi-plugins-details
class: compact, smaller
# CSI Plugin Details
* CSI Plugins are run by Nomad jobs that use the Docker driver to run Docker containers.
* There are 3 types of CSI plugins: Controllers, Nodes, and Monolith.
* The node plugins are usually run as system jobs.
* A job that registers a CSI plugin uses the [csi_plugin](https://www.nomadproject.io/docs/job-specification/csi_plugin) stanza.

```hcl
csi_plugin {
  id        = "gcepd"
  type      = "controller"
  mount_dir = "/csi"
}
```
* Task groups using several Nomad drivers can claim volumes by using the [volume](https://www.nomadproject.io/docs/job-specification/volume) stanza.
* Tasks in those task groups mount the volumes with the [volume_mount](https://www.nomadproject.io/docs/job-specification/volume_mount) stanza.

???
* CSI Plugins are run by Nomad jobs that use the Docker driver to run Docker containers.
* There are 3 types of plugins.
* Note that monolith plugins simultaneously serve as controllers and nodes.
* The `csi_plugin` stanza is used when registering CSI plugins.

---
name: lab-host-volumes
# 👩‍💻 Nomad Stateful Workloads Lab
* In this lab, you'll learn how to run stateful workloads in Nomad.
* You can chose any of the following 3 Instruqt tracks:
  * [Nomad Host Volumes](https://play.instruqt.com/hashicorp/invite/1cxyk78sgqja)
  * [Nomad Integration with Portworx](https://play.instruqt.com/hashicorp/invite/nrfcdqrghxiq)
  * [Nomad CSI Plugins (GCP)](https://play.instruqt.com/hashicorp/invite/x2ongtdbbbwe)
* To explore using Nomad with the [AWS EBS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html), please see the [Stateful Workloads with Container Storage Interface](https://learn.hashicorp.com/tutorials/nomad/stateful-workloads-csi-volumes) learn track.
* We hope to have an Instruqt track that implements that AWS learn track in the near future.

???
* Now, you can explore running stateful workloads in Nomad hands-on.
* You can chose from 3 different Instruqt tracks.
* Maybe you'll even have time to run more than 1.

---
name: chapter-Summary
# 📝 Chapter Summary

In this chapter you did the following:
* Learned about Nomad's options to run stateful workloads including:
  * Using Nomad host volumes with any task driver
  * Using Docker volume drivers with the Docker driver
  * Using CSI plugins with external storage volumes
* Actually ran an Instruqt lab that used one of these stateful storage options.

???
* You now know a lot more about Nomad's persistent storage options than you did yesterday.
