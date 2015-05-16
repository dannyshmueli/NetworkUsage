# NetworkUsage
iOS Network Usage Meter proof of concept.

<img src=https://raw.githubusercontent.com/dannyshmueli/NetworkUsage/master/screenshot.png width=320 height=480 />
###How:
* By investigating the iOS network interfaces using [getifaddrs](http://man7.org/linux/man-pages/man3/getifaddrs.3.html) method. We are able to get the incoming and outgoing bytes for each network interface since last reboot.
* To get the last reboot:
```ObjC
[NSProcessInfo processInfo].systemUptime;
```

###What:
* On app launch updates the stats.
* Uses periodic background fetch to update the results as often as possible.
* Does not loose stats because of reboots.
* "Reset" button: resets counting stats (saves current stats as offset).
* "Downoad Something": downloads a 2mb file from the internet. 


###Attributions:
[Stackoverflow answer](// see example code:
//http://stackoverflow.com/questions/7946699/iphone-data-usage-tracking-monitoring/8014012#8014012) for getting the network interfaces stats.
