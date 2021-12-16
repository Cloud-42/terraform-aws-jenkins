#!/bin/bash
# ----------------
# Allow for additional commands
# ----------------
${preliminary_user_data}

# Mounting will be retried for 10 minutes (60 retries x 10 seconds)
efs_mount_max_retry=60
efs_mount_retry_sleep=10
# Recommended mount options are explained here:
# https://docs.aws.amazon.com/efs/latest/ug/mounting-fs-nfs-mount-settings.html
efs_mount_command='mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dnsname}:/ /efsmnt'

awk -F= '/^NAME/{print $2}' /etc/os-release | grep -i ubuntu
RESULTUBUNTU=$?
if [ $RESULTUBUNTU -eq 0 ]; then
  
  # Set hostname, ensure it remains   
  hostnamectl set-hostname ${appliedhostname}.${domain_name}
  #  Create initial hostname entry to remove:
  #  'unable to resolve host ubuntu' error
  echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts
  # Install Java 11
  /usr/bin/apt-get update -y
  /usr/bin/apt install openjdk-11-jdk -y
  # Create EFS mount folder & mount
  /usr/bin/apt-get install nfs-common -y
  mkdir /efsmnt
  echo 'Attempting to mount EFS filesystem ${efs_dnsname}...'
  counter=0
  until $efs_mount_command
  do
    sleep $efs_mount_retry_sleep
    [[ $counter -eq $efs_mount_max_retry ]] && echo 'EFS mount failed! Mounting aborted, local disk will be used instead. Aborting...' && exit 1
    echo "Retrying to mount EFS filesystem ${efs_dnsname}... (retry #$counter)"
    ((counter++))
  done
  echo 'Mounting done.'
  echo '------- Output of `mount | grep /efsmnt`: ------'
  mount | grep /efsmnt
  echo '------- End of output ------'
  echo '${efs_dnsname}:/ /efsmnt nfs defaults,_netdev 0 0' >> /etc/fstab
  # Install Jenkins
  wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
  /usr/bin/apt-get update -y
  /usr/bin/apt-get install jenkins -y
  # Ensure we are running the latest WAR
  service jenkins stop
  chown jenkins:jenkins /efsmnt
  apt-get install --only-upgrade jenkins -y
  # Mount JENKINS_HOME -> EFS
  sed -i '/JENKINS_HOME/c\JENKINS_HOME=/efsmnt' /etc/default/jenkins
  # Lets ensure state:
  #   * EFS mounted
  #   * Mounts are all working
  #   * Jenkins user and group own /efsmnt 
  service jenkins stop
  chown jenkins:jenkins /efsmnt
  mount -a
  service jenkins start
  
fi

awk -F= '/^NAME/{print $2}' /etc/os-release | grep -i amazon
RESULTAMAZON=$?
if [ $RESULTAMAZON -eq 0 ]; then

  # Set hostname, ensure it remains   
  hostnamectl set-hostname ${appliedhostname}.${domain_name}
  echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts
  # Add EPEL - deals with this issue - https://stackoverflow.com/questions/68915374/how-to-solve-error-during-jenkins-installation
  amazon-linux-extras install epel -y 
  # Install Java
  amazon-linux-extras install java-openjdk11 -y
  # Create EFS mount folder & mount
  /bin/yum -y install nfs-utils
  mkdir /efsmnt
  echo 'Attempting to mount EFS filesystem ${efs_dnsname}...'
  counter=0
  until $efs_mount_command
  do
    sleep $efs_mount_retry_sleep
    [[ $counter -eq $efs_mount_max_retry ]] && echo 'EFS mount failed! Mounting aborted, local disk will be used instead. Aborting...' && exit 1
    echo "Retrying to mount EFS filesystem ${efs_dnsname}... (retry #$counter)"
    ((counter++))
  done
  echo 'Mounting done.'
  echo '------- Output of `mount | grep /efsmnt`: ------'
  mount | grep /efsmnt
  echo '------- End of output ------'
  echo '${efs_dnsname}:/ /efsmnt nfs defaults,_netdev 0 0' >> /etc/fstab
  # Install Jenkins
  /bin/curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
  /bin/rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  /bin/yum update -y && /bin/yum install jenkins -y
  /bin/systemctl stop jenkins
  # Mount JENKINS_HOME -> EFS
  /bin/sed -i '/JENKINS_HOME/c\JENKINS_HOME=/efsmnt' /etc/sysconfig/jenkins
  # Lets ensure state:
  #   * EFS mounted
  #   * Mounts are all working
  #   * Jenkins user and group own /efsmnt 
  /bin/chown jenkins:jenkins /efsmnt
  mount -a
  /bin/systemctl start jenkins && /bin/systemctl enable jenkins

fi
# ----------------
# Allow for additional commands
# ----------------
${supplementary_user_data}
