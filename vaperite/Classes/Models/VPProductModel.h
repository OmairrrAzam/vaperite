//
//  VPProductModel.h
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VPProductModel : NSObject<NSCoding>

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *sku;
@property (strong, nonatomic) NSString *set;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray  *categoryIds;
@property (strong, nonatomic) NSArray  *websiteIds;
@property (strong, nonatomic) NSArray  *reviews;
//@property (strong, nonatomic) NSDictionary  *doses;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *shortDescription;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *rating;
@property (nonatomic) int cartStrength;
@property (strong,nonatomic) NSString *cartStrengthValue;
@property (nonatomic) int cartQty;
@property (strong,nonatomic) NSString *stockQty;
@property (strong ,nonatomic) NSString *inStock;
@property (strong,nonatomic) NSMutableArray *options;


+ (NSArray *)loadFromArray:(NSArray *)arrProducts;
- (id)initWithDictionary:(NSDictionary *)dictProduct;
- (id)initWithDetailsDictionary:(NSDictionary *)dictProduct;
- (int)validateForCart;
@end
