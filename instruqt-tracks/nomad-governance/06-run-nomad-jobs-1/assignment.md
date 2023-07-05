---
slug: run-nomad-jobs-1
id: 82ddxkogsjgq
type: challenge
title: Run Nomad Jobs Restricted by ACLs and Sentinel Policies
teaser: |
  Run Nomad jobs and learn how Nomad ACL and Sentinel policies restrict them.
notes:
- type: text
  contents: |-
    In this challenge, you will run Nomad jobs and learn how Nomad ACL and Sentinel policies restrict them.

    You will see that some jobs cannot be run at all because they violate Sentinel policies and that other jobs cannot be run by certain users because their ACL tokens do not allow them to run jobs in the target namespaces.

    In the next challenge, you will see how resource quotas can also prevent certain jobs from running that would not be blocked by Nomad ACL or Sentinel policies.
tabs:
- title: Config Files
  type: code
  hostname: nomad-server-1
  path: /root/nomad/
- title: Server
  type: terminal
  hostname: nomad-server-1
- title: Nomad UI
  type: service
  hostname: nomad-server-1
  port: 4646
difficulty: basic
timelimit: 1800
---
In this challenge, you will run Nomad jobs and learn how Nomad ACL and Sentinel policies restrict them.

Navigate to the /root/nomad/jobs directory by running this command on the "Server" tab:
```
cd /root/nomad/jobs
```

## Run the sleep.nomad Job
Start by inspecting the "sleep.nomad" job in the jobs directory on the "Config Files" tab. This job uses Nomad's [exec](https://nomadproject.io/docs/drivers/exec) driver to run the Linux `sleep` command.

If you run `echo $NOMAD_TOKEN`, you should see the bootstrap token that you added to /root/.bash_profile earlier. This means that any jobs you run while it is set will be run with the bootstrap token.

Try running the sleep.nomad job (with the bootstrap token) with this command on the "Server" tab:
```
nomad job run sleep.nomad
```

Since the exec driver is not allowed by the "allow-docker-and-java-drivers" Sentinel policy, this command should return a red error message including the following text:<br>
`
Error submitting job: Unexpected response code: 500 (1 error occurred:
    * allow-docker-and-java-drivers : Result: false
`<br>

This indicates that running the job was blocked by the hard-mandatory "allow-docker-and-java-drivers" policy.

## Run the catalogue.nomad Job
Next, inspect the "catalogue.nomad" job on the "Configuration Files" tab. This job launches two Docker containers from custom Docker images, one that runs a web service and one that runs a MySQL database. Neither of these images is allowed by the "restrict-docker-images" policy. Additionally, the containers have their `network_mode` set to `host` which is not allowed by the "prevent-docker-host-network" policy.

Try running the "catalogue.nomad" job with this command on the "Server" tab:
```
nomad job run catalogue.nomad
```

This should return a red error message including the following text:<br>
`
Error submitting job: Unexpected response code: 500 (1 error occurred:
    * prevent-docker-host-network : Result: false
`<br>

You might wonder why there is not an error about the Docker images not being allowed. This is because Nomad happened to have evaluated the "prevent-docker-host-network" policy before the "restrict-docker-images" policy and stops evaluating Sentinel policies as soon as one of them fails.

If you edit the "catalogue.nomad" job to change the value of `network_mode` from `host` to `bridge` and re-run the job, you will see an error message complaining about the "restrict-docker-images" policy being violated. You could make that change with the Instruqt text editor on the "Config Files" tab or run this commands:
```
sed -i 's/"host"/"bridge"/g' /root/nomad/jobs/catalogue.nomad
```
and then run the job:
```
nomad job run catalogue.nomad
```

Since the bootstrap ACL token can override soft-mandatory violations, let's try running the "catalogue.nomad" job again with the `-policy-override` argument after changing the job specification to set `network_mode` back to `host`:
```
sed -i 's/"bridge"/"host"/g' /root/nomad/jobs/catalogue.nomad
```
Then run the job:
```
nomad job run -policy-override catalogue.nomad
```
This returns yellow messages complaining about both violated Sentinel policies, but allows the job to be deployed.

You can verify its successful deployment in the Nomad UI, after clicking on the "ACL Tokens" menu in the upper-right corner of the Nomad UI, entering your bootstrap token in the "Secret ID" field, clicking the "Set Token" button, and then clicking on the "Jobs" menu on the left-side menu. Note that you might want to make your browser window wider or click on the rectangular icon above the Nomad UI to hide the Instruqt assignment.

## Run the webserver-test.nomad Job
Next, inspect the "webserver-test.nomad" job on the "Config Files" tab. This job uses the Docker task driver to run the Apache web server from the "httpd" image which is not one of our allowed images. Additionally, the `namespace` attribute is set to `qa`, indicating that this job should be run in the "qa" namespace.

