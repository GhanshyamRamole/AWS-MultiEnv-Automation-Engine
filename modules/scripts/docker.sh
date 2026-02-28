#!/bin/bash
hostnamectl set-hostname "${admin_pw}"-docker.devops.com
timedatectl set-timezone Asia/Kolkata
useradd itadmin
echo "${admin_pw}" | passwd --stdin itadmin
echo "${admin_pw}" | passwd --stdin root
echo "itadmin  ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
echo PermitRootLogin yes >> /etc/ssh/sshd_config
systemctl restart sshd
