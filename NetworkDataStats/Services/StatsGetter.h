//
//  StatsGetter.h
//  NetworkDataStats
//
//  Created by Danny Shmueli on 5/15/15.
//  Copyright (c) 2015 omdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsGetter : NSObject

/**
 *  get the network stats for wifi and wan since last reboot.
 *
 *  @param NSDictionary <#NSDictionary description#>
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)getNetworkInterfacesCounters;

@end
