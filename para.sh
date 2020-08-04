#!/bin/bash
beginTime=`date +%s`

for (( month=2; month<=12; month++))
do
 {
  matlab -nodesktop -nosplash -r "FY4(2019,$month);exit"
  } &
  done
  wait
  endTime=`date +%s`
  echo "总共耗时:" $(($endTime-$beginTime)) "秒"
