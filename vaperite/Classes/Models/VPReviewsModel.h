//
//  VPReviewsModel.h
//  vaperite
//
//  Created by Apple on 01/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseVC.h"

@interface VPReviewsModel : VPBaseVC

@property (strong, nonatomic) NSString *titl;
@property (strong, nonatomic) NSString *desc;

+ (NSArray *)loadFromArray:(NSArray *)arrReviews;
@end
