name: introduction-to-sentinel
class: title, shelf, no-footer, fullbleed
count: false

# Introduction to Sentinel
## Roger Berlind: Sentinel Technical Specialist, Hashicorp

---
name: agenda
# Agenda

1. What is Sentinel?
2. How is Sentinel used in Terraform Cloud?
3. Writing and Testing Sentinel Policies
4. Managing Policy Sets and Policies

---
name: what-is-sentinel
# What is Sentinel?

* Sentinel implements governance policies as code in the same way that Terraform implements infrastructure as code.
* It uses its own language with sophisticated conditional logic.
* It is embedded in HashiCorp's enterprise products.
* It includes a simulator for testing policies.

---
name: how-is-sentinel-used-in-tfc
# How is Sentinel used in Terraform Cloud

* Sentinel policy checks are run between the plan and apply steps of TFC runs.
* Only authorized users can override policies that have violations.
* Terraform extends Sentinel with several Terraform-specific imports.
* Mocks can be generated for testing with the Sentinel Simulator.

---
name: writing-testing-policies
# Writing and Testing Sentinel Policies

* Here is the 8 step methodology for writing and testing Sentinel policies in Terraform:
  1. Step 1
  2. Step 2
  3. Step 3
  4. Step 4
  5. Step 5
  6. Step 6
  7. Step 7
  8. Step 8
* For more details, see this [guide](https://www.hashicorp.com/resources/writing-and-testing-sentinel-policies-for-terraform).

---
name: managing-policy-sets
# Manging Policy Sets and Policies

* Policy Sets contain policies
* They can be stored in VCS repositories.
* Changes are automatically propagated to Terraform Cloud.
