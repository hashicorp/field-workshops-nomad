# Advanced Nomad - Instructor Guide

This guide will prepare you to deliver a 3/4-day [Advanced Nomad Workshop](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/advanced-nomad/#1). This workshop content is suitable for HashiCorp community members, prospects and customers. The workshop is a combination of lecture slides and hands-on Instruqt labs that introduce users to advanced Nomad OSS features and to Nomad Enterprise. The workshop may be presented in-person, over the web, or as a self-guided tutorial.

Students participating in this workshop should first have completed the [Introduction to Nomad Workshop](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss) which covers introductory Nomad OSS features.

The workshop alternates between lectures with accompanying slides and hands-on lab exercises. New concepts that are introduced in the slides are reinforced in the labs. Participants will learn both the theory and practice of Nomad. As an instructor you should be well familiar with the slide deck and the Instruqt tracks used in the workshop. Go through the course and make sure you understand all of the major concepts and lab exercises.

When possible you should attend a live training session to observe and learn from another instructor. We will also have video recordings of this workshop available soon.

### Prerequisites
Prerequisites are minimal. All that is required to participate in the workshop is a web browser and Internet access. No software needs to be downloaded or installed. Self-contained lab environments run on the [Instruqt](https://play.instruqt.com/hashicorp) platform, and markdown-based slide decks are published as Github Pages websites.

The Instruqt tracks include terminal tabs that can be used to execute Nomad CLI commands. They also include the Nomad UI and in some cases the Consul UI.

All instructors and TAs from HashiCorp should be sure to register themselves with Instruqt and then post a message in our Slack channel, #proj-instruqt, asking to be added to the HashiCorp organization within Instruqt. This is important even if the tracks are public since only members of the HashiCorp organization can see the useful "Skip to Challenge" button on challenges of tracks within this organization.

### Scheduling your workshop
Please add all workshops, both public and private, to the shared instruqt-workshops Google calendar as follows:

1. Create a new event on the instruqt-workshops calendar and set the name to the name of your workshop which could match a name being used by Field Marketing if it is public or the name of a specific customer and a product if it is private.
2. Set the begin and end times of the event to the begin and end times of your workshop.
3. Include the following information in the description:
    1. The name of the host (probably yourself) after "Host:"
    2. The names of presenters after "Presenters:"
    3. A list of tracks that your workshop will use after "Tracks:", listing the URL of each track on its own line.

Before saving the event, be sure to set the calendar as "instruqt-workshops" instead of your own personal calendar.


### Email Invitation
Here is some boilerplate text you can use or customize when inviting or announcing your workshop:

```
Advanced Nomad
A hands-on technical workshop

This workshop covers advanced Nomad concepts such as controlling job placement, updating jobs, running multi-region jobs across multiple clusters, retrieving secrets from Vault, securing Nomad clusters with ACLs, Nomad autoscaling, and running stateful workloads in Nomad. It also covers Nomad Enterprise platform and governance/policy features including audit logging, namespaces, resource quotas, Sentinel policies, and cross-namespace queries. Join us for a 3/4-day training that expands your Nomad skills beyond what you learned in the Introduction to Nomad workshop (https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss).

Topics covered in the workshop include:
* Nomad Job Placement and Variable Interpolation
* Nomad Job Update Strategies
* Nomad Federation and Multi-Region Deployments
* Nomad Integration with Vault Using Templates
* Nomad Security
* The Nomad Autoscaler
* Nomad Enterprise Platform Features
* Nomad Enterprise Governance and Policy Features
* Stateful Nomad Workloads

The only technical prerequisites for this workshop are a web browser and willingness to learn. But you should have completed the Introduction to Nomad workshop first.
```

### Markdown Slide Deck
The slide deck for this training is published here:

#### https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/advanced-nomad

#### Navigation
Use the arrow keys (up/down or left/right) to navigate back and forth between slides.

Press the `P` key to enter presenter mode and reveal the speaker notes.

Press the `C` key to pop open an external window that will stay synced with your speaker notes window. This is useful for keeping notes on your laptop while showing the presentation on the projector.

#### RemarkJS
The slide deck for this training is written completely in [Markdown](https://guides.github.com/features/mastering-markdown/) using the [RemarkJS](https://remarkjs.com/#1) framework. This allows us to publish slide decks from a source code repository. The slide deck is easy to maintain, lightweight, and can be accessed from anywhere. Updates and changes to the deck can be made quickly and efficiently by simply editing the markdown source files. If you find any mistakes or issues with the slides please add them to our issue tracker:

https://github.com/hashicorp/field-workshops-nomad/issues

### Hands-on Labs
At certain points in the slide deck there are links to the lab exercises. [Instruqt](https://instruqt.com/hashicorp) is our lab platform. While all of the Nomad workshop tracks are actually public, the slides use links to permanent Instruqt invitations that require users to register with Instruqt. We do this so that HashiCorp Field Marketing can collect the emails of users who start tracks during public or private workshops or on their own after following the links from the slides.

Participants can register with Instruqt [here](https://play.instruqt.com/signup). They can then login via email, Google, GitHub, and Twitter.

Students may have questions during the labs. When presenting a workshop be sure to give enough time for all your participants to go through the labs. Remember that this is probably their first time using a tool like Nomad.

As mentioned in the Prerequisites section, all HashiCorp instructors and TAs for workshops should register with Instruqt and then post a message in our Slack channel, #proj-instruqt, asking to be added to the HashiCorp organization in Instruqt.

Members of the HashiCorp organization in Instruqt can hover over any challenge in any track in that organization and see a "Skip to Challenge" button. After starting a track, you can use these buttons to run the track's setup and solve scripts up to the challenge you want to skip to. When skipping to a challenge, always be sure to click the "Normal Skip" button too.

#### Primary Instruqt Tracks
The following tracks are the primary Instruqt tracks used in the Advanced Nomad Workshop:

https://play.instruqt.com/hashicorp/tracks/nomad-job-placement

Go through this track start to finish and make sure you understand all the challenges. This track focuses on advanced job placement options with Nomad job specifications including the contstraint, spread, and affinity stanzas. It also introduces students to Nomad variable interpolation.

https://play.instruqt.com/hashicorp/tracks/nomad-update-strategies

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to use Nomad's job update strategies: rolling updates, blue/green deployments, and canary deployments. This is done for both a non-containerized web app and for a containerized version of the same app.

https://play.instruqt.com/hashicorp/tracks/nomad-federation

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to federate two Nomad clusters (regions) and then how to run a Multi-Region job against both clusters with a single job specification file.

https://play.instruqt.com/hashicorp/tracks/nomad-integration-with-vault

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to integrate Nomad with Vault and how to fetch secrets from Vault into a Nomad job.

https://play.instruqt.com/hashicorp/tracks/nomad-governance

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn about Nomad Enterprise's Governance features including audit logging, namespaces, resource quotas, Sentinel policies, and cross-namespace queries. Together with ACLs, these features allow multiple teams to share a Nomad cluster without interfering with each other.

#### Stateful Workload Instruqt Tracks
Students will be asked to run 1 of the following 3 stateful workload tracks:

https://play.instruqt.com/hashicorp/tracks/nomad-host-volumes

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to run stateful workloads in Nomad using Nomad host volumes.

https://play.instruqt.com/hashicorp/tracks/nomad-and-csi-plugins-gcp

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to run stateful workloads in Nomad using a CSI plugin in GCP.

https://play.instruqt.com/hashicorp/tracks/nomad-and-portworx

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to run stateful workloads using a Docker volume driver (Portworx).

#### Extra Instruqt Tracks
There are also two extra Instruqt tracks that faster students can run if they finish all the other tracks:

https://play.instruqt.com/hashicorp/tracks/nomad-acls

Go through this track start to finish and make sure you understand all the challenges. This track guides students through the process of enabling Nomad ACLs on a cluster.

https://play.instruqt.com/hashicorp/tracks/nomad-on-windows

Go through this track start to finish and make sure you understand all the challenges. This track guides students through the process of running Nomad jobs with 3 different drivers (Docker, Java, and Raw Exec) on Windows.

### Configuring the Instruqt Pools
We recommend that you configure Instruqt pools for each Instruqt track used in this workshop 1-2 hours before your workshop begins. Please see this Confluence [doc](https://hashicorp.atlassian.net/wiki/spaces/SE/pages/511574174/Instruqt+and+Remark+Contributor+Guide#InstruqtandRemarkContributorGuide-ConfiguringInstruqtPools) for instructions.

### Timing
You should budget about 5.5 hours for this workshop including two short breaks. This is meant as a guideline, you can adjust as needed.

0:00 - 0:10 - Wait for attendees, make introductions<br>
0:10 - 0:20 - Nomad Overview<br>
0:20 - 0:35 - Nomad Job Placement and Variable Interpolation<br>
0:35 - 1:05 - Lab: Nomad Advanced Job Placement<br>
1:05 - 1:15 - Nomad Job Update Strategies<br>
1:15 - 1:45 - Lab: Nomad Job Update Strategies<br>
1:45 - 1:50 - Break<br>
1:50 - 2:00 - Nomad Federation and Multi-Region Deployments<br>
2:00 - 2:20 - Lab: Nomad Multi-Region Federation<br>
2:20 - 2:30 - Nomad Integration with Vault Using Templates<br>
2:30 - 3:00 - Lab: Nomad Integration with Vault<br>
3:00 - 3:20 - Nomad Security (Encryption and ACLs)
3:20 - 3:30 - Break<br>
3:30 - 3:40 - The Nomad Autoscaler<br>
3:40 - 3:50 - Nomad Enterprise Platform Features<br>
3:50 - 4:05 - Nomad Governance and Policy Features<br>
4:05 - 4:35 - Lab: Nomad Enterprise Governance<br>
4:35 - 4:45 - Nomad Stateful Workloads<br>
4:45 - 5:15 - Lab: Stateful Workloads<br>
5:15 - 5:30 - Wrap-up and Q&A<br>
