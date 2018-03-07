---
title: nignx缓存proxy_cache
categories:
  - web服务器
  - nignx
tags:
  - nignx
date: 2016-07-25 00:01:02
---



```

ssh root@192.168.1.123 -p 32200

vi /usr/local/nginx/conf/nginx.conf


======

user  www www;
worker_processes  1;
pid        logs/nginx.pid;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr\t$msec\t[$time_local]\t$request\t'
                     '"$status"\t$body_bytes_sent\t"$http_referer"\t'
                     '"$http_user_agent"\t"$http_q_ua"\t"$http_x_forwarded_for"\t'
                     '"$upstream_addr"\t$request_time';

    sendfile        on;
    keepalive_timeout  65;

    server {
        listen 80;
        server_name dev123.demo.com dev123.demo.proxy.com;
        access_log  logs/dev123.demo.com-access.log;
        location / {
            root   /var/www/demo;
            index  index.html index.htm;
        }

        location ~ \.php$ {
            root   /var/www/demo;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
            include        fastcgi_params;
        }
    }

}

======

/etc/init.d/nginx reload


ssh root@192.168.1.120 -p 32200

vi /usr/local/nginx/conf/nginx.conf

======

user  www www;
worker_processes  1;
pid        logs/nginx.pid;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr\t$msec\t[$time_local]\t$request\t'
                     '"$status"\t$body_bytes_sent\t"$http_referer"\t'
                     '"$http_user_agent"\t"$http_q_ua"\t"$http_x_forwarded_for"\t'
                     '"$upstream_addr"\t$request_time';

    sendfile        on;
    keepalive_timeout  65;
    proxy_cache_path /usr/local/nginx/proxy_cache levels=1:2 keys_zone=my-cache:8m max_size=1000m inactive=600m;
    proxy_temp_path /usr/local/nginx/proxy_temp;


    upstream dev123 {
        server 192.168.1.123:80;
    }

    server {
        listen 80;
        server_name dev123.demo.proxy.com;
        error_log  logs/dev123.demo.proxy.com-error.log;
        access_log  logs/dev123.demo.proxy.com-access.log;

        location / {
            proxy_pass http://dev123;
            proxy_cache my-cache;
            proxy_cache_valid 200 10m;
            proxy_redirect off;
            proxy_set_header Host $host;
        }
    }

}

======

/etc/init.d/nginx reload

curl 'http://dev123.demo.proxy.com/tmp/get-serv.php'
curl 'http://dev123.demo.proxy.com/tmp/get-serv.php'
curl 'http://dev123.demo.proxy.com/tmp/get-serv.php'
curl 'http://dev123.demo.proxy.com/tmp/get-serv.php'
curl 'http://dev123.demo.proxy.com/tmp/get-serv.php'
curl -d '' http://dev123.demo.proxy.com/tmp/get-serv.php'
curl -d '' http://dev123.demo.proxy.com/tmp/get-serv.php'
curl -d '' http://dev123.demo.proxy.com/tmp/get-serv.php'
curl -d '' http://dev123.demo.proxy.com/tmp/get-serv.php'
curl -d '' http://dev123.demo.proxy.com/tmp/get-serv.php'



ssh root@192.168.1.123 -p 32200

tail -n 10 /usr/local/nginx/logs/dev123.demo.com-access.log

192.168.1.120 - - [24/Jul/2016:12:32:28 -0400] "GET /tmp/get-serv.php HTTP/1.0" 200 988 "-" "curl/7.29.0"
192.168.1.120 - - [24/Jul/2016:12:33:03 -0400] "POST /tmp/get-serv.php HTTP/1.0" 200 1115 "-" "curl/7.29.0"
192.168.1.120 - - [24/Jul/2016:12:33:03 -0400] "POST /tmp/get-serv.php HTTP/1.0" 200 1115 "-" "curl/7.29.0"
192.168.1.120 - - [24/Jul/2016:12:33:04 -0400] "POST /tmp/get-serv.php HTTP/1.0" 200 1114 "-" "curl/7.29.0"
192.168.1.120 - - [24/Jul/2016:12:33:06 -0400] "POST /tmp/get-serv.php HTTP/1.0" 200 1115 "-" "curl/7.29.0"
192.168.1.120 - - [24/Jul/2016:12:33:07 -0400] "POST /tmp/get-serv.php HTTP/1.0" 200 1115 "-" "curl/7.29.0"


```


http://www.ttlsa.com/nginx/nginx-high-performance-caching/