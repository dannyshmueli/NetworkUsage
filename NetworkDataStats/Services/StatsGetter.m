//
//  StatsGetter.m
//  NetworkDataStats
//
//  Created by Danny Shmueli on 5/15/15.
//  Copyright (c) 2015 omdan. All rights reserved.
//

#import "StatsGetter.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@implementation StatsGetter

//names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN

//Search by prefix because there could be serveral internal interfaces i.e pdp_ip1.
NSString *const kInterfacePrefixWifi = @"en";
NSString *const kInterfacePrefixWWan = @"pdp_ip";

+(NSDictionary *)getNetworkInterfacesCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    NSInteger WiFiSent = 0;
    NSInteger WiFiReceived = 0;
    NSInteger WWANSent = 0;
    NSInteger WWANReceived = 0;
    
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            NSString *name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                NSLog(@"iinterface name: %@", name);
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return @{
             @"wifiSent" : @(WiFiSent),
             @"wifiReceived" : @(WiFiReceived),
             @"WWanSent" : @(WWANSent),
             @"WWantReceived" : @(WWANReceived)
             };
}

@end
