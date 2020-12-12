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
 * Terraform version >= 0.13
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

##### Outputs

| Name | Description |
|------|-------------|
| asg\_id | Jenkins ASG id |
| efs\_dns\_name | DNS name of the EFS share |

##### Variables

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| alb\_listener\_port | ALB listener port | 443 | no |
| alb\_listener\_protocol | ALB listener protocol | HTTPS | no |
| ami | AMI to be used to build the ec2 instance (via launch config) | n/a | yes |
| asg\_tags | Dynamic tags for ASG | "tags need setting" | no |
| autoscaling\_schedule\_create | Allows for disabling of scheduled actions on ASG. Enabled by default | 1 | no |
| availability\_zones | Availability Zones | n/a | yes |
| certificate\_arn | ARN of the SSL certificate to use | n/a | yes |
| create\_dns\_record | Create friendly DNS CNAME | true | no |
| custom\_userdata | Set custom userdata | `""` | no |
| deletion\_window\_in\_days | Number of days before permanent removal | 30 | no |
| desired\_capacity | AutoScaling Group desired capacity | 1 | no |
| domain\_name | Domain Name | n/a | yes |
| efs\_encrypted | Encrypt the EFS share | true | no |
| enable\_cross\_zone\_load\_balancing | Enable / Disable cross zone load balancing | false | no |
| enable\_deletion\_protection | Enable / Disable deletion protection for the ALB. | false | no |
| enable\_key\_rotation | KMS key rotation | true | no |
| enable\_monitoring | AutoScaling - enables/disables detailed monitoring | false | no |
| encrypted | Encryption of volumes | true | no |
| environment | Environment where resources are being created, for example DEV, UAT or PROD | n/a | yes |
| health\_check\_grace\_period | AutoScaling health check grace period | 180 | no |
| health\_check\_type | AutoScaling health check type. EC2 or ELB | ELB | no |
| healthy\_threshold | ALB healthy count | 2 | no |
| hostname\_prefix | Hostname prefix for the Jenkins server | jenkins | no |
| http\_listener\_required | Enables / Disables creating HTTP listener. Listener auto redirects to HTTPS | true | no |
| iam\_instance\_profile | IAM instance profile for Jenkins server | null | no |
| instance\_type | ec2 instance type | t3a.medium | no |
| internal | Is the ALB internal? | false | no |
| interval | ALB health check interval | 20 | no |
| key\_name | ec2 key pair use | n/a | yes |
| listener1\_alb\_listener\_port | HTTP listener port | 80 | no |
| listener1\_alb\_listener\_protocol | HTTP listener protocol | HTTP | no |
| max\_size | AutoScaling Group max size | 1 | no |
| min\_size | AutoScaling Group min size | 1 | no |
| performance\_mode | EFS performance mode.https://docs.aws.amazon.com/efs/latest/ug/performance.html | generalPurpose | no |
| private\_subnet\_a | 1st private subnet id | n/a | yes |
| private\_subnet\_b | 2nd private subnet id | n/a | yes |
| route53\_endpoint\_record | Route 53 endpoint name. Creates route53\_endpoint\_record | jenkins | no |
| scale\_down\_cron | The time when the recurring scale down action start.Cron format | `"0 0 * * SUN"` | no |
| scale\_up\_cron | The time when the recurring scale up action start.Cron format | `"30 0 * * SUN"` | no |
| security\_groups | List of security groups to assign to the ec2 instance | n/a | yes |
| security\_groups\_alb | ALB Security Group. Create outside of module and pass in | n/a | yes |
| security\_groups\_mount\_target\_a | Security groups to use for mount target subnet a | n/a | yes |
| security\_groups\_mount\_target\_b | Security groups to use for mount target subnet b | n/a | yes |
| subnets | Subnets where the ALB will be placed | n/a | yes |
| success\_codes | Success Codes for the Target Group Health Checks. Default is 200 ( OK ) | 200 | no |
| supplementary\_user\_data | Supplementary shell script commands for adding to user data.Runs at the end of userdata | `"#supplementary_user_data"` | no |
| svc\_port | Service port: The port on which targets receive traffic. | 8080 | no |
| tags | Tags map | {} | no |
| target\_group\_path | Health check request path | `"/"` | no |
| target\_group\_port | The port to use to connect with the target | 8080 | no |
| target\_group\_protocol | The protocol to use to connect to the target | HTTP | no |
| timeout | ALB timeout value | 5 | no |
| unhealthy\_threshold | ALB unhealthy count | 10 | no |
| volume\_size | ec2 volume size | 30 | no |
| volume\_type | ec2 volume type | gp2 | no |
| vpc\_id | VPC id | n/a | yes |
| vpc\_zone\_identifier | A list of subnet IDs to launch AutoScaling resources in. | n/a | yes |
| zone\_id | Route 53 zone id | null | no |

