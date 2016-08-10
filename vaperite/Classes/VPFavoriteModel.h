//
//  VPFavouriesModel.h
//  vaperite
//
//  Created by Apple on 09/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VPProductModel;

@interface VPFavoriteModel : NSObject<NSCoding>

@property (strong, nonatomic) NSMutableArray *products;



+ (VPFavoriteModel *)currentFav;
+ (void)clearCurrentFav;
- (BOOL) productPresentInFav:(VPProductModel*)product;
- (void)save;
@end
