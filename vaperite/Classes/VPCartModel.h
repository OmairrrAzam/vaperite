//
//  VPCartModel.h
//  vaperite
//
//  Created by Apple on 09/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseManager.h"
@class VPProductModel;

@interface VPCartModel : NSObject<NSCoding>

@property (strong, nonatomic) NSMutableArray *products;
@property ( nonatomic) float total;



+ (VPCartModel *)currentCart;
+ (void)clearCurrentCart;
- (BOOL) productPresentInCart:(VPProductModel*)product;
- (BOOL) updateProductInCart:(VPProductModel*)product;
- (void) updateCalculations;
- (void)save;

@end
