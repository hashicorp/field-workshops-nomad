name: nomad-enterprise-workshop-part-1
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# Nomad Enterprise Workshop
## Job Placement - The Nomad Enterprise Workshop

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
This is a title slide for the skeleton of a first part of a Nomad Enterprise workshop.

---
name: nomad-logo
class: col-3
# This is the Nomad logo (using 3 img tags)
<p>
  <img style="width:200px;height:200px;" src="https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png">
</p>

<p>
  <img style="width:200px;height:200px;" src="https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png">
</p>

<p>
  <img style="width:200px;height:200px;" src="https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png">
</p>

???
This slide has the Nomad logo.

---
layout: true

.footer[
- Copyright © 2019 HashiCorp
- ![:scale 100%](https://hashicorp.github.io/field-workshops-assets/assets/logos/HashiCorp_Icon_Black.svg)
]

---
name: Job Placement with Constraints, Affinities, and Spread
# Job Placement

<br>

- Use the [constraint stanza](https://www.nomadproject.io/docs/job-specification/constraint.html) to limit the set of eligible nodes for placement.
- Increase the [failure tolerance](https://www.nomadproject.io/guides/operating-a-job/advanced-scheduling/spread.html) of a job by spreading its instances across multiple data centers or physical racks, via the [spread stanza](https://www.nomadproject.io/docs/job-specification/spread.html).
- Target a [specific class](https://www.nomadproject.io/guides/operating-a-job/advanced-scheduling/affinity.html) of nodes for specialized workloads via the new [affinitie stanza](https://www.nomadproject.io/docs/job-specification/affinity.html).

???
Inside the job spec we can set these vaules to help distrubute loads in specific ways

---
name: Job Placement with Constraints, Affinities, and Spread
# Constraints

- The [constraint stanza](https://www.nomadproject.io/docs/job-specification/constraint.html) allows restricting the set of eligible nodes.
- Constraints may filter on [attributes](https://www.nomadproject.io/docs/runtime/interpolation.html) or [client metadata](https://www.nomadproject.io/docs/configuration/client.html#custom-metadata-network-speed-and-node-class).
- Constraints may be specified at the job, group, or task levels for ultimate flexibility.

???
Diving into constraints

---
name: Job Placement with Constraints, Affinities, and Spread
class: col-2, smaller
# Job & Group Level Constraints
- Placing constraints at both the job level and at the group level is redundant since constraints are applied hierarchically.
  - The job constraints will affect all groups (and tasks) in the job.
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

```hcl
job "docs" {
  # All tasks in this job 
  # must run on linux.
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }
  group "example" {
    constraint {
      operator  = "distinct_hosts"
      value     = "true"
      }
```

???
This is a regular slide with content

---
name: Job Placement with Constraints, Affinities, and Spread
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
talk about getting values from metadata
https://www.nomadproject.io/docs/configuration/client.html#custom-metadata-network-speed-and-node-class

---
name: Job Placement with Constraints, Affinities, and Spread
# Affinities

- The [affinity stanza](https://www.nomadproject.io/docs/job-specification/affinity.html) allows operators to express placement preference for a set of nodes. 
- Affinities may be expressed on attributes or client metadata. 
- Additionally affinities may be specified at the job, group, or task levels for ultimate flexibility.

???

---
name: Job Placement with Constraints, Affinities, and Spread
class: col-2, smaller
# Job Affinities
- Affinities apply to task groups but may be specified within job and task stanzas as well.
- Job affinities apply to all groups within the job. 
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
    weight    = 100
  }
    task "server" {
      affinity {
        attribute = "${meta.my_custom_value}"
        operator  = ">"
        value     = "3"
        weight    = 50
      }
```

???
talk about getting values from metadata
https://www.nomadproject.io/docs/configuration/client.html#custom-metadata-network-speed-and-node-class



---
name: Job Placement with Constraints, Affinities, and Spread
class: col-2, smaller
# Group Affinities
- Operators can use weights to express relative preference across multiple affinities.
- If no nodes match a given affinity, placement is still successful.
- This is different from constraints where placement is restricted only to nodes that meet the constraint's criteria.

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
talk about getting values from metadata
https://www.nomadproject.io/docs/configuration/client.html#custom-metadata-network-speed-and-node-class



---
name: Job Placement with Constraints, Affinities, and Spread
# Spread
- The [spread stanza](https://www.nomadproject.io/docs/job-specification/spread.html) allows operators to increase the failure tolerance of their applications by specifying a node attribute that allocations should be spread over.
- This allows operators to spread allocations over attributes such as datacenter, availability zone, or even rack in a physical datacenter.
- By default, when using spread the scheduler will attempt to place allocations equally among the available values of the given target.

???

---
name: Job Placement with Constraints, Affinities, and Spread
# Spread
- Nodes are scored according to how closely they match the desired target percentage defined in the spread stanza.
- A job or task group can have more than one spread criteria, with weights to express relative preference.
- Spread criteria are treated as a soft preference by the Nomad scheduler. If no nodes match a given spread criteria, placement is still successful.


---
name: Job Placement with Constraints, Affinities, and Spread
# Spread Code Example
```hcl
job "docs" {
  # Spread allocations over all datacenter
  spread {
    attribute = "${node.datacenter}"
  }
  group "example" {
    # Spread allocations over each rack based on desired percentage
      spread {
        attribute = "${meta.rack}"
        target "r1" {
          percent = 60
        }
        target "r2" {
          percent = 40
```

???
Let's talk about job placement you see, let's talk about groups and jobs, let's talk about  all the good that comes with spread. -saltNpepa


---
name: Variable Interpolation
# Variable Interpolation
- Nomad supports interpreting two classes of variables: node attributes and runtime environment variables.
- [Node attributes](https://www.nomadproject.io/docs/runtime/interpolation.html#node-variables-) are interpretable in constraints, task environment variables, and certain driver fields.
- Runtime [environment variables](https://www.nomadproject.io/docs/runtime/interpolation.html#environment-variables-) are not interpretable in constraints because they are only defined once the scheduler has placed them on a particular node.

???
variables


---
name: Variable Interpolation
# Variable Interpolation
- The syntax for interpreting variables is ${variable}
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
variables


---
name: Variable Interpolation
class: small
# Variables Interpolation in Constraints
- Constraints only support node attributes as runtime environment variables are only defined after the task is placed on a node.

```hcl
task "docs" {
  driver = "docker"
  config {
    image = "my-app"
  }
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }
}

```

???
variables in constraints


---
name: Variable Interpolation
class: small
# Environment Variable Interpolation
- Environment variables are interpreted and can contain both runtime and node attributes and are passed into the task.

```hcl
task "docs" {
  driver = "docker"
  env {
    "DC"      = "Running on datacenter ${node.datacenter}"
    "VERSION" = "Version ${NOMAD_META_VERSION}"
  }
```

???
variables


---
name: Variable Interpolation
class: small
# Meta Variable Interpolation
- The [meta stanza](https://www.nomadproject.io/docs/job-specification/meta.html) allows for user-defined arbitrary key-value pairs.
- Meta keys are interpretable

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

