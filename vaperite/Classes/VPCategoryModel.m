//
//  VPCategoryModel.m
//  vaperite
//
//  Created by Apple on 02/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPCategoryModel.h"
#import "NSDictionary+Helper.h"

@interface VPCategoryModel ()

@end

@implementation VPCategoryModel


+ (NSArray *)loadFromArray:(NSArray *)arrCategories {
    NSMutableArray *dictCategories = [[NSMutableArray alloc] init];
    for (NSDictionary *dictCat in arrCategories) {
        VPCategoryModel *cat = [[VPCategoryModel alloc] initWithDictionary:dictCat];
        [dictCategories addObject:cat];
    }
    return dictCategories;
}



- (id)initWithDictionary:(NSDictionary *)dictCategory {
    
    self = [super init];
    
    self.name        = [dictCategory objectForKeyHandlingNull:@"name"];
    self.id          = [dictCategory objectForKeyHandlingNull:@"id"];
    self.parentId    = [dictCategory objectForKeyHandlingNull:@"parent_id"];
    
    return self;
}


@end
