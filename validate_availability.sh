#!/bin/bash
if [ -z $1 ]
then 
  echo -e "\e[1;31m ELB_DNS_NAME not passed as a parameter! \e[0m"
  exit
fi

command=`curl $1`
while [ -z "${command}" ]; do
    clear
    echo -e "\e[1;31m ELB not resolved.. \e[0m"
    command=`curl $1`
    sleep 2

done

echo -e "\e[1;32m ELB finally resolved! \e[0m"

google-chrome $1