<p align="center">
  <a href="https://www.cloud42.io/" target="_blank" rel="Homepage">
  <img width="200" height="200" src="https://www.cloud42.io/wp-content/uploads/2020/01/transparent_small.png">
  </a>
</p>

---
<p align="center">Need help with your Cloud builds <a href = "mailto: hello@cloud42.io">GET IN TOUCH</a>

---
# Terraform AWS Jenkins Master module

Auto-scaled, self healing, Jenkins Master server for use in AWS.  

##### Prerequisites

 * A VPC is already in place
 * DHCP options set to AmazonProvidedDNS
 * Route 53 zone is already in place ( Optional )
 * Terraform version >= 0.13.2
 * AWS account

##### Summary:

 * Jenkins Master ec2 instance, created via an AutoScaling Group "ASG".
 * Encrypted EFS share to host $JENKINS_HOME.
 * EFS Mount points in 2x AZs.
 * DNS friendly name in Route53 for connections ( Optional ).
 * Application Load balancer "ALB" , forwarding to the Jenkins Master.
 * Jenkins Server rebuilds once a week deploying all the latest security patches and the latest jenkins.war. Default = 00:00 - 00:30 each Sunday morning.
 * Custom KMS encryption key for EFS.
 * HTTP - auto re-directs to - HTTPS
 * data\_sources.tf can be used to look up the latest AMI to use.
 
##### EFS Backups

 $JENKINS\_HOME is stored on an EFS Share. It is advisable to back this up. AWS provide 2 off-the-shelf solutions that will do this automatically: 
 * https://aws.amazon.com/answers/infrastructure-management/efs-backup/. This solution is deployed via a CloudFormation template.
 * AWS Backup - https://aws.amazon.com/backup/ ( Probably more straight forward to implement )

