//
//  NSDictionary+Helper.h
//  TrackMyAssets
//
//  Created by Aftab Baig on 14/07/2015.
//  Copyright (c) 2015 Techverx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)

- (id)objectForKeyHandlingNull:(id)key;
- (id)objectForKeyHandlingNull:(id)key replacingNullWith:(NSString *)replacement;

@end
