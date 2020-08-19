#!/bin/bash
[ $# -ne 1 ] && echo "Usage $0 (FIN_WAIT2|CLOSE_WAIT|TIME_WAIT|ESTABLISHED|LAST_ACK|FIN_WAIT1)" && exit 7
[ $1 != "ALL" -a $1 != "ESTABLISHED" -a $1 != "CLOSE_WAIT" -a $1 != "TIME_WAIT" -a $1 != "FIN_WAIT2" -a $1 != "LAST_ACK" -a $1 != "FIN_WAIT1" ] \
&& echo "Usage $0 (ALL|FIN_WAIT2|CLOSE_WAIT|TIME_WAIT|ESTABLISHED|LAST_ACK|FIN_WAIT1)" && exit 7 


#sudo netstat -n|grep "^tcp\b"|awk 'BEGIN {S["ESTABLISHED"]=0;S["TIME_WAIT"]=0;S["FIN_WAIT1"]=0;S["FIN_WAIT2"]=0;S["CLOSE_WAIT"]=0;S["LAST_ACK"]=0;} {++S[$NF]} END {for(a in S) print a, S[a]}'|awk '{print }'|grep $1|awk '{print $2}'
netstat -n|grep "^tcp\b"| \
awk 'BEGIN {S["ESTABLISHED"]=0;S["TIME_WAIT"]=0;S["FIN_WAIT1"]=0;S["FIN_WAIT2"]=0;S["CLOSE_WAIT"]=0;S["LAST_ACK"]=0;} \
{++S[$NF]} \
END {S["ALL"]=S["ESTABLISHED"]+S["TIME_WAIT"]+S["FIN_WAIT1"]+S["FIN_WAIT2"]+S["CLOSE_WAIT"]+S["LAST_ACK"];for(a in S) print a, S[a]}' \
|awk '{print }' |grep $1|awk '{print $2}'
