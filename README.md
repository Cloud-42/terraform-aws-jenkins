# Terraform AWS Jenkins Master module

Creates an auto-scaled, self healing, Jenkins Master server for use in AWS. 

##### Standard items created:

 * Jenkins Master ec2 instance, created via an AutoScaling Group "ASG".
 * Encrypted EFS share to host $JENKINS_HOME.
 * EFS Mount points in 2x AZs.
 * Route 53 DNS "friendly" name.
 * Application Load balancer "ALB" , forwarding to the Jenkins Master.
 * Encrypted s3 bucket to which the Jenkins Master has access.
 * Security groups "SG" for: ec2, ALB & EFS.
 * ASG scheduled action to automatically deploy the latest WAR file.
 * Custom KMS encryption keys for EFS & s3.
 
##### Optional items:

 * ASG action notifications.

##### Current supported Operating Systems:

 * Ubuntu 16

