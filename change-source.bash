#!/bin/bash
##作者:尹航
##该脚本仅为北京林业大学工学院610实验室ubuntu系统及CentOS初始化而写
##初始化内容包括设置ubuntu清华源,安装vim,openssh-server,net-tools
##并可以选择是否设置安装ros，设置catkin_ws空间等
##CentOS暂时只设置源，并未做其他操作
if [ $USER == "root" -o $UID -eq 0 ];
then
	echo -e "请耐心等待配置完成，请勿关闭本窗口"
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
		echo -e "如果你想安装ros,设置catkin_ws空间,请输入y\n";read confirm
		if [ "$confirm" = "y" ];
			then 
				echo -e "请继续耐心等待"
				#echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ $ubuntu_edition main" > /etc/apt/sources.list.d/ros-latest.list
				#apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 >/dev/null 2>&1
				#apt update >/dev/null 2>&1
				if [ "$ubuntu_edition" = "xenial" ];then
					ROS_Edition=kinetic
				elif [ "$ubuntu_edition" = "bionic" ];then
					ROS_Edition=melodic
				elif [ "$ubuntu_edition" = "focal" ];then
					ROS_Edition=noetic
					echo $ROS_Edition
				else
					echo "版本不支持，请手动安装"
					exit
				fi
				apt install -y vim net-tools openssh-server ros-$ROS_Edition-desktop-full >/dev/null 2>&1
				#SHELL_FOLDER=$(dirname $(readlink -f "$0"))
				#user_test=$(sed "s:/: :g" $SHELL_FOLDER | awk '{print $2}')
				user=$(cat /etc/passwd | grep "/bin/bash" | cut -d: -f1 | tail -1)
				#if [$user_test == $user ];then
				mkdir -p /home/$user/catkin_ws/src;cd /home/$user/catkin_ws/src;catkin_init_workspace
				cd /home/$user/catkin_ws;catkin_make >/dev/null 2>&1
				echo "source /opt/ros/$ROS_Edition/setup.bash" >> /home/$user/.bashrc
				echo "source /home/$user/catkin_ws/devel/setup.bash" >> /home/$user/.bashrc
				source /home/$user/.bashrc
				echo "配置完成"
				#else
				#	echo "无法找到家目录,请手动创建catkin_ws空间"
				#	exit
				#fi
			else
				apt update >/dev/null 2>&1
				apt install -y vim net-tools openssh-server >/dev/null 2>&1
				echo “配置完成”
				exit
			fi
	elif [ "$sys" = "Centos" ]
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
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-$centos_edition

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/updates/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-$centos_edition



#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/extras/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-$centos_edition



#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/centosplus/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-$centos_edition
EOF
yum update >/dev/null 2>&1
		else 
			echo "暂不支持Ubuntu及Centos以外的系统，敬请期待"
	fi
else 
			echo "您不是管理员用户，请提升权限"
fi