##### Current supported Operating Systems:

 * Ubuntu Server 20.04 LTS
 * Amazon Linux 2

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_listener_port"></a> [alb\_listener\_port](#input\_alb\_listener\_port) | ALB listener port | `number` | `"443"` | no |
| <a name="input_alb_listener_protocol"></a> [alb\_listener\_protocol](#input\_alb\_listener\_protocol) | ALB listener protocol | `string` | `"HTTPS"` | no |
| <a name="input_ami"></a> [ami](#input\_ami) | AMI to be used to build the ec2 instance (via launch config) | `string` | n/a | yes |
| <a name="input_asg_tags"></a> [asg\_tags](#input\_asg\_tags) | Dynamic tags for ASG | `any` | <pre>[<br>  {<br>    "key": "Name",<br>    "propagate_at_launch": true,<br>    "value": "tags need setting"<br>  }<br>]</pre> | no |
| <a name="input_autoscaling_schedule_create"></a> [autoscaling\_schedule\_create](#input\_autoscaling\_schedule\_create) | Allows for disabling of scheduled actions on ASG. Enabled by default | `number` | `1` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the SSL certificate to use | `string` | n/a | yes |
| <a name="input_create_dns_record"></a> [create\_dns\_record](#input\_create\_dns\_record) | Create friendly DNS CNAME | `bool` | `true` | no |
| <a name="input_custom_userdata"></a> [custom\_userdata](#input\_custom\_userdata) | Set custom userdata | `string` | `""` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Number of days before permanent removal | `number` | `"30"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | AutoScaling Group desired capacity | `number` | `1` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name | `string` | n/a | yes |
| <a name="input_efs_encrypted"></a> [efs\_encrypted](#input\_efs\_encrypted) | Encrypt the EFS share | `bool` | `true` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Enable / Disable cross zone load balancing | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Enable / Disable deletion protection for the ALB. | `bool` | `false` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | KMS key rotation | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | AutoScaling - enables/disables detailed monitoring | `bool` | `"false"` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Encryption of volumes | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment where resources are being created, for example DEV, UAT or PROD | `string` | n/a | yes |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | AutoScaling health check grace period | `number` | `180` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | AutoScaling health check type. EC2 or ELB | `string` | `"ELB"` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | ALB healthy count | `number` | `2` | no |
| <a name="input_hostname_prefix"></a> [hostname\_prefix](#input\_hostname\_prefix) | Hostname prefix for the Jenkins server | `string` | `"jenkins"` | no |
| <a name="input_http_listener_required"></a> [http\_listener\_required](#input\_http\_listener\_required) | Enables / Disables creating HTTP listener. Listener auto redirects to HTTPS | `bool` | `true` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM instance profile for Jenkins server | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | ec2 instance type | `string` | `"t3a.medium"` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Is the ALB internal? | `bool` | `false` | no |
| <a name="input_interval"></a> [interval](#input\_interval) | ALB health check interval | `number` | `20` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | ec2 key pair use | `string` | n/a | yes |
| <a name="input_listener1_alb_listener_port"></a> [listener1\_alb\_listener\_port](#input\_listener1\_alb\_listener\_port) | HTTP listener port | `number` | `80` | no |
| <a name="input_listener1_alb_listener_protocol"></a> [listener1\_alb\_listener\_protocol](#input\_listener1\_alb\_listener\_protocol) | HTTP listener protocol | `string` | `"HTTP"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | AutoScaling Group max size | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | AutoScaling Group min size | `number` | `1` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | EFS performance mode.https://docs.aws.amazon.com/efs/latest/ug/performance.html | `string` | `"generalPurpose"` | no |
| <a name="input_preliminary_user_data"></a> [preliminary\_user\_data](#input\_preliminary\_user\_data) | Preliminary shell script commands for adding to user data.Runs at the beginning of userdata | `string` | `"#preliminary_user_data"` | no |
| <a name="input_private_subnet_a"></a> [private\_subnet\_a](#input\_private\_subnet\_a) | 1st private subnet id | `string` | n/a | yes |
| <a name="input_private_subnet_b"></a> [private\_subnet\_b](#input\_private\_subnet\_b) | 2nd private subnet id | `string` | n/a | yes |
| <a name="input_route53_endpoint_record"></a> [route53\_endpoint\_record](#input\_route53\_endpoint\_record) | Route 53 endpoint name. Creates route53\_endpoint\_record | `string` | `"jenkins"` | no |
| <a name="input_scale_down_cron"></a> [scale\_down\_cron](#input\_scale\_down\_cron) | The time when the recurring scale down action start.Cron format | `string` | `"0 0 * * SUN"` | no |
| <a name="input_scale_up_cron"></a> [scale\_up\_cron](#input\_scale\_up\_cron) | The time when the recurring scale up action start.Cron format | `string` | `"30 0 * * SUN"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups to assign to the ec2 instance. Create outside of module and pass in | `list(string)` | n/a | yes |
| <a name="input_security_groups_alb"></a> [security\_groups\_alb](#input\_security\_groups\_alb) | ALB Security Group. Create outside of module and pass in | `list(string)` | n/a | yes |
| <a name="input_security_groups_mount_target_a"></a> [security\_groups\_mount\_target\_a](#input\_security\_groups\_mount\_target\_a) | Security groups to use for mount target subnet a. Create outside of module and pass in | `list(string)` | n/a | yes |
| <a name="input_security_groups_mount_target_b"></a> [security\_groups\_mount\_target\_b](#input\_security\_groups\_mount\_target\_b) | Security groups to use for mount target subnet b. Create outside of module and pass in | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets where the ALB will be placed | `list(string)` | n/a | yes |
| <a name="input_success_codes"></a> [success\_codes](#input\_success\_codes) | Success Codes for the Target Group Health Checks. Default is 200 ( OK ) | `string` | `"200"` | no |
| <a name="input_supplementary_user_data"></a> [supplementary\_user\_data](#input\_supplementary\_user\_data) | Supplementary shell script commands for adding to user data.Runs at the end of userdata | `string` | `"#supplementary_user_data"` | no |
| <a name="input_svc_port"></a> [svc\_port](#input\_svc\_port) | Service port: The port on which targets receive traffic. | `number` | `8080` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags map | `map(string)` | `{}` | no |
| <a name="input_target_group_path"></a> [target\_group\_path](#input\_target\_group\_path) | Health check request path | `string` | `"/"` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | The port to use to connect with the target | `number` | `"8080"` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | The protocol to use to connect to the target | `string` | `"HTTP"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | ALB timeout value | `number` | `5` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | ALB unhealthy count | `number` | `10` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | ec2 volume size | `number` | `30` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | ec2 volume type | `string` | `"gp2"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |
| <a name="input_vpc_zone_identifier"></a> [vpc\_zone\_identifier](#input\_vpc\_zone\_identifier) | A list of subnet IDs to launch AutoScaling resources in. | `list(string)` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route 53 zone id | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | Jenkins ASG id |
| <a name="output_efs_dns_name"></a> [efs\_dns\_name](#output\_efs\_dns\_name) | DNS name of the EFS share |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | ID of the EFS share |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | Load balancer ARN |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | Load balancer DNS Name |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | Load balancer zone id |

[![CI](https://github.com/Cloud-42/terraform-aws-jenkins/actions/workflows/actions.yml/badge.svg)](https://github.com/Cloud-42/terraform-aws-jenkins/actions/workflows/actions.yml)
