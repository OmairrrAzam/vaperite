//
//  VPRegionManager.h
//  vaperite
//
//  Created by Apple on 15/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseManager.h"
@class VPRegionManager;
@protocol VPRegionManagerDelegate

@optional

- (void)regionManager:(VPRegionManager *)regionManager didFetchAllRegions:(NSArray *)regions;
- (void)regionManager:(VPRegionManager *)regionManager didFailToFetchAllRegions:(NSString *)message;

@end

@interface VPRegionManager : VPBaseManager
@property (weak, nonatomic) id<VPRegionManagerDelegate> delegate;
- (void)fetchAllRegions;
@end




