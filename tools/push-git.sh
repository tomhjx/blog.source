#!/bin/bash
commit_msg=$1
if [ -z $commit_msg ]
then
  echo '请输入提交备注'
  exit
fi
git add -A && git commit -m $commit_msg && git push
