//
//  VPProductModel.h
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPProductModel : NSObject

@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *sku;
@property (strong, nonatomic) NSString *set;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *categoryIds;
@property (strong, nonatomic) NSArray *websiteIds;

@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *shortDescription;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *imgUrl;

+ (NSArray *)loadFromArray:(NSArray *)arrProducts;
- (id)initWithDictionary:(NSDictionary *)dictProduct;

@end
