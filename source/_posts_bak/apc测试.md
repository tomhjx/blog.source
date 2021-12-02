---
title: apc测试
categories:
  - 编程语言
  - PHP
tags:
  - 原创
  - PHP
  - APC
date: 2016-01-03 16:04:11
---


> thinkphp 3.2.1 demo


```bash

$ ab -n5000 -c100 http://dev.demo.com/iframe.thinkphp/3.2.1/

```

```

This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking dev.demo.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Completed 5000 requests
Finished 5000 requests


Server Software:        Apache/2.2.22
Server Hostname:        dev.demo.com
Server Port:            80

Document Path:          /iframe.thinkphp/3.2.1/
Document Length:        445 bytes

Concurrency Level:      100
Time taken for tests:   102.252 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      4000000 bytes
HTML transferred:       2225000 bytes
Requests per second:    48.90 [#/sec] (mean)
Time per request:       2045.045 [ms] (mean)
Time per request:       20.450 [ms] (mean, across all concurrent requests)
Transfer rate:          38.20 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   2.0      1      20
Processing:   836 2036 477.5   1993    7018
Waiting:      835 1923 474.8   1876    7018
Total:        836 2037 477.4   1994    7019

Percentage of the requests served within a certain time (ms)
  50%   1994
  66%   2114
  75%   2191
  80%   2239
  90%   2401
  95%   2581
  98%   2817
  99%   3206
 100%   7019 (longest request)


```

------

开启apc后


```sh

$ ab -n5000 -c100 http://dev.demo.com/iframe.thinkphp/3.2.1/

```

```

This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking dev.demo.com (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Completed 5000 requests
Finished 5000 requests


Server Software:        Apache/2.2.22
Server Hostname:        dev.demo.com
Server Port:            80

Document Path:          /iframe.thinkphp/3.2.1/
Document Length:        445 bytes

Concurrency Level:      100
Time taken for tests:   34.969 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      4000000 bytes
HTML transferred:       2225000 bytes
Requests per second:    142.98 [#/sec] (mean)
Time per request:       699.382 [ms] (mean)
Time per request:       6.994 [ms] (mean, across all concurrent requests)
Transfer rate:          111.71 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   2.0      1      18
Processing:    61  695 353.2    658    4606
Waiting:       14  658 347.7    615    4606
Total:         61  696 353.0    658    4607

Percentage of the requests served within a certain time (ms)
  50%    658
  66%    743
  75%    800
  80%    836
  90%    946
  95%   1072
  98%   1340
  99%   2618
 100%   4607 (longest request)


```

