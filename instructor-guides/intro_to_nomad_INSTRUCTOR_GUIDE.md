# Introduction to Nomad - Instructor Guide

This guide will prepare you to deliver a half-day [Introduction to Nomad Workshop](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss). This workshop content is suitable for HashiCorp community members, prospects and customers. The workshop is a combination of lecture slides and hands-on Instruqt labs that introduce new users to some of Nomad's features. This workshop focuses on open-source features and is targeted toward new users. The workshop may be presented in-person, over the web, or as a self-guided tutorial.

There is also an [Advanced Nomad Workshop](https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/advanced-nomad/#1) which covers advanced Nomad OSS features and Nomad Enterprise.

The workshop alternates between lectures with accompanying slides and hands-on lab exercises. New concepts that are introduced in the slides are reinforced in the labs. Participants will learn both the theory and practice of Nomad. As an instructor you should be well familiar with the slide deck and the Instruqt tracks used in the workshop. Go through the course and make sure you understand all of the major concepts and lab exercises.

When possible you should attend a live training session to observe and learn from another instructor. We will also have video recordings of this workshop available soon.

### Prerequisites
Prerequisites are minimal. All that is required to participate in the workshop is a web browser and Internet access. No software needs to be downloaded or installed. Self-contained lab environments run on the [Instruqt](https://play.instruqt.com/hashicorp) platform, and markdown-based slide decks are published as Github Pages websites.

The Instruqt tracks include terminal tabs that can be used to execute Nomad CLI commands. They also include the Nomad UI. The Nomad Multi-Server Cluster track also include the Consul UI.

All instructors and TAs from HashiCorp should be sure to register themselves with Instruqt and then post a message in our Slack channel, #proj-instruqt, asking to be added to the HashiCorp organization within Instruqt. This is important even if the tracks are public since only members of the HashiCorp organization can see the useful "Skip to Challenge" button on challenges of tracks within this organization.

### Email Invitation
Here is some boilerplate text you can use or customize when inviting or announcing your workshop:

```
Introduction to Nomad
A hands-on technical workshop

Learn how to configure Nomad clusters and run jobs in them. Nomad is an easy-to-use and flexible workload orchestrator that enables organization to automate the deployment of containerized and non-containerized applications in private and public clouds. Nomad is easy for beginners and powerful for experts. Join us for a half-day training that will get you up and running quickly with Nomad.

Topics covered in the workshop include:

* Nomad Overview
* Nomad Concepts and Architecture
* Interacting with Nomad
* Nomad Jobs and Drivers
* Running Nomad Clusters and Jobs
* Running Multi-Server Nomad/Consul Clusters
* Monitoring Nomad Jobs

The only prerequisites for this workshop are a web browser and willingness to learn.
```

### Markdown Slide Deck
The slide deck for this training is published here:

#### https://hashicorp.github.io/field-workshops-nomad/slides/multi-cloud/nomad-oss

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

https://play.instruqt.com/hashicorp/tracks/nomad-basics

Go through this track start to finish and make sure you understand all the challenges. They're all pretty easy since the focus here is just learning how to use the Nomad CLI, the Nomad UI, and the Nomad HTTP API to run, check the status of, and stop a simple Nomad job that runs redis.

https://play.instruqt.com/hashicorp/tracks/nomad-simple-cluster

Go through this track start to finish and make sure you understand all the challenges. After setting up a simple cluster with 1 Nomad server and 2 Nomad clients, you'll create and run a simple Nomad job, monitor it, and then modify it to run more instances of redis.

https://play.instruqt.com/hashicorp/tracks/nomad-multi-server-cluster

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to bootstrap a Nomad cluster with 3 servers in two different ways. They'll first bootstratp it manually. They'll then bootstrap it using Consul.  As a bonus, they can then deploy a job that shows off Nomad's integration with Consul Connect.

https://play.instruqt.com/hashicorp/tracks/nomad-monitoring

Go through this track start to finish and make sure you understand all the challenges. In this track, students learn how to monitor a Nomad cluster and jobs using Prometheus. Fabio is used as a reverse proxy server. Both Prometheus and Fabio are themselves run as Nomad jobs. This lab builds on the knowledge about running jobs that students have learned in earlier tracks.

### Configuring the Instruqt Pools
We recommend that you configure Instruqt pools for each Instruqt track used in this workshop 1-2 hours before your workshop begins. Please see this Confluence [doc](https://hashicorp.atlassian.net/wiki/spaces/SE/pages/511574174/Instruqt+and+Remark+Contributor+Guide#InstruqtandRemarkContributorGuide-ConfiguringInstruqtPools) for instructions.

### Timing
The following schedule assumes you have a group of participants who are brand new to Nomad. You should budget about four hours for this workshop including two short breaks. This is meant as a guideline, you can adjust as needed.

0:00 - 0:10 - Wait for attendees, make introductions<br>
0:10 - 0:20 - Nomad Overview<br>
0:20 - 0:50 - Nomad Concepts and Architecture<br>
0:50 - 1:00 - Interacting with Nomad<br>
1:00 - 1:25 - Lab: Nomad Basics<br>
1:25 - 1:30 - Break<br>
1:30 - 1:50 - Nomad Jobs and Drivers<br>
1:50 - 2:05 - Running Nomad Clusters and Jobs<br>
2:05 - 2:30 - Lab: Nomad Simple Cluster<br>
2:30 - 2:45 - Running Multi-Server Nomad/Consul Clusters<br>
2:45 - 3:10 - Lab: Nomad Multi-Server Cluster<br>
3:10 - 3:15 - Break<br>
3:15 - 3:30 - Monitoring Nomad Jobs<br>
3:30 - 3:55 - Lab: Nomad Monitoring <br>
3:55 - 4:05 - Wrap-up<br>
