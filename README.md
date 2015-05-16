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
* "Download Something": downloads a 2mb file from the internet. 

###Caveats:
Using the background fetch to make sure the stats are updated can cause incorrect stats in extreme cases: according to Apple Docs when registering for background fetch - which wakes up the app to do some actions:
```ObjC
- (void)setMinimumBackgroundFetchInterval:(NSTimeInterval)minimumBackgroundFetchInterval
```
> The minimum number of seconds that must elapse before another background fetch can be initiated. This value is **advisory only and does not indicate the exact amount of time expected between fetch operations.**
> [See Apple Doc](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplication_Class/#//apple_ref/occ/instm/UIApplication/setMinimumBackgroundFetchInterval:)

We set this value to `UIApplicationBackgroundFetchIntervalMinimum` to update as often as the system allows. This sounds vague and therefore there might be a case where the user:
(a) Reboots the device. (b) Does many network consuming actions.
(c) Reboots again.
And all the while our background fetch action is not called.

To overcome such scenario we could replace the background fetch with remote notification mechanism.

###Attributions:
* [Stackoverflow answer](http://stackoverflow.com/questions/7946699/iphone-data-usage-tracking-monitoring/8014012#8014012) for getting the network interfaces stats.
* Background fetch info: http://possiblemobile.com/2013/09/ios-7-background-fetch/
