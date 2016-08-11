//
//  VPReviewManager.m
//  vaperite
//
//  Created by Aftab Baig on 04/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPReviewManager.h"
#import "VPReviewsModel.h"

@implementation VPReviewManager

- (void)addReview:(VPReviewsModel *)review {
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx", @"storeid":review.storeId, @"productid": review.productId, @"customerid": review.customerId, @"title": review.titl, @"detail": review.desc, @"nickname": review.nickName, @"rating":@"1" };
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"addReview" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            [self.delegate reviewManager:self didAddReview:review];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.delegate) {
            [self.delegate reviewManager:self didFailToAddReview:error.localizedDescription];
        }
    }];

}

@end
