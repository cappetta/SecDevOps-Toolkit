#!/bin/bash


_debug () {
 #if [[ ! -z $1 ]]; then   
  echo "=====================================" 
#fi
  echo $1
}

run_largest_first () {
  _debug
    echo "running scripts for services with the largest amount of scripts to test against"
    for service in $(cat /tmp/counts | sort -k2nr | head| awk '{print $1}'| xargs); do
      echo "testing: $service count: " $(grep -i $service /tmp/counts) 
      scripts=`ls /usr/share/nmap/scripts/*$service* | awk -F"/" '{print $6}' | sed 's/.nse//g'| tr "\n" ","| sed 's/,$//g'` 
      ips=`grep -ih $service /tmp/info.csv | awk -F"," '{print $1}' | sed 's/"//g' |  tr "\n" " "`
#      ports=$(grep -ih port_or_service /usr/share/nmap/scripts/*$service*  | sed -r 's/[a-z=({ ._\s]+//p;' | sed 's/[} "|vnc|tcp|open|)]*//g; ' | sed 's/,*$//g' | sort -u | tr "\n" ','| sed 's/,$//g'| tr "," "\n" | sort -u | tr "\n" "," | sed 's/,$//g')
    if [[ $service = "smb" ]]; then 
     ports='139,445'
     _debug $ports
   else
      ports=$(grep -ih port_or_service /usr/share/nmap/scripts/*$service*  | sed -r 's/[a-z=({ ._\s]+//p;' | sed 's/[^0-9,]*//g; ' | sed 's/,*$//g' | sort -u | tr "\n" ','| sed 's/,$//g'| tr "," "\n" | sort -u | tr "\n" "," | sed 's/,$//g; s/^,//g')
    fi
    # echo before we execute...
      outfile=$(echo $scripts"_"$ports"_"$ips | sed 's/,/_/g')
    rm -rf /tmp/nmap_test/$service
    mkdir -p /tmp/nmap_test/$service
    execute_scan "time nmap --script $scripts -p $ports  $ips " /tmp/nmap_test/$service $service
    _debug

  done

}
# todo: this requires a new sorting solution
run_most_targets () {
  _debug
  echo "running scripts for services with the largest amount of targets to test against"
}

execute_scan() {
  script_cmd=$1
  ts=$(date +%s)
  dir=$2
  service=$3
  _debug
  #echo "executing the scan" 
  echo $1 > $dir/$service.sh
  chmod 744 $dir/$service.sh
  ls -alrt $dir/$service.sh
  $dir/$service.sh > $dir/$service.out &  
  _debug
#  echo "time nmap --script $scripts -p $ports  $ips > $outfile"

}



echo "" > /tmp/counts; 

# using the services file exported from msfconsole of the host/services originally scanned when full network scan was performed.
for service in $(cat /tmp/info.csv | awk -F"," '{print $4}'| sed 's/"//g; /name/d' | sort -u | xargs); do  
# how many scripts exist
count=$( ls /usr/share/nmap/scripts/*$service* 2>/dev/null | wc -l);  

if [[ $count > 0 ]]; then 
  echo "$service $count" >> /tmp/counts  
  scripts=`ls /usr/share/nmap/scripts/*$service* | awk -F"/" '{print $6}' | sed 's/.nse//g'| tr "\n" ","| sed 's/,$//g'` 
  ips=`grep -ih $service /tmp/info.csv | awk -F"," '{print $1}' | sed 's/"//g' |  tr "\n" " "`
  ports=$(grep -ih port_or_service /usr/share/nmap/scripts/*$service*  | sed -r 's/[a-z=({ ._\s]+//p;' | sed 's/[} "|vnc|tcp|open|)]*//g; ' | sed 's/,*$//g' | sort -u | tr "\n" ','| sed 's/,$//g'| tr "," "\n" | sort -u | tr "\n" "," | sed 's/,$//g')

# echo before we execute...
  outfile=$(echo $scripts"_"$ports"_"$ips | sed 's/,/_/g')
#  execute_scan "time nmap --script $scripts -p $ports  $ips > $outfile"
#_debug 
fi; 
done
run_largest_first
