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
    # get the services with the largest number of scripts
    for service in $(cat /tmp/counts | sort -k2nr | head| awk '{print $1}'| xargs); do
      echo "testing: $service count: " $(grep -i $service /tmp/counts) 
      scripts=`ls /usr/share/nmap/scripts/*$service* | awk -F"/" '{print $6}' | sed 's/.nse//g'| tr "\n" ","| sed 's/,$//g'` 
      ips=`grep -ih $service /tmp/info.csv | awk -F"," '{print $1}' | sed 's/"//g' |  tr "\n" " "`
      if [[ $service = "smb" ]]; then 
        ports='139,445'
        _debug $ports
      else
        ports=$(grep -ih port_or_service /usr/share/nmap/scripts/*$service*  | sed -r 's/[a-z=({ ._\s]+//p;' | sed 's/[^0-9,]*//g; ' | sed 's/,*$//g' | sort -u | tr "\n" ','| sed 's/,$//g'| tr "," "\n" | sort -u | tr "\n" "," | sed 's/,$//g; s/^,//g')
      fi
      rm -rf /tmp/nmap_test/$service
      mkdir -p /tmp/nmap_test/$service
      for test in $(ls /usr/share/nmap/scripts/*$service* | awk -F"/" '{print $6}' | sed 's/.nse//g'| tr "\n" " "); do
        outfile=$(echo $test"_"$ips | sed 's/,/_/g')
        execute_scan "time nmap --script $test -p $ports  $ips " /tmp/nmap_test/$service $test
      done
      
#      ports=$(grep -ih port_or_service /usr/share/nmap/scripts/*$service*  | sed -r 's/[a-z=({ ._\s]+//p;' | sed 's/[} "|vnc|tcp|open|)]*//g; ' | sed 's/,*$//g' | sort -u | tr "\n" ','| sed 's/,$//g'| tr "," "\n" | sort -u | tr "\n" "," | sed 's/,$//g')
    
    # echo before we execute...
    
    _debug

  done

}
# todo: this requires a new sorting solution
run_most_targets () {
  _debug
  echo "running scripts for services with the largest amount of targets to test against"
}

# todo: this requires a new sorting solution
run_script () {
  _debug
  echo "running script $1 against all targets..."
}



execute_scan() {
  script_cmd=$1
  ts=$(date +%s)
  dir=$2
  nmap_test=$3
# _debug
  threads=8
  #echo "executing the scan" 
  echo $1 > $dir/$nmap_test.sh
  chmod 744 $dir/$nmap_test.sh
#  ls -alrt $dir/$nmap_test.sh
  processes=$(ps aux | grep -i "nmap --script" | wc -l)
  if [[ $processes -ge $threads ]]; then   
    _debug "sleeping...`date`" 
   sleep 30
   processes=$(ps aux | grep -i "nmap --script" | wc -l) 
   while [[ $processes -ge $threads ]] 
   do 
     sleep 30
    _debug "sleeping...`date`" 
    processes=$(ps aux | grep -i "nmap --script" | wc -l)
   done
  fi
_debug "running: $dir/$nmap_test.sh"
$dir/$nmap_test.sh &> $dir/$nmap_test.out &
#  _debug
#  echo "time nmap --script $scripts -p $ports  $ips > $outfile"

}



echo "" > /tmp/counts; 

# using the services file exported from msfconsole of the host/services originally scanned when full network scan was performed.
for service in $(cat /tmp/info.csv | awk -F"," '{print $4}'| sed 's/"//g; /name/d' | sort -u | xargs); do  
# how many scripts exist
count=$( ls /usr/share/nmap/scripts/*$service* 2>/dev/null | wc -l);  

if [[ $count > 0 ]]; then 
  echo "$service $count" >> /tmp/counts  
  #scripts=`ls /usr/share/nmap/scripts/*$service* | awk -F"/" '{print $6}' | sed 's/.nse//g'| tr "\n" ","| sed 's/,$//g'` 
  #ips=`grep -ih $service /tmp/info.csv | awk -F"," '{print $1}' | sed 's/"//g' |  tr "\n" " "`
  #ports=$(grep -ih port_or_service /usr/share/nmap/scripts/*$service*  | sed -r 's/[a-z=({ ._\s]+//p;' | sed 's/[} "|vnc|tcp|open|)]*//g; ' | sed 's/,*$//g' | sort -u | tr "\n" ','| sed 's/,$//g'| tr "," "\n" | sort -u | tr "\n" "," | sed 's/,$//g')

# echo before we execute...
  #outfile=$(echo $scripts"_"$ports"_"$ips | sed 's/,/_/g')
#  execute_scan "time nmap --script $scripts -p $ports  $ips > $outfile"
#_debug 
fi; 
done
run_largest_first
