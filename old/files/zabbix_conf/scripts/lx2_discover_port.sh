#!/bin/bash
all=(`sudo netstat -tnlp|grep -v tcp6|grep tcp |awk '{print $4"/"$7}'|awk -F":" '{print $2}'|awk '/\/[a-zA-Z]/{print}'`)
#awk '/\/[a-zA-Z]/{print},排除无PID和进程名的监听端口。例如：tcp  0  0 0.0.0.0:43874    0.0.0.0:*     LISTEN      - 
#$4=IP:prot，$7=pid/name。$4,$7之间使用/分割,awk '{print $4"/"$7}';awk -F":" '{print $2}',将$4中冒号前面的排除;all数组中每一项内容是port/pid/name
port=(`echo ${all[*]}|sed 's/ /\n/g'|awk -F"/" '{print $1}'`)  #all数组拆分成三个数组,也可使用二维数组，这里未使用
pid=(`echo ${all[*]}|sed 's/ /\n/g'|awk -F"/" '{print $2}'`)
name=(`echo ${all[*]}|sed 's/ /\n/g'|awk -F"/" '{print $3}'`)


length=${#port[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
  do
     [ ${port[$i]} -eq 32000 ] && name[$i]="Aliyun-cloudmonitor" #阿里云监控进程,监听32000端口，特殊处理
     if [ ${name[$i]} = java ] ;then #如果是java项目,netstat只能查出是java，若要具体区分进程名，需要做进一步处理
         name1=`sudo ps aux|grep jar|grep "\b${pid[$i]}\b"|egrep -o  "\:[a-z/.]+?zookeeper-[0-9.]+?\.jar"|awk -F\: '{print $2}'`
         #zookeeper启动的jar识别,+? 重复1次或更多次，但尽可能少重复 ,简单理解就是最短匹配,下同
         name2=`sudo ps aux|grep "\b${pid[$i]}\b"|grep jar|egrep -o  "\:/[a-zA-Z0-9/-]+?\.jar"|awk -F\: '{print $2}'`
         #tomcat启动的项目
         name3=`sudo ps aux|grep "\b${pid[$i]}\b"|grep jar|egrep -o  "[[:space:]][/.0-9A-Za-z-]+\.jar"|awk '{print $1}'`
         #jar包单独启动的项目，包括activemq
        if [ ! -z $name1 ];then 
           name[$i]=$name1 
        elif [ ! -z $name2 ];then 
            name[$i]=$name2
        elif [ ! -z $name3 ];then 
            name[$i]=$name3
        else
           name[$i]=lx2-vms-wss
           #一个特殊的项目，webrtc2使用
        fi
     fi
     printf '\n\t\t{'
     printf "\n\t\t\t\"{#TCP_PORT}\":\"${port[$i]}\",\n\t\t"
     printf "\t\"{#NAME}\":\"${name[$i]}\",\n\t\t"
     printf "\t\"{#PID}\":\"${pid[$i]}\"\n\t\t}"
     if [ $i -lt $[$length-1] ];then
                printf ','
     fi
  done
printf  "\n\t]\n"
printf "}\n"
