//
//  VPCategoriesManager.h
//  vaperite
//
//  Created by Apple on 02/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseManager.h"
@class VPCategoryManager;
@protocol VPCategoryManagerDelegate

@optional

- (void)categoryManager:(VPCategoryManager *)categoryManager didLoadCategories:(NSArray *)categories;
- (void)categoryManager:(VPCategoryManager *)categoryManager didFailToLoadCategories:(NSString *)message;

- (void)categoryManager:(VPCategoryManager *)categoryManager didLoadCategoriesFromParentId:(NSArray *)categories;
- (void)categoryManager:(VPCategoryManager *)categoryManager didFailToLoadCategoriesFromParentId:(NSString *)message;

@end

@interface VPCategoryManager : VPBaseManager
@property (weak, nonatomic) id<VPCategoryManagerDelegate> delegate;

- (void)loadCategoriesWithSessionId: (NSString*)sessionId;
@end