We would like you to run the "webserver-test.nomad" job with Alice's ACL token. Recall that Alice and her token were given the "dev" ACL policy which is allowed to run jobs in the "dev" namespace but not in the "qa" namespace.

Set Alice's ACL token with this command on the "Server" tab:
```
export NOMAD_TOKEN=$(cat /root/nomad/acls/alice-token.txt | grep Secret | cut -d' ' -f7)
```

Now, run the "webserver-test.nomad" job as Alice with this command:
```
nomad job run webserver-test.nomad
```
This should return a red message, "Error submitting job: Unexpected response code: 403 (Permission denied)".

This indicates that Alice's ACL token does not permit her to run the job. Note that Nomad does not complain about the violation of the "restrict-docker-images" Sentinel policy because Nomad only evaluates Sentinel policies if the ACL policies associated with the user running the job allow them to run it. In this case, Alice's ACL token does not have an ACL policy allowing her to run jobs in the "qa" namespace, so no Sentinel policies are evaluated.

Recall that Bob's ACL token was assigned the "qa" ACL policy. So, let's try setting his ACL token and running the job again. Do that with these commands:
```
export NOMAD_TOKEN=$(cat /root/nomad/acls/bob-token.txt | grep Secret | cut -d' ' -f7)
```
and
```
nomad job run webserver-test.nomad
```

This time, you should see a red message complaining about the "restrict-docker-images" Sentinel policy being violated. Since we did not see a 403 error, this means that Bob would be allowed to run the job if it did not violate any Sentinel policies.

Bob might be tempted to run the job with the `-policy-override` argument. Go ahead and have Bob try this by running this command:
```
nomad job run -policy-override webserver-test.nomad
```
You will see the red error message "Error submitting job: Unexpected response code: 403 (Permission denied)" because Bob's ACL policy does not allow him to override violations of soft-mandatory Sentinel policies. Later, you'll see that Charlie can do this.

Having learned that he can't circumvent Nomad's Sentinel policies, Bob decides to run the nginx web server instead of the Apache web server. He can do this by editing the "webserver-test.nomad" job to specify the "nginx" image instead of the "httpd" image. Have him do this either by editing the job with the Instruqt text editor on the "Config Files" tab or by running this command:
```
sed -i "s/httpd/nginx/g" webserver-test.nomad
```

After editing the job, run it again with this command:
```
nomad job run webserver-test.nomad
```
You might or might not be surprised to see a red message complaining about the "restrict-docker-images" Sentinel policy being violated. What's the problem?

Recall that the "restrict-docker-images" Sentinel policy not only resticts the allowed Docker images but requires them to have a tag starting with a number. But Bob set the image to "nginx" without a tag.

You can fix this by adding the tag "1.15.6" with this command:
```
sed -i "s/nginx/nginx:1.15.6/g" webserver-test.nomad
```

Now, Bob can finally run the "webserver-test.nomad" job without errors with this command:
```
nomad job run webserver-test.nomad
```

If you look at the Nomad UI, you will not see the new job at first. This is because you are currently looking at jobs in the "default" namespace while Bob ran the job in the "qa" namespace.

You can fix this by clicking the refresh icon above the Nomad UI and selecting the "qa" namespace in the workload drop-down menu. You should now see the webserver-test job running in the Nomad UI. If you switch back to the "Default Namespace", you will again see the "catalogue" job running.

## Overriding Sentinel Violations
After running his website on nginx for a few days, Bob realizes that some pages are not loading correctly. He plans on making some code changes to fix them, but would like to revert to using the Apache web server (httpd) until then. So, he asks the infrastructure manager, Charlie, for an exemption to the Sentinel policy that requires nginx. Fortunately, Charlie agrees.

Have Charlie revert the "webserver-test.nomad" job specification to use "httpd" with this command:
```
sed -i "s/nginx:1.15.6/httpd:2.4/g" webserver-test.nomad
```

Then set the `NOMAD_TOKEN` environment variable to Charlie's token:
```
export NOMAD_TOKEN=$(cat /root/nomad/acls/charlie-token.txt | grep Secret | cut -d' ' -f7)
```

Finally, have Charlie run the webserver-test job with the `-policy-override` argument:
```
nomad job run -policy-override webserver-test.nomad
```
This should give a yellow warning about the violation of the "restrict-docker-images" Sentinel policy but successfully redeploy the job, switching the web server from nginx to httpd.

Wait until both of the new allocations of the webserver-test job are running before clicking the "Check" button.

In this challenge, you saw how Nomad ACL and Sentinel policies restricted which jobs could be run and who could run them.

In the next challenge, you will run some more jobs and see how they are affected by resource quotas.