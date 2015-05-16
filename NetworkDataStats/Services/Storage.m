//
//  Storage.m
//  NetworkDataStats
//
//  Created by Danny Shmueli on 5/15/15.
//  Copyright (c) 2015 omdan. All rights reserved.
//

#import "Storage.h"

@implementation Storage

+(id)getValueForKey:(NSString *)key
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)storeValue:(id)value forKey:(NSString *)key
{
    if (value)
    {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
