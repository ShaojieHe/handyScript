#!/bin/bash
applygrub(){
grub_count=$(grep -E ^menuentry /etc/grub2.cfg | cut -f 2 -d \' | nl | grep ${kernel_version} | awk '{print $1}')
grub_count=$[grub_count-1]
grub2-set-default ${grub_count}
}
readgrub(){
sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
menu
}

applykernel(){
read -p "desired kernel?   " kernel_version
kernel=$(grep -E ^menuentry /etc/grub2.cfg | cut -f 2 -d \' | nl | grep ${kernel_version})
echo -e $kernel
read -p  "this is your chosed kernel version, go?[y/N]   " choice
[[ -z "${choice}" ]] && choice="n"
if [[ $choice = "n" ]]; then
menu
elif [[ $choice == "y" || $choice == "Y" ]]; then
applygrub
exit
fi
}

menu(){
echo "1 show grub (start from 0)"
echo "2 to change boot order"
read -p "your choice?" menuchoice
case $menuchoice in
1)
readgrub
;;
2)
applykernel
;;
*)
exit
;;
esac
}
menu
