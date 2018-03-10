#!/bin/bash
#发布到网站
path=$(pwd)/public
mkdir -p ${path}
cd ${path}
hexo g -d

