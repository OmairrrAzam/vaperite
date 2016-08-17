//
//  VPRegionModel.m
//  vaperite
//
//  Created by Apple on 15/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPRegionModel.h"
#import "NSDictionary+Helper.h"

@implementation VPRegionModel

+ (NSArray *)loadFromArray:(NSArray *)arrRegions {
    NSMutableArray *regions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictRegion in arrRegions) {
        VPRegionModel *region = [[VPRegionModel alloc] initWithDictionary:dictRegion];
        [regions addObject:region];
    }
    
    return regions;
}

- (id)initWithDictionary:(NSDictionary *)dictRegion {
    self = [super init];
    
    self.code                 = [dictRegion objectForKeyHandlingNull:@"code"];
    self.name                 = [dictRegion objectForKeyHandlingNull:@"name"];
    self.regionId             = [dictRegion objectForKey:@"region_id"];
    
    return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.name      = [decoder decodeObjectForKey:@"name"];
        self.regionId  = [decoder decodeObjectForKey:@"region_id"];
        self.code      = [decoder decodeObjectForKey:@"code"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name     forKey:@"name"];
    [encoder encodeObject:self.regionId forKey:@"region_id"];
    [encoder encodeObject:self.code     forKey:@"code"];
}
@end




