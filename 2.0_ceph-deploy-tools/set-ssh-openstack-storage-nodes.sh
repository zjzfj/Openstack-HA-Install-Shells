#!/bin/sh
nodes_name=(${!nodes_map[@]});
controllers_name=(${!controller_map[@]})
echo ${controllers_name[@]}
ssh-keygen

### 重新设置/etc/hosts，切换主机名至ceph的存储网段
cp /etc/hosts /etc/hosts.bak2
sed -i -e 's#'"$(echo $local_network|cut -d "." -f1-3)"'#'"$(echo $store_network|cut -d "." -f1-3)"'#g' /etc/hosts

for ((i=0; i<${#nodes_map[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_map[$name]};
      echo "-------------$name------------"
      scp /etc/hosts root@$ip:/etc/hosts
  done;

for ((i=0; i<${#nodes_map[@]}; i+=1));
  do
      name=${nodes_name[$i]};
      ip=${nodes_map[$name]};
      echo "-------------$name------------"
      ssh-copy-id root@$ip
      ssh-copy-id root@$name
      ssh-copy-id root@$(echo $store_network|cut -d "." -f1-3).$(echo $ip|awk -F "." '{print $4}')
  done;
