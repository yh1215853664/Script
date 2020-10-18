#!/bin/bash
if [ $USER == "root" -o $UID -eq 0 ];
then	
	sys=$(cat /etc/*release | grep PRETTY_NAME | cut -d "=" -f 2- |  sed 's/"//g' | awk '{print $1}')
	ubuntu_edition=$(lsb_release -sc)
	centos_edition=$(cat /etc/*release | grep PRETTY_NAME | cut -d "=" -f 2- |  sed 's/"//g' | awk '{print $3}')
	if [ "$sys" = "Ubuntu" ];
		then
			mv /etc/apt/sources.list /etc/apt/sources.list.bak
			cat > /etc/apt/sources.list <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-updates main restricted universe multiverse
# http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-backports main restricted universe multiverse
# deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-security main restricted universe multiverse
# http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-security main restricted universe multiverse

# 预发布软件源，不建议启用
# http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-proposed main restricted universe multiverse
# http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $ubuntu_edition-proposed main restricted universe multiverse	
EOF
		apt update >/dev/null 2>&1
	elif [ "$sys" = "Centos" ];
		then
			mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
			cat > /etc/yum.repos.d/CentOS-Base.repo <<EOF
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#


[base]
name=CentOS-$releasever - Base
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/os/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-$centos_edition

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/updates/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-$centos_edition



#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/extras/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-$centos_edition



#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/centosplus/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-$centos_edition
EOF
yum update >/dev/null 2>&1
		else 
			echo "暂不支持Ubuntu及Centos以外的系统，敬请期待"
	fi
else 
			echo "您不是管理员用户，请提升权限"
fi
