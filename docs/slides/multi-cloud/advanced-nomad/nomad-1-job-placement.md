name: chapter-1-title
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Chapter 1
## Nomad Job Placement

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
This is a title slide for the Job Placement chapter.

---
layout: true

.footer[
- Copyright © 2020 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: Job Placement with Constraints, Affinities, and Spread
# Job Placement

- Use the [constraint stanza](https://www.nomadproject.io/docs/job-specification/constraint.html) to strictly limit the set of eligible nodes for placement.
- Use the [affinity stanza](https://www.nomadproject.io/docs/job-specification/affinity.html) to preferentially target a specific class of nodes for specialized workloads.
  - Placement can occur even if no nodes match.
  - Learn more [here](https://www.nomadproject.io/guides/operating-a-job/advanced-scheduling/affinity.html).
- Use the [spread stanza](https://www.nomadproject.io/docs/job-specification/spread.html) of a job to increase its failure tolerance by spreading its instances across multiple physical racks or datacenters.
  - Learn more [here](https://www.nomadproject.io/guides/operating-a-job/advanced-scheduling/spread.html).

???
- Inside the job spec we can set these stanzas to help distrubute tasks and task groups in specific ways

---
name: Constraints
# Constraints

- The [constraint stanza](https://www.nomadproject.io/docs/job-specification/constraint.html) allows restricting the set of eligible nodes.
- Constraints may filter on node attributes using [variable interpolation](https://www.nomadproject.io/docs/runtime/interpolation.html) or custom [client metadata](https://www.nomadproject.io/docs/configuration/client.html#custom-metadata-network-speed-and-node-class).
- Constraints may be specified at the job, task group, or task levels for ultimate flexibility.

???
- Let's talk more about constraints.

---
name: Job and Task Group Level Constraints
class: compact, smaller
# Job and Task Group Level Constraints
- This example shows job level and task group constraints (which will affect all tasks).

```hcl
job "docs" {
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }
  group "example" {
    count = 3
    constraint {
      operator  = "distinct_hosts"
      value     = "true"
    }
  }
```

???
- Here we see both job-level and task group constraints.
- The job-level constraint requires that all task groups in the job run on Linux nodes.
  - Note the use of interpolation.
- The task group constraint requires that all instances of the group run on distinct Nomad client nodes.
---
name: Task Level Constraints
class: smaller
# Task Level Constraints

```hcl
job "docs" {
    task "server" {
      # All tasks must run where "my_custom_value" is greater than 3.
      constraint {
        attribute = "${meta.my_custom_value}"
        operator  = ">"
        value     = "3"
      }
    }
}
```

???
- talk about getting values from node metadata
https://www.nomadproject.io/docs/configuration/client.html#custom-metadata-network-speed-and-node-class

---
name: Affinities
# Affinities

- The [affinity stanza](https://www.nomadproject.io/docs/job-specification/affinity.html) allows operators to express non-binding placement preference for a set of nodes.
- Affinities can be expressed on attributes or on client metadata.
- They can be specified at the job, task group, or task levels.
- If no nodes match a given affinity, placement can still occur.
  - This is different from constraints where placement is restricted to nodes that **DO** meet the constraint's criteria.

???
- More about affinities

---
name: Job and Task Affinities
class: col-2, compact, smaller
# Job and Task Affinities
- Affinities apply to task groups but can be specified within the job and task stanzas as well.
- Job affinities apply to all task groups within the job.
- Task affinities apply to the whole task group that the task is a part of.

<br>
<br>
<br>
<br>
<br>

```hcl
job "docs" {
  affinity {
    attribute = "${node.datacenter}"
    value     = "us-west1"
  }
  task "server" {
    affinity {
      attribute = "${meta.cust_val}"
      operator  = ">"
      value     = "3"
    }
```

???
- talk about affinity

---
name: Weights
class: col-2, smaller
# Weights
- Operators can use the `weight` attribute to express relative preference across multiple affinities.
- Weights range from -100 to 100.
- Negative weights act as anti-affinities, causing nodes that match the condition to be scored lower.
- Here, we see a weight used with a task group affinity.

<br>
<br>
<br>

```hcl

job "docs" {
  group "example" {
    # Prefer the "r1" rack
    affinity {
      attribute  = "${meta.rack}"
      value     = "r1"
      weight    = 50
    }
```

???
- talk about affinity weights: https://nomadproject.io/docs/job-specification/affinity/#inlinecode-weight-11

---
name: Spread
# Spread
- The [spread stanza](https://www.nomadproject.io/docs/job-specification/spread.html) allows operators to increase the failure tolerance of their applications by specifying a node attribute that allocations should be spread over.
- This allows operators to spread allocations over attributes such as datacenter, availability zone, or even racks in a physical datacenter.
- By default, when using spread the scheduler will attempt to place allocations equally among the available values of the given target.

???
- Let's talk about spread.

---
name: Multiple Spread Stanzas
# Using Multiple Spread Stanzas
- A job or task group can have more than one spread stanza with `weights` to express relative preference.
- Multiple nodes are selected to match the `percent` attributes defined in the `target` stanzas of the spread stanza.
- Spread criteria are treated as a soft preference by the Nomad scheduler. If no nodes match a given spread criteria, placement can still occur.

???
- More about spread including the weight, target, and percent parameters

---
name: Spread Example
class: smaller
# Spread Example
```hcl
job "docs" {
  spread {
    attribute = "${node.datacenter}"
  }
  group "example" {
      spread {
        attribute = "${meta.rack}"
        target "r1" {
          percent = 60
        }
        target "r2" {
          percent = 40
        }
      }
```

???
- In this example, the job-level spread stanza spreads the task groups of the job evenly across all Nomad datacenters.
- Additionally, the task group level spread tries to allocate 60% of the groups to rack "r1" and 40% to rack "r2".

---
name: Variable Interpolation
# Variable Interpolation
- Nomad supports interpreting two classes of variables: node attributes and runtime environment variables.
- [Node attributes](https://nomadproject.io/docs/runtime/interpolation/#node-variables) are interpretable in constraints and certain driver fields.
- Runtime [environment variables](https://nomadproject.io/docs/runtime/interpolation/#environment-variables) are not interpretable in constraints because they are only defined once the scheduler has placed them on a particular node.
- Please see the links given above for complete lists of available interpolations.

???
- variable interpolation


---
name: Variable Interpolation With Environment Variables
class: compact
# Variable Interpolation With Environment Variables
- The syntax for interpreting variables is `${<variable>}`
- Here is an example that uses environment variables:

```hcl
task "docs" {
  driver = "docker"
  config {
    image = "my-app"
    # Interpret runtime variables to inject the address to bind to
    # and the location to write logs to.
    args = [
      "--bind", "${NOMAD_ADDR_RPC}",
      "--logs", "${NOMAD_ALLOC_DIR}/logs",
    ]
```

???
- here is an examnple that passes environment variables to arguments used by an application.

---
name: Mixing Node Attributes and Environment Variables
class: small
# Mixing Attributes and Environment Variables
- Here is an example mixing node attributes and environment variables:

```hcl
task "docs" {
  driver = "docker"
  env {
    "DC"      = "Running on datacenter ${node.datacenter}"
    "VERSION" = "Version ${NOMAD_META_VERSION}"
  }
```

???
- variables

---
name: Meta Variable Interpolation
class: small
# Meta Variable Interpolation
- The [meta stanza](https://www.nomadproject.io/docs/job-specification/meta.html) allows for user-defined arbitrary key-value pairs.
- Metadata keys can be interpolated with `${NOMAD_META_<key>}` where `<key>` is the metadata key.
- You would use `${NOMAD_META_VERSION}` to refer to the `VERSION` key defined in this task:

```hcl
task "docs" {
  driver = "docker"
  meta {
    VERSION = "v0.3"
  }
}
```

???
variables
