#!/bin/bash

awk -F= '/^NAME/{print $2}' /etc/os-release | grep -i ubuntu
RESULTUBUNTU=$?
if [ $RESULTUBUNTU -eq 0 ]; then
  
  # Set hostname, ensure it remains   
  hostnamectl set-hostname ${appliedhostname}.${domain_name}
  #  Create initial hostname entry to remove:
  #  'unable to resolve host ubuntu' error
  echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts
  # Install Java 1.8.0_181
  /usr/bin/apt-get update -y
  /usr/bin/apt install openjdk-8-jre-headless -y
  # Create EFS mount folder & mount
  /usr/bin/apt-get install nfs-common -y
  mkdir /efsmnt
  mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dnsname}:/ /efsmnt
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
  # Install Java
  /bin/yum install -y java-1.8.0-openjdk.x86_64
  # Create EFS mount folder & mount
  /bin/yum -y install nfs-utils
  mkdir /efsmnt
  mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dnsname}:/ /efsmnt
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
