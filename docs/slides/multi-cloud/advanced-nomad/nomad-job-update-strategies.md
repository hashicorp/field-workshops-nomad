name: chapter-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad Job Update Strategies

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
* This chapter covers how existing jobs can be dynamically updated in Nomad.

---
layout: true

.footer[
- Copyright © 2021 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: chapter-topics
# Nomad Job Update Strategies
* In this chapter, you will learn about these Nomad job update strategies:
  * Rolling Updates
  * Blue/Green Deployments
  * Canary Deployments
* Updates are applied when you re-run a Nomad job with the `nomad job run` command.
* You will also do a hands-on Instruqt lab to explore these update strategies yourself.

???
* We'll be discussing Nomad's job update strategies in this chapter.
* There are 3 options.

---
name: update-strategy-applicability
# Update Strategy Applicability
* Nomad's update strategies can be used for **all** applications orchestrated by Nomad, whether containerized or not.
* They are configured with the `update` stanza in Nomad job specifications at the job level or at the task group level.
* If done at the job level, the specified update strategy is applied to all of the job's task groups.

???
* Before we discuss details, we want to emphasize that Nomad's update strategies can be used for all applications orchestrated by Nomad, whether containerized or not.
* Additionally, you can specify them for an entire job or for individual task groups within jobs.

---
name: rolling-updates
# Rolling Updates
* [Rolling Updates](https://learn.hashicorp.com/tutorials/nomad/job-rolling-update) are the default update strategy within Nomad.
* In a rolling update, new allocations of a task group gradually replace existing allocations in batches.
* The `max_parallel` attribute of the `update` stanza specifies how many allocations should be replaced in parallel.
* However, Nomad only advances from one batch of parallel allocations to the next batch if all tasks deployed in the previous batch are healthy.
* The health of allocations can be based on task states, Consul health checks, or states explicitly set by Nomad operators.

???
* Rolling updates are the default update strategy in Nomad.
* New allocations gradually replace existing allocations.

---
name: rolling-update-example
class: compact
# A Rolling Update Example
* Here is an example of a rolling update configuration:

```hcl
group "api" {
  count = 6
  update {
    max_parallel      = 2
    health_check      = "checks"
    min_healthy_time  = "30s"
    healthy_deadline  = "2m"
    progress_deadline = "10m"
  }
```

* Since `count` is 6 and `max_parallel` is 2, re-running the job would replace 2 allocations at a time until all 6 of the original allocations were replaced.

???
* Here is an example of a rolling update configuration.
* Two allocations will be replaced at a time until all 6 of the original allocations are replaced.
* The health of new allocations will be based on Consul health checks.
* Each allocation must be healthy for 30 seconds and must be healthy within 2 minutes, or the allocation is marked as unhealthy.
* If the `progress_deadline` attribute of the `update` stanza were set to 0, a single unhealthy allocation would cause the deployment to fail.
* If it is set above zero, when an allocation fails, a new one is started. But `count` allocations must be healthy by the progress deadline, or the deployment will fail.

---
name: blue-green-deployments
class: compact
# Blue/Green Deployments
* In a [Blue/Green Deployment](https://learn.hashicorp.com/tutorials/nomad/job-blue-green-and-canary-deployments#bluegreen-deployments), two different versions of an application are run side-by-side so that they can be compared.
* In the Nomad context, a number of new allocations equal to the `count` of the task group are deployed while the same number of allocations that were previously deployed continue to run.
* Blue/Green deployments in Nomad are configured by setting the `canary` attribute of the `update` stanza equal to the `count` of the task group.
* The deployment has to be manually [promoted](https://nomadproject.io/docs/commands/deployment/promote/) before the old allocations are terminated.
* However, you can [fail](https://nomadproject.io/docs/commands/deployment/fail/) the deployment instead if you prefer the old version.

???
* Blue/Green deployments allow two versions of an application to be compared side-by-side.
* In Nomad, this means that new allocations run concurrently with the existing ones.
* You must then promote or fail the deployment.

---
name: blue-green-example
# A Blue/Green Deployment Example
* Here is an example of a blue/green deployment configuration:

```hcl
group "api" {
  count = 6
  update {
    max_parallel      = 1
    canary            = 6
    min_healthy_time  = "30s"
    healthy_deadline  = "2m"
    progress_deadline = "10m"
    auto_revert       = true
  }
```

???
* Here is an example of a blue/green deployment configuration.
* Note that `canary` was set equal to the task group's `count`.
* In this case, all 6 new allocations are deployed in parallel despite `max_parallel` being set to 1.
* `max_parallel` only is used after the deployment is promoted, at which point, the old allocations are stopped one at a time.

---
name: canary-deployments
# Canary Deployments
* In a [Canary Deployment](https://learn.hashicorp.com/tutorials/nomad/job-blue-green-and-canary-deployments#deploy-with-canaries), a small number of new instances of an application are deployed alongside the existing one.
* Coal miners used to take canaries into mines since the birds got sick from dangerous gas leaks before the miners did.
* In the Nomad context, a number of new allocations equal to the `canary` attribute of the `update` stanza are deployed.
* Note that a Blue/Green deployment in Nomad is a special case of a Canary deployment.
* In practice, `canary` is usually set to 1 (Canary) or to `count` (Blue/Green).

???
* In a Canary Deployments, a small number of new instances of an application are deployed alongside the existing one.
* In Nomad, this usually means that one new allocation is deployed.
* When the deployment is promoted, one old allocation is stopped and `count` - 1 new allocations are rolled out, replacing the original ones one at a time until only the new ones are running.

---
name: canary-example
class:compact
# A Canary Deployment Example
* Here is an example of a canary deployment configuration:

```hcl
group "api" {
  count = 6
  update {
    max_parallel     = 1
    canary           = 1
    min_healthy_time = "30s"
    healthy_deadline = "2m"
    auto_revert      = false
  }

```

* In this and the last example, we included `auto_revert`; if set to `true`, an unhealthy deployment causes Nomad to revert the job to its last version.

???
* Here is an example of a Canary deployment.
* `canary` is set to 1.
* If we wanted things to go faster after promoting the deployment, we could set `max_parallel` to 5.

---
name: lab-job-update-strategies
class: compact
# 👩‍💻 Nomad Job Update Strategies Lab
* In this lab, you'll deploy Nomad jobs that run a MongoDB data base, a chat web app, and nginx (as a load balancer for the web app).
* You'll then update the chat app job 3 times, first with a rolling update, then with a blue/green deployment, and finally with a canary deployment.
* As you do this, the background color of the chat app will change from light to dark and back again.
* You'll do this using the Instruqt track **Nomad Job Update Strategies**.
* Your instructor will provide a link to it.

???
* Now, you can explore Nomad job update strategies hands-on
* You'll be running the Instruqt track "Nomad Job Update Strategies"

---
name: chapter-Summary
# 📝 Chapter Summary

In this chapter you did the following:
* Learned about Nomad's job update strategies:
  * Rolling Updates
  * Blue/Green Deployments
  * Canary Deployments
* Actually used all 3 strategies in an Instruqt lab.

???
* You now know a lot more about Nomad's job update strategies than you did yesterday.
