//
//  VPProductModel.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProductModel.h"
#import "NSDictionary+Helper.h"

@implementation VPProductModel

+ (NSArray *)loadFromArray:(NSArray *)arrProducts {
    
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *dictProduct in arrProducts) {
        VPProductModel *product = [[VPProductModel alloc] initWithDictionary:dictProduct];
        [assets addObject:product];
    }
    return assets;
}

- (id)initWithDictionary:(NSDictionary *)dictProduct {
    self = [super init];
 
    self.imgUrl = [[dictProduct objectForKeyHandlingNull:@"image_url"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.name   = [[dictProduct objectForKeyHandlingNull:@"name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.price   = [[dictProduct objectForKeyHandlingNull:@"final_price_with_tax"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return self;
}


@end
