//
//  Storage.h
//  NetworkDataStats
//
//  Created by Danny Shmueli on 5/15/15.
//  Copyright (c) 2015 omdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Storage.h"

@interface Storage : NSObject

+(id)getValueForKey:(NSString *)key;

+(void)storeValue:(id)value forKey:(NSString *)key;

@end
