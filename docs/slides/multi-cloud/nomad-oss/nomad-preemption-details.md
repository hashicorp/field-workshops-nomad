name: nomad-Preemption
class: title, shelf, no-footer, fullbleed
background-image: url(https://hashicorp.github.io/field-workshops-assets/assets/bkgs/HashiCorp-Title-bkg.jpeg)
count: false

# HashiCorp Nomad
## Preemption Details

![:scale 15%](https://hashicorp.github.io/field-workshops-assets/assets/logos/logo_nomad.png)

???
The following slides go into the Preemption operation in more detail.

---
class: col-2

Name:  How Preemption Works
# Preemption Details


![systemalert](images/SystemAlerting.png)
Need to add the System Alerting allocation, but there's no room!

![fullcluster](images/FullCluster.png)



???
Let's run through a quick example of how preemption works.  Here we have a Nomad cluster with a few allocations in an analytics solution.  Allocations are all happy, and now we have a new job added to the system for System Alerting.  We have enough CPU, and plenty of Hard Drive, but we are at the memory limit.  No room at the inn for our System Alerting process.  Without Preemption, that's where we would stop. But we have preemption, so we'll continue

---
class: col-2

Name:  How Preemption Works 2
# Preemption Details 2

![EvictBusinessAlert](images/EvictBusinessAlert1.png)
One of the Business Reporting allocations needs to go!

![AddSystemAlert](images/AddSystemAlert1.png)


???
With Preemption, Nomad realizes that there are lower priority allocations that can be evicted.  So if we are adding one System Alerting job, we evict one Business Reporting Job.  The Business Reporting job has the lowest priority, so it gets evicted first.  But what happens if we have to add two more System Alerting allocations?

---
class: col-2

Name:  How Preemption Works 3
# Preemption Details 3


![EvictBusinessAlert](images/EvictBusinessAlert2.png)
More System Alerting means more eviction.
![AddSystemAlert](images/AddSystemAlert2.png)


 Log Collection isn't a candidate - priority delta < 10

???
If we add two more Sytem Alerting allocations, we need to bump a Batch Analytics Allocation as well. Evicting the Log Collection allocation would be sufficient, however, the Batch Analytics Allocation has a lower priority.  Additionally, as the priority difference between System Alerting and Log Collection is less than 10, the Log Collection allocation isn't a candidate for preemption with respect to System Alerting.
