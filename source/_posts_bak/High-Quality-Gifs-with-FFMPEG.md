---
title: High Quality Gifs with FFMPEG
categories:
  - 多媒体
  - ffmpeg
tags:
  - ffmpeg
date: 2020-03-01 18:34:19
---
After getting FFMPEG installed, let’s try it out on a MOV downloaded from my google photos account:

ffmpeg \-i MVI\_6654.MOV firsttry.gif

We’re calling the ffmpeg program and telling it that MVI\_6654.MOV is our input file with the \-i flag. the filename at the end defines the conversion and creates the new file, resulting in:

![](https://miro.medium.com/freeze/max/60/1*VDw1ZRa5oeGyp8FgJcBPDQ.gif?q=20)

![](https://miro.medium.com/max/640/1*VDw1ZRa5oeGyp8FgJcBPDQ.gif)

![](https://miro.medium.com/max/1280/1*VDw1ZRa5oeGyp8FgJcBPDQ.gif)

Pretty cool. But I bet I can make it loop nicely by just using the first few seconds, so we use the duration flag, \-t and specify the duration in seconds.

ffmpeg \-t 2 \-i MVI\_6654.MOV secondtry.gif

![](https://miro.medium.com/freeze/max/60/1*RTZ2pIIqherofg_LG5vwEw.gif?q=20)

![](https://miro.medium.com/max/640/1*RTZ2pIIqherofg_LG5vwEw.gif)

![](https://miro.medium.com/max/1280/1*RTZ2pIIqherofg_LG5vwEw.gif)

So it loops! kinda slow tho, maybe we can drop every other frame? A\-ha. Thanks to the \-r flag, we can choose a frame rate for the output (note that these options do different things based on their order. \-t is used before the \-i input, \-r is used after the input, so it affects the output.)

ffmpeg \-t 2 \-i MVI\_6654.MOV \-r “15” thirdtry.gif

![](https://miro.medium.com/freeze/max/60/1*FsdQXYxpB-EI2ZhHSCLZkw.gif?q=20)

![](https://miro.medium.com/max/640/1*FsdQXYxpB-EI2ZhHSCLZkw.gif)

![](https://miro.medium.com/max/1280/1*FsdQXYxpB-EI2ZhHSCLZkw.gif)

That’s more like it. As an added benefit, the file is now 2 megabytes instead of 8 megabytes. I’ve got another one to convert that has kind of a long input video, so I’m going to specify a time to start the gif as well as the duration. The \-ss flag defines the starting point. Oh yeah, and your seconds can be decimals. If you have a longer video and want to define the starting position in hours, minutes, seconds, you can use “hh:mm:ss” format, like “00:00:03” instead of “3”

ffmpeg \-t 3 \-ss 0.5 \-i MVI\_6663.MOV \-r “15” fourthtry.gif

![](https://miro.medium.com/freeze/max/60/1*Oh2K7GYaKkGvPWbHFRIX1g.gif?q=20)

![](https://miro.medium.com/max/640/1*Oh2K7GYaKkGvPWbHFRIX1g.gif)

![](https://miro.medium.com/max/1280/1*Oh2K7GYaKkGvPWbHFRIX1g.gif)

This has been pretty simple, but I know I’ve seen better looking gifs. Let’s find out how to make it look more like a video…

Learned a lot from [this blog](http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html) about the color palette algorithms.

Found a relatively simple example on [stackoverflow](http://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality).

We have to generate a custom color palette so we don’t waste space storing colors we don’t use (the gif file format is limited to 256 colors):

ffmpeg \-ss 2.6 \-t 1.3 \-i MVI\_7035.MOV \-vf \\ fps=15,scale=320:\-1:flags=lanczos,palettegen palette.png

You should recognize what \-ss, \-t, and \-i do here, \-vf is a way to invoke filters on our video. so we can describe fps and scale here. Hm. I’ll admit I don’t know what \-1 does. But the flags describe what algorithm to use, more info in [that blog.](http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html) So that generates palette.png which we can use in our 2nd line in terminal (by the way, the backslash at the end of the line is if you run out of space and need to keep typing, hit backslash and return and you can keep going on a new line before hitting return to complete the command.)

ffmpeg \-ss 2.6 \-t 1.3 \-i MVI\_7035.MOV \-i palette.png \\
\-filter\_complex “fps=15,scale=400:\-1:flags=lanczos\[x\];\[x\]\[1:v\]paletteuse” sixthtry.gif

This uses our .MOV as an input but has a second \-i flag to use palette.png as a 2nd input. Then, ok, I copy pasted the rest of it, but I’m happy enough with what this produces that I’ll stop asking questions :D

Let me know if there’s anything I can explain in more detail, but don’t ask me for help installing things, just google it!

![](https://miro.medium.com/freeze/max/60/1*gC4a2M0vjVwC11AXLWCDlw.gif?q=20)

![](https://miro.medium.com/max/640/1*gC4a2M0vjVwC11AXLWCDlw.gif)

![](https://miro.medium.com/max/1280/1*gC4a2M0vjVwC11AXLWCDlw.gif)

![](https://miro.medium.com/freeze/max/60/1*MlhOASp3JnURJINT7dFCfA.gif?q=20)

![](https://miro.medium.com/max/500/1*MlhOASp3JnURJINT7dFCfA.gif)

![](https://miro.medium.com/max/1000/1*MlhOASp3JnURJINT7dFCfA.gif)

![](https://miro.medium.com/freeze/max/60/1*Oh2K7GYaKkGvPWbHFRIX1g.gif?q=20)

![](https://miro.medium.com/max/640/1*Oh2K7GYaKkGvPWbHFRIX1g.gif)

![](https://miro.medium.com/max/1280/1*Oh2K7GYaKkGvPWbHFRIX1g.gif)

![](https://miro.medium.com/freeze/max/60/1*rAjGjHJF0qd-KZLetlLt9A.gif?q=20)

![](https://miro.medium.com/max/500/1*rAjGjHJF0qd-KZLetlLt9A.gif)

![](https://miro.medium.com/max/1000/1*rAjGjHJF0qd-KZLetlLt9A.gif)

![](https://miro.medium.com/freeze/max/60/1*FsdQXYxpB-EI2ZhHSCLZkw.gif?q=20)

![](https://miro.medium.com/max/640/1*FsdQXYxpB-EI2ZhHSCLZkw.gif)

![](https://miro.medium.com/max/1280/1*FsdQXYxpB-EI2ZhHSCLZkw.gif)

![](https://miro.medium.com/freeze/max/60/1*L7SV27tMNds0K1BE5o5u-g.gif?q=20)

![](https://miro.medium.com/max/500/1*L7SV27tMNds0K1BE5o5u-g.gif)

![](https://miro.medium.com/max/1000/1*L7SV27tMNds0K1BE5o5u-g.gif)

Side by side comparison of easy, default color palettes and head\-scratching custom color palettes

I’d like to revisit this with more general advice and showing off other aspects of ffmpeg, but in the meantime here’s articles that others’ found helpful.

[Optimizing Animated GIFs by Converting to HTML5 Video \- Rigor](https://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video)