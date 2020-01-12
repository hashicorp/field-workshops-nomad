name: nomad-chapter-3-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 3
## Interacting with Nomad

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss the various ways of interacting with Nomad: the CLI, UI, and HTTP API

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-3-topics
# Chapter 3 Topics

We will be interacting with Nomad using the...
1. Nomad [CLI](https://www.nomadproject.io/docs/commands/index.html)
2. Nomad [UI](https://www.nomadproject.io/guides/web-ui/)
3. Nomad [HTTP API](https://www.nomadproject.io/api/index.html)


???
* During this section, we'll be interacting with Nomad utilizing the CLI, the UI, and the HTTP API.

---
name: chapter-3-Nomad-CLI
# The Nomad CLI

* The Nomad CLI is a Go application.
* It runs on macOS, Windows, Linux, and other operating systems.
* You can download the latest version [here](https://www.nomadproject.io/downloads.html).

???
* The Nomad CLI is distributed as a simple Go binary.
* It supports multiple operating systems.  Just download and run.

---
name: chapter-3-Nomad-Installation
# Installing Nomad

Installing the Nomad Application on your machine is simple
* Download the zip file for your operating environment
* Unpack the `nomad` binary
* Place the binary in your operating path

See this [tutorial](https://www.nomadproject.io/guides/install/index.html) for more details.

???
* Feel free to install Nomad on your favorite operating environment.  
* For this presentation, it isn't necessary, but if yuou want to continue working with and learning Nomad, it is recommended.

---
name: some-cli-commands
# Some Basic Nomad CLI Commands

* `nomad version` tells you the version of Nomad you are running.
* `nomad` by itself will give you a list of many Nomad CLI commands.
  * The list starts with the most common ones.


The `-h`, `-help`, and `--help` flags can be added to get help for any Nomad CLI command.

???
* If you've ever used any CLI, you can probably get by with these commands for Nomad.
* Easily see the nomad version, list of commands, and get help on any of the commands

---
name: getting-started-with-instruqt
# Doing Labs with Instruqt
* [Instruqt](https://instruqt.com/) is the platform used for HashiCorp workshops.
* Instruqt labs are run in "tracks" that are divided into "challenges".
* If you've never used Instruqt before, start with this [tutorial](https://instruqt.com/public/tracks/getting-started-with-instruqt).
* Otherwise, you can skip to the next slide.

???
* We'll be using the Instruqt platform for labs in this workshop.
* Don't worry if you've never used it before: there is an easy tutorial that you can run through in 5-10 minutes.

---
name: lab-nomad-basics-challenge-1
# 👩‍💻 Nomad Basics Lab
* In this lab, you'll run some of the Nomad CLI commands.
* You'll do this in the first challenge, "The Nomad CLI", of the "Nomad Basics" Instruqt track using the URL:
https://instruqt.com/hashicorp/tracks/nomad-basics.

???
* Now, you can try running some Nomad CLI commands yourself in the first challenge of our first Instruqt track in this workshop.
* We'll be running the Instruqt track "Nomad Basics"

---
name: lab-challenge-3.1
# 👩‍💻 Lab Challenge 3.1: Using the Nomad CLI

* Start the "Nomad Basics" track by clicking the purple "Start" button on the "Nomad CLI" challenge of the track.
* While the challenge is loading, read the notes in both screens.
* Click the green "Start" button to start the "Nomad CLI" challenge.
* Follow the instructions on the right side of the challenge.
* After completing all the steps, click the green "Check" button to see if you did everything right.
* You can also click the "Check" button for reminders.

???
* Give the students some instructions for starting their first challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminded of what they should do next.

---
name: lab-challenge-3.2
# 👩‍💻 Lab Challenge 3.2: Running a Dev Nomad Agent

* In this challenge, you'll run your first Nomad agent in "dev" mode.
* You'll query the status of the node and the status of the Nomad cluster.
* Instructions:
  * Click the "Run a Dev Mode Nomad Agent" challenge of the "Nomad Basics" track.
  * Then click the green "Start" button.
  * Follow the challenge's instructions.
  * Click the green "Check" button when finished.

???
* Just to get started, we need to run the Nomad Agent.  We'll do this in "dev" mode for simplicity
* We're going to run a couple basic commands, just to view the status of the Nomad node, as well as the Cluster

---
name: lab-challenge-3.3
# 👩‍💻 Lab Challenge 3.3: Run Your First Nomad Job

* In this challenge, you'll run your first Nomad job.
* Using the Nomad CLI and UI, you will ...
    * Start and Stop the redis job.
    * Observe the job status through transitions.
* Instructions:
    * Click the "Run Your First Nomad Job" challenge of the "Nomad Basics" track.
    * Then click the green "Start" button.
    * Follow the challenge's instructions.
    * Click the green "Check" button when finished.

???
* We have a sample job file, called redis.nomad, that you can take a look at
* You're going to use Nomad to perform some basic operations on that job file.
* You'll also perform similar operations, but using the Nomad UI

---
name: lab-challenge-3.4
# 👩‍💻 Lab Challenge 3.4: Use Nomad's HTTP API

* In this challenge, you'll use Nomad's HTTP API to do what you did in the previous challenge.
* Instructions:
    * Click the "Use Nomad's HTTP API" challenge of the "Nomad Basics" track.
    * Then click the green "Start" button.
    * Follow the challenge's instructions.
    * Click the green "Check" button when finished.

???
* We're going to do the same things now, but using the HTTP API instead of the CLI
* You're going to use Nomad to perform some basic operations on that job file.

---
name: chapter-3-Summary
# 📝 Chapter 3 Summary

In this section you were able to:
* Learn about and use with Nomad's Interfaces (CLI/UI/API)
* Create, stop, and manage simple Nomad jobs

???
* You've already started using some core Nomad features
* Setting up an agent and managing jobs can be quite simple.
