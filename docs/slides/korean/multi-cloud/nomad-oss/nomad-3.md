name: nomad-chapter-3-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 3
## Nomad와의 상호작용

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* In this chapter, we'll discuss the various ways of interacting with Nomad: the CLI, UI, and HTTP API

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
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

* Nomad CLI는 Go로 생성된 애플리케이션
* macOS, Windows, Linux 등 컴파일 가능한 모든 환경에서 실행
* [다운로드 링크](https://www.nomadproject.io/downloads.html) 에서 최신 버전 확인

???
* The Nomad CLI is distributed as a simple Go binary.
* It supports multiple operating systems.  Just download and run.

---
name: chapter-3-Nomad-Installation
# Nomad 설치

Nomad 애플리케이션을 설치하는 것은 간단합니다.
* 운영 환경에 맞는 zip 파일 다운로드
* `nomad` 바이너리로 압축 해제
* 운영체제의 PATH에 바이너리 경로 지정

자세한 내용은이 [튜토리얼](https://www.nomadproject.io/guides/install/index.html)을 참조하세요.

???
* Feel free to install Nomad on your favorite operating environment.  
* For this presentation, it isn't necessary, but if yuou want to continue working with and learning Nomad, it is recommended.

---
name: some-cli-commands
# 기본 Nomad CLI 명령어

* `nomad version` : 현재 실행중인 Nomad 바이너리 버전 확인
* `nomad` 자체적으로 많은 Nomad CLI 명령 목록을 제공합니다.

`-h`,`-help` 및`--help` 플래그를 추가하여 Nomad CLI 명령에 대한 도움말을 얻을 수 있습니다.

???
* If you've ever used any CLI, you can probably get by with these commands for Nomad.
* Easily see the nomad version, list of commands, and get help on any of the commands

---
name: getting-started-with-instruqt
# Instruqt로 실습하기
* [Instruqt](https://instruqt.com/) 는 HashiCorp의 워크샵을 제공하는 플랫폼 입니다.
* Instruqt 랩은 "Challenges"으로 구분 된 "Track"에서 실행됩니다.
* Instruqt를 사용한 적이 없다면 다음의 [tutorial](https://instruqt.com/public/tracks/getting-started-with-instruqt) 을 확인해 보세요.

???
* We'll be using the Instruqt platform for labs in this workshop.
* Don't worry if you've never used it before: there is an easy tutorial that you can run through in 5-10 minutes.

---
name: lab-nomad-basics-challenge-1
# 👩‍💻 Nomad Basics Lab
* 이 실습에서는 일부 Nomad CLI 명령을 실행합니다.
* **Nomad Basics** Instruqt 트랙의 첫 번째 도전 인 "The Nomad CLI"에서이 작업을 수행합니다.

???
* Now, you can try running some Nomad CLI commands yourself in the first challenge of our first Instruqt track in this workshop.
* We'll be running the Instruqt track "Nomad Basics"

---
name: lab-challenge-3.1
# 👩‍💻 Lab Challenge 3.1: Using the Nomad CLI

* 트랙의 "Nomad CLI"챌린지에서 보라색 "Start"버튼을 클릭하여 "Nomad Basics"트랙을 시작합니다.
* 챌린지가 로드되는 동안 두 화면의 메모를 읽으십시오.
* 녹색 "Start"버튼을 클릭하여 "Nomad CLI"도전을 시작합니다.
* 도전의 오른쪽에있는 지침을 따르십시오.
* 모든 단계를 완료 한 후 녹색 "Check"버튼을 클릭하여 모든 작업을 올바르게 수행했는지 확인하십시오.
* 또한 "Check"버튼을 클릭하여 미리 알림을받을 수도 있습니다.

???
* Give the students some instructions for starting their first challenge.
* This also includes instructions for checking that they did everything right.
* Students can also click the green "Check" button to get reminded of what they should do next.

---
name: lab-challenge-3.2
# 👩‍💻 Lab Challenge 3.2: Running a Dev Nomad Agent

* 이 챌린지에서는 "dev"모드에서 첫 번째 Nomad 에이전트를 실행합니다.
* 노드의 상태와 Nomad 클러스터의 상태를 쿼리합니다.
* 지침 :
   * "Nomad Basics"트랙의 "Run a Dev Mode Nomad Agent"챌린지를 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 도전의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* Just to get started, we need to run the Nomad Agent.  We'll do this in "dev" mode for simplicity
* We're going to run a couple basic commands, just to view the status of the Nomad node, as well as the Cluster

---
name: lab-challenge-3.3
# 👩‍💻 Lab Challenge 3.3: Run Your First Nomad Job

* 이 챌린지에서는 첫 번째 Nomad Job을 실행합니다.
* Nomad CLI 및 UI를 사용하면 ...
   * redis Job을 시작하고 중지합니다.
   * Job 상태를 관찰하십시오.
* 지침 :
   * "Nomad Basics"트랙의 "Run Your First Nomad Job"챌린지를 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 도전의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* We have a sample job file, called redis.nomad, that you can take a look at
* You're going to use Nomad to perform some basic operations on that job file.
* You'll also perform similar operations, but using the Nomad UI

---
name: lab-challenge-3.4
# 👩‍💻 Lab Challenge 3.4: Use Nomad's HTTP API

* 이 챌린지에서는 Nomad의 HTTP API를 사용하여 이전 챌린지에서 수행 한 작업을 수행합니다.
* 지침 :
   * "Nomad Basics"트랙의 "Use Nomad 's HTTP API"챌린지를 클릭합니다.
   * 그런 다음 녹색 "Start"버튼을 클릭합니다.
   * 도전의 지시를 따르십시오.
   * 완료되면 녹색 "Check"버튼을 클릭합니다.

???
* We're going to do the same things now, but using the HTTP API instead of the CLI
* You're going to use Nomad to perform some basic operations on that job file.

---
name: chapter-3-Summary
# 📝 Chapter 3 Summary

* 이 섹션에서는 다음을 수행 할 수있었습니다.

  * Nomad의 인터페이스 (CLI / UI / API)에 대해 알아보고 사용
  * 간단한 Nomad 작업 생성, 중지 및 관리

???
* You've already started using some core Nomad features
* Setting up an agent and managing jobs can be quite simple.
