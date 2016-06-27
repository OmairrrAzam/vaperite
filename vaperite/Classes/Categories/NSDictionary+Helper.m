//
//  NSDictionary+Helper.m
//  TrackMyAssets
//
//  Created by Aftab Baig on 14/07/2015.
//  Copyright (c) 2015 Techverx. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

- (id)objectForKeyHandlingNull:(id)key {
    return [self objectForKeyHandlingNull:key replacingNullWith:@""];
}

- (id)objectForKeyHandlingNull:(id)key replacingNullWith:(NSString *)replacement {
    
    id object = [self objectForKey:key];
    if (object == [NSNull null]) {
        return replacement;
    }
    return object;
}



@end
