<p align="center">
  <a href="https://www.cloud42.io/" target="_blank" rel="Homepage">
  <img width="200" height="200" src="https://www.cloud42.io/wp-content/uploads/2020/01/transparent_small.png">
  </a>
</p>

---
<p align="center">Need help with your Cloud builds <a href="https://www.cloud42.io/contact/" target="_blank" rel="ContactUS">GET IN TOUCH</a>.</p>

---
# Terraform AWS Jenkins Master module

Creates an auto-scaled, self healing, Jenkins Master server for use in AWS.  

##### Prerequisites

 * A VPC is already in place
 * Route 53 zone is already in place ( Optional )
 * Terraform version >= 0.12.28
 * AWS account

##### Summary:

 * Jenkins Master ec2 instance, created via an AutoScaling Group "ASG".
 * Encrypted EFS share to host $JENKINS_HOME.
 * EFS Mount points in 2x AZs.
 * DNS friendly name in Route53 for connections ( Optional ).
 * Application Load balancer "ALB" , forwarding to the Jenkins Master.
 * Jenkins Server rebuilds once a week deploying all the latest security patches and the latest jenkins.war. Default = 00:00 - 00:30 each Sunday morning.
 * Custom KMS encryption keys for EFS.
 * HTTP - auto re-directs to - HTTPS
 * data\_sources.tf can be used to look up the latest AMI to use.
 
##### EFS Backups

 $JENKINS\_HOME is stored on an EFS Share. It is advisable to back this up. AWS provide 2 off-the-shelf solutions that will do this automatically: 
 * https://aws.amazon.com/answers/infrastructure-management/efs-backup/. The solution is deployed via a CloudFormation template.
 * AWS Backup - https://aws.amazon.com/backup/ ( Probably more straight forward to implement )

##### Current supported Operating Systems:

 * Ubuntu Server 18.04 LTS
 * Amazon Linux 2
