# Advanced Nomad - Instructor Guide

This guide will prepare you to deliver a half-day [Advanced Nomad Workshop](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/advanced-nomad/#1). This workshop content is suitable for HashiCorp community members, prospects and customers. The workshop is a combination of lecture slides and hands-on Instruqt labs that introduce users to advanced Nomad OSS features and to Nomad Enterprise. The workshop may be presented in-person, over the web, or as a self-guided tutorial.

Students participating in this workshop should first have completed the [Introduction to Nomad Workshop](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss) which covers introductory Nomad OSS features.

The workshop alternates between lectures with accompanying slides and hands-on lab exercises. New concepts that are introduced in the slides are reinforced in the labs. Participants will learn both the theory and practice of Nomad. As an instructor you should be well familiar with the slide deck and the Instruqt tracks used in the workshop. Go through the course and make sure you understand all of the major concepts and lab exercises.

When possible you should attend a live training session to observe and learn from another instructor. We will also have video recordings of this workshop available soon.

### Prerequisites
Prerequisites are minimal. All that is required to participate in the workshop is a web browser and Internet access. No software needs to be downloaded or installed. Self-contained lab environments run on the [Instruqt](https://play.instruqt.com/hashicorp) platform, and markdown-based slide decks are published as Github Pages websites.

The Instruqt tracks include terminal tabs that can be used to execute Nomad CLI commands. They also include the Nomad UI and in some cases the Consul UI.

All instructors and TAs from HashiCorp should be sure to register themselves with Instruqt and then post a message in our Slack channel, #proj-instruqt, asking to be added to the HashiCorp organization within Instruqt. This is important even if the tracks are public since only members of the HashiCorp organization can see the useful "Skip to Challenge" button on challenges of tracks within this organization.

### Email Invitation
Here is some boilerplate text you can use or customize when inviting or announcing your workshop:

```
Advanced Nomad
A hands-on technical workshop

This workshop covers advanced Nomad concepts such as securing Nomad clusters with ACLs, controlling job placement, updating jobs, retrieving secrets from Vault, and running stateful workloads with Nomad host volumes. It also covers Nomad Enterprise platform and governance/policy features. Join us for a half-day training that expand your Nomad skills beyond what you learned in the Introduction to Nomad workshop (https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss).

Topics covered in the workshop include:

* Nomad Security
* Nomad Job Placement and Variable Interpolation
* Nomad Job Update Strategies
* Nomad Integration with Vault Using Templates
* Stateful Workloads with Nomad Host Volumes
* Nomad Enterprise Platform Features
* Nomad Governance and Policy Features

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

Participants can register with Instruqt [here](https://play.instruqt.com/signup). Users only need to provide an email and a password. They can then login via email, Google, GitHub, and Twitter.

Students may have questions during the labs. When presenting a workshop be sure to give enough time for all your participants to go through the labs. Remember that this is probably their first time using a tool like Nomad.

As mentioned in the Prerequisites section, all HashiCorp instructors and TAs for workshops should register with Instruqt and then post a message in our Slack channel, #proj-instruqt, asking to be added to the HashiCorp organization in Instruqt.

Members of the HashiCorp organization in Instruqt can hover over any challenge in any track in that organization and see a "Skip to Challenge" button. After starting a track, you can use these buttons to run the track's setup and solve scripts up to the challenge you want to skip to. When skipping to a challenge, always be sure to click the "Normal Skip" button too.

https://play.instruqt.com/hashicorp/tracks/nomad-acls

Go through this track start to finish and make sure you understand all the challenges. This track guides students through the process of enabling Nomad ACLs on a cluster.

https://play.instruqt.com/hashicorp/tracks/nomad-job-placement

Go through this track start to finish and make sure you understand all the challenges. This track focuses on advanced job placement options with Nomad job specifications including the contstraint, spread, and affinity stanzas. It also introduces students to Nomad variable interpolation.

https://play.instruqt.com/hashicorp/tracks/nomad-update-strategies

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to use Nomad's job update strategies: rolling updates, blue/green deployments, and canary deployments. This is done for both a non-containerized web app and for a containerized version of the same app.

https://play.instruqt.com/hashicorp/tracks/nomad-integration-with-vault

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to integrate Nomad with Vault and how to fetch secrets from Vault into a Nomad job.

https://play.instruqt.com/hashicorp/tracks/nomad-host-volumes

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to run stateful workloads in Nomad using Nomad host volumes.

https://play.instruqt.com/hashicorp/tracks/nomad-governance

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn about Nomad Enterprise's Governance features including namespaces, resource quotas, and Sentinel policies. Together with ACLs, these features allow multiple teams to share a Nomad cluster without interfering with each other.

### Configuring the Instruqt Pools
We recommend that you configure Instruqt pools for each Instruqt track used in this workshop 1-2 hours before your workshop begins. Please see this Confluence [doc](https://hashicorp.atlassian.net/wiki/spaces/SE/pages/511574174/Instruqt+and+Remark+Contributor+Guide#InstruqtandRemarkContributorGuide-ConfiguringInstruqtPools) for instructions.

### Timing
You should budget about five hours for this workshop including two short breaks. This is meant as a guideline, you can adjust as needed.

0:00 - 0:10 - Wait for attendees, make introductions<br>
0:10 - 0:50 - Nomad Security<br>
0:50 - 1:20 - Lab: Nomad Access Control Lists (ACLs)<br>
1:20 - 1:35 - Nomad Job Placement and Variable Interpolation<br>
1:35 - 2:00 - Lab: Nomad Advanced Job Placement<br>
2:00 - 2:05 - Break<br>
2:05 - 2:15 - Nomad Job Update Strategies<br>
2:15 - 2:45 - Lab: Nomad Job Update Strategies<br>
2:45 - 3:00 - Nomad Integration with Vault Using Templates<br>
3:00 - 3:30 - Lab: Nomad Integration with Vault<br>
3:30 - 3:35 - Break<br>
3:35 - 3:45 - Stateful Workloads with Nomad Host Volumes<br>
3:45 - 4:10 - Lab: Nomad Host Volumes<br>
4:10 - 4:20 - Nomad Enterprise Platform Features<br>
4:20 - 4:30 - Nomad Governance and Policy Features<br>
4:30 - 5:00 - Lab: Nomad Enterprise Governance<br>
5:00 - 5:10 - Wrap-up<br>
