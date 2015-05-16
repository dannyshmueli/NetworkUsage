//
//  StatsManager.h
//  NetworkDataStats
//
//  Created by Danny Shmueli on 5/15/15.
//  Copyright (c) 2015 omdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsManager : NSObject

+(void)update;
+(void)reset;

+(NSDictionary *)getStats;
+(NSDate *)countingSince;
+(NSDate *)lastRebootDate;




@end
