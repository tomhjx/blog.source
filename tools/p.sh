#!/bin/bash
#发布到网站
path=$(pwd)/public
cd ${path}
hexo g
#----git
git add -A
git commit -m "Site updated."
git pull git@github.com:tomhjx/tomhjx.github.io.git master
git push git@github.com:tomhjx/tomhjx.github.io.git master
