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

###### Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_listener\_port | ALB listener port | `string` | `"443"` | no |
| alb\_listener\_protocol | ALB listener protocol | `string` | `"HTTPS"` | no |
| ami | AMI to be used to build the ec2 instance (via launch config) | `string` | n/a | yes |
| asg\_tags | Dynamic tags for ASG | `list` | "tags need setting" | no |
| autoscaling\_schedule\_create | Allows for disabling of scheduled actions on ASG. Enabled by default | `number` | `1` | no |
| availability\_zones | Availability Zones | `any` | n/a | yes |
| certificate\_arn | ARN of the SSL certificate to use | `any` | n/a | yes |
| create\_dns\_record | Create friendly DNS CNAME | `bool` | `true` | no |
| custom\_userdata | Set custom userdata | `string` | `""` | no |
| deletion\_window\_in\_days | Number of days before permanent removal | `string` | `"30"` | no |
| desired\_capacity | AutoScaling Group desired capacity | `string` | `"1"` | no |
| domain\_name | Domain Name | `any` | n/a | yes |
| efs\_encrypted | Encrypt the EFS share | `string` | `"true"` | no |
| enable\_cross\_zone\_load\_balancing | Enable / Disable cross zone load balancing | `string` | `"false"` | no |
| enable\_deletion\_protection | Enable / Disable deletion protection for the ALB. | `string` | `"false"` | no |
| enable\_key\_rotation | KMS key rotation | `bool` | `true` | no |
| enable\_monitoring | AutoScaling - enables/disables detailed monitoring | `string` | `"false"` | no |
| encrypted | Encryption of volumes | `string` | `"true"` | no |
| environment | Environment where resources are being created, for example DEV, UAT or PROD | `any` | n/a | yes |
| health\_check\_grace\_period | AutoScaling health check grace period | `string` | `"180"` | no |
| health\_check\_type | AutoScaling health check type. EC2 or ELB | `string` | `"ELB"` | no |
| healthy\_threshold | ALB healthy count | `string` | `"2"` | no |
| hostname\_prefix | Hostname prefix for the Jenkins server | `string` | `"jenkins"` | no |
| http\_listener\_required | Enables / Disables creating HTTP listener. Listener auto redirects to HTTPS | `string` | `"true"` | no |
| iam\_instance\_profile | IAM instance profile for Jenkins server | `any` | `null` | no |
| instance\_type | ec2 instance type | `string` | `"t3a.medium"` | no |
| internal | Is the ALB internal? | `string` | `"false"` | no |
| interval | ALB health check interval | `string` | `"20"` | no |
| key\_name | ec2 key pair use | `any` | n/a | yes |
| listener1\_alb\_listener\_port | HTTP listener port | `string` | `"80"` | no |
| listener1\_alb\_listener\_protocol | HTTP listener protocol | `string` | `"HTTP"` | no |
| max\_size | AutoScaling Group max size | `string` | `"1"` | no |
| min\_size | AutoScaling Group min size | `string` | `"1"` | no |
| performance\_mode | EFS performance mode.https://docs.aws.amazon.com/efs/latest/ug/performance.html | `string` | `"generalPurpose"` | no |
| private\_subnet\_a | 1st private subnet id | `any` | n/a | yes |
| private\_subnet\_b | 2nd private subnet id | `any` | n/a | yes |
| route53\_endpoint\_record | Route 53 endpoint name. Creates route53\_endpoint\_record | `string` | `"jenkins"` | no |
| scale\_down\_cron | The time when the recurring scale down action start.Cron format | `string` | `"0 0 * * SUN"` | no |
| scale\_up\_cron | The time when the recurring scale up action start.Cron format | `string` | `"30 0 * * SUN"` | no |
| security\_groups | List of security groups to assign to the ec2 instance | `list(string)` | n/a | yes |
| security\_groups\_alb | ALB Security Group. Create outside of module and pass in | `list(string)` | n/a | yes |
| security\_groups\_mount\_target\_a | Security groups to use for mount target subnet a | `list(string)` | n/a | yes |
| security\_groups\_mount\_target\_b | Security groups to use for mount target subnet b | `list(string)` | n/a | yes |
| subnets | Subnets where the ALB will be placed | `list(string)` | n/a | yes |
| success\_codes | Success Codes for the Target Group Health Checks. Default is 200 ( OK ) | `string` | `"200"` | no |
| supplementary\_user\_data | Supplementary shell script commands for adding to user data.Runs at the end of userdata | `string` | `"#supplementary_user_data"` | no |
| svc\_port | Service port: The port on which targets receive traffic. | `string` | `"8080"` | no |
| tags | Tags map | `map(string)` | `{}` | no |
| target\_group\_path | Health check request path | `string` | `"/"` | no |
| target\_group\_port | The port to use to connect with the target | `string` | `"8080"` | no |
| target\_group\_protocol | The protocol to use to connect to the target | `string` | `"HTTP"` | no |
| timeout | ALB timeout value | `string` | `"5"` | no |
| unhealthy\_threshold | ALB unhealthy count | `string` | `"10"` | no |
| volume\_size | ec2 volume size | `string` | `"30"` | no |
| volume\_type | ec2 volume type | `string` | `"gp2"` | no |
| vpc\_id | VPC id | `any` | n/a | yes |
| vpc\_zone\_identifier | A list of subnet IDs to launch AutoScaling resources in. | `any` | n/a | yes |
| zone\_id | Route 53 zone id | `any` | `null` | no |

