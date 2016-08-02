//
//  VPCategoryModel.h
//  vaperite
//
//  Created by Apple on 02/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseVC.h"

@interface VPCategoryModel : VPBaseVC
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSArray *subCategories;

+ (NSArray *)loadFromArray:(NSArray *)arrCategories;
@end
