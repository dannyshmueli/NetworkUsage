//
//  StatsManager.m
//  NetworkDataStats
//
//  Created by Danny Shmueli on 5/15/15.
//  Copyright (c) 2015 omdan. All rights reserved.
//

#import "StatsManager.h"
#import "Storage.h"
#import "StatsGetter.h"

NSString *const kCountingSinceStorageKey = @"CountingSinceStorageKey";
NSString *const kLastRebootStorageKey = @"LastRebootStorageKey";
NSString *const kUsageOffsetStorageKey = @"DataOffsetStorageKey";
NSString *const kUsageStorageKey = @"UsageStorageKey";

@implementation StatsManager

#pragma mark - API

+(void)update
{
    if (![Storage getValueForKey:kLastRebootStorageKey])//first launch
    {
        [Storage storeValue:[self lastRebootDate]
                      forKey:kLastRebootStorageKey];
        [self storeCountingSinceAsNow];
        //store fresh network usage
        [self storeFreshNetworkUsage];
    }
    else //Not first launch
    {
        NSDate *storedLastRebootDate = [self storedLastRebootDate];
        NSDate *deviceLastRebootDate = [self lastRebootDate];
        if (fabs(deviceLastRebootDate.timeIntervalSince1970 - storedLastRebootDate.timeIntervalSince1970) < 60)
        {
            //we can safely store fresh stats as it's the same reboot
            [self storeFreshNetworkUsage];
        }
        else
        {
            [Storage storeValue:deviceLastRebootDate
                         forKey:kLastRebootStorageKey];

            //new reboot: need to accumalte stats
            NSDictionary *storedStats = [Storage getValueForKey:kUsageStorageKey];
            NSDictionary *freshStats = [StatsGetter getNetworkInterfacesCounters];
            
            storedStats =  [self addOrSubtractStats:storedStats withStats:freshStats add:YES];
            [Storage storeValue:storedStats forKey:kUsageStorageKey];
        }
    }
}

+(void)reset
{
    [self storeCountingSinceAsNow];
    [Storage storeValue:[StatsGetter getNetworkInterfacesCounters] forKey:kUsageOffsetStorageKey];
    [self storeFreshNetworkUsage];
}

#pragma mark Getters

+(NSDictionary *)getStats
{
    NSDictionary *stats = [Storage getValueForKey:kUsageStorageKey];

    NSDictionary *usageOffsetStats = [Storage getValueForKey:kUsageOffsetStorageKey];
    
    if (usageOffsetStats)
    {
        stats = [self addOrSubtractStats:stats withStats:usageOffsetStats add:NO];
    }
    return stats;
}

+(NSDate *)countingSince
{
    return [Storage getValueForKey:kCountingSinceStorageKey];
}

+(NSDate *)lastRebootDate
{
    NSTimeInterval upTime = [NSProcessInfo processInfo].systemUptime;
    
    NSDate *now = [NSDate new];
    return [now dateByAddingTimeInterval:-upTime];
}

#pragma mark - Private

+(void)storeCountingSinceAsNow
{
    [Storage storeValue:[NSDate new]
                 forKey:kCountingSinceStorageKey];
}


+(void)storeFreshNetworkUsage
{
    [Storage storeValue:[StatsGetter getNetworkInterfacesCounters]
                 forKey:kUsageStorageKey];
}

+(NSDate *)storedLastRebootDate
{
    return [Storage getValueForKey:kLastRebootStorageKey];
}

+(NSDictionary *)addOrSubtractStats:(NSDictionary *)stats withStats:(NSDictionary *)otherStats add:(BOOL)add
{
    NSInteger sign = add ? 1 : -1;
    NSMutableDictionary *mutableStats = [[NSMutableDictionary alloc] initWithDictionary:stats];
    for (NSString *statsKey in mutableStats.allKeys)
    {
        NSInteger one = [stats[statsKey] integerValue];
        NSInteger two = [otherStats[statsKey] integerValue];
        NSInteger result = one + (two *sign);
        
        mutableStats[statsKey] = @(result);
    }
    return mutableStats;
}


@end
