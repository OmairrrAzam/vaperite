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
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *customerId;
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *rating;

+ (NSArray *)loadFromArray:(NSArray *)arrReviews;
- (id)initWithDictionary:(NSDictionary *)dictReview;

@end
