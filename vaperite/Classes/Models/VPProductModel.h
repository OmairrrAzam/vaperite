//
//  VPProductModel.h
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPProductModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *imgUrl;

+ (NSArray *)loadFromArray:(NSArray *)arrProducts;

@end
