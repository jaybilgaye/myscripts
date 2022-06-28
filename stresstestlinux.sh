#!/bin/bash
if [ ! -e /usr/bin/stress ] ; then
  apt-get install stress

yum install -y epel-release
yum install -y stress
echo "Stress Test started with less load "
uptime
stress --cpu  4 --timeout 20

echo "#############################################"
uptime
echo "#############################################"

echo "Stress Test started with more load"
echo "Check load average section in below output"
uptime
echo "#############################################"
stress --cpu  8 --timeout 20
uptime
echo ##############################################
echo "more tests"
#To spwan 4 workers spinning on sqrt(), 2 workers spwaning on sync(), 2 workers on malloc()/free(), with a time out of 20 seconds and allocate a memory of 256MB per vm worker
uptime
echo "stress test 2 started"
stress --cpu 4 --io 3 --vm 2 --vm-bytes 256M --timeout 20s
echo "Machines stressed. Check load avaerage section"

echo "#############################################"
uptime

echo "#############################################"
