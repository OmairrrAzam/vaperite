//
//  VPRegionModel.h
//  vaperite
//
//  Created by Apple on 15/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPRegionModel : NSObject<NSCoding>

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *regionId;


+ (NSArray *)loadFromArray:(NSArray *)arrRegions;
- (id)initWithDictionary:(NSDictionary *)dictRegion;


@end
