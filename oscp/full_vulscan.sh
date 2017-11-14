#!/bin/bash


_debug () {
 #if [[ ! -z $1 ]]; then   
  echo "=====================================" 
#fi
  echo $1
}

execute_scan() {
  ip=$1
  tmp_dir=$2
  threads=8
  processes=$(ps aux | grep -i "nmap -sv --script" | wc -l)
  if [[ $processes -ge $threads ]]; then   
    _debug "sleeping...`date`" 
   sleep 30
   processes=$(ps aux | grep -i "nmap -sv --script" | wc -l) 
   while [[ $processes -ge $threads ]] 
   do 
     sleep 30
    _debug "sleeping...`date`" 
    processes=$(ps aux | grep -i "nmap -sv --script" | wc -l)
   done
  fi
_debug "running test against $ip"
  nmap -sV --script=vulscan/vulscan.nse --script-args vulscanoutput=details --script-args vulscandb=exploitdb.csv $ip > $tmp_dir/$ip.out& 
}

ts=$(date +%s)
tmp_dir=/tmp/vulscan_results_$ts
mkdir -p $tmp_dir
for ip in $(awk -F"," '{print $1}' /tmp/info.csv | sed 's/"//g' | grep -v host); do 
  execute_scan $ip $tmp_dir
done
