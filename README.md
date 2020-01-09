<p align="center">
  <a href="https://www.cloud42.io/" target="_blank" rel="Homepage">
  <img width="200" height="200" src="https://www.cloud42.io/wp-content/uploads/2020/01/transparent_small.png">
  </a>
</p>

---
<p align="center">Need help with your Cloud builds <a href="https://www.cloud42.io/contact/" target="_blank" rel="ContactUS"> DROP US A LINE</a>.</p>

---
# Terraform AWS Jenkins Master module

Creates an auto-scaled, self healing, Jenkins Master server for use in AWS. The Jenkins Master is created via an AutoScaling Group"ASG" and $JENKINS\_HOME is stored on an EFS share. When the ASG creates an ec2 host, the latest version of Jenkins is installed, the data directory $JENKINS\_HOME is then mounted. Once a week the ec2 host is recreated via an ASG scheduled action to ensure the latest version of the Jenkins WAR is being used. 

##### Standard items created:

 * Jenkins Master ec2 instance, created via an AutoScaling Group "ASG".
 * Encrypted EFS share to host $JENKINS_HOME.
 * EFS Mount points in 2x AZs.
 * DNS friendly name in Route53 for connections.
 * Application Load balancer "ALB" , forwarding to the Jenkins Master.
 * s3 bucket to which the Jenkins Master has access.
 * Security groups "SG" for: ec2, ALB & EFS.
 * ASG scheduled action to automatically deploy the latest WAR file, default = 00:00 - 00:30 each Sunday morning.
 * Custom KMS encryption keys for EFS.
 
##### Key points regarding usage:

 * Jenkins Server is created automatically via the ASG.
 * Jenkins Server rebuilds once a week deploying all the latest security patches and the latest jenkins.war.
 * $JENKINS\_HOME is stored on the EFS share and mounts automatically.
 * Endpoint is only available via HTTPS.
 * data\_sources.tf can be used to look up the latest Ubuntu AMI to use.
 * The EFS share is encrytped using a custom KMS key.

##### Dependencies and Prerequisites

 * A VPC is already in place
 * Route 53 zone is already in place
 * Terraform version >= 0.11.10
 * AWS account

##### EFS Backups

 $JENKINS\_HOME is stored on an EFS Share. It is advisable to back this up. AWS provide an off-the-shelf solution that will do this automatically: https://aws.amazon.com/answers/infrastructure-management/efs-backup/. The solution is deployed via a CloudFormation template.

##### Current supported Operating Systems:

 * Ubuntu 16



