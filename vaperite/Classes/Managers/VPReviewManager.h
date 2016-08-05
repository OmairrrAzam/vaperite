//
//  VPReviewManager.h
//  vaperite
//
//  Created by Aftab Baig on 04/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPReviewManager;
@class VPReviewsModel;

@protocol VPReviewManagerDelegate

@optional

- (void)reviewManager:(VPReviewManager *)manager didAddReview:(VPReviewsModel *)review;
- (void)reviewManager:(VPReviewManager *)manager didFailToAddReview:(NSString *)message;

@end

@interface VPReviewManager : NSObject

@property (weak, nonatomic) id<VPReviewManagerDelegate> delegate;

- (void)addReview:(VPReviewsModel *)review;

@end
