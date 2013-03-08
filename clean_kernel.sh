#!/bin/bash
# run as root!

current_kernel_version=$(uname -r|sed 's/\([0-9]\+\([-.][0-9]\+\)*\).*/\1/')
current_user=$(whoami)

echo 'current-kernel:' 
uname -r

echo 'to be removed:'
kernels=$(dpkg --get-selections 'linux-*' | grep 'linux-\(headers\|image\)-[0-9]' | grep -v "$current_kernel_version" | awk '{print $1}')
echo "$kernels"

[ -z "$kernels" ] && exit

read -p 'are you sure to remove the above kernels?(yes/no)' sure

[ $sure != 'yes' ] && exit

if [ $current_user != "root" ]; then
	echo 'only root allowed'
	exit 1
fi

for kernel in $kernels
do
	apt-get purge -y $kernel
done
