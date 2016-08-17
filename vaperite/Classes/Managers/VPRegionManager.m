//
//  VPRegionManager.m
//  vaperite
//
//  Created by Apple on 15/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPRegionManager.h"
#import "VPSessionManager.h"
#import "VPRegionModel.h"

@implementation VPRegionManager

- (void)fetchAllRegions{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx", @"country_code":@"US"};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getRegion" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            NSString  *status  = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                NSArray *regArray = [responseObject objectForKey:@"data"];
                NSArray *regions = [VPRegionModel loadFromArray:regArray];
                [self.delegate regionManager:self didFetchAllRegions:regions];
            }else{
                NSString *msg = [responseObject objectForKey:@"data"];
                [self.delegate regionManager:self didFailToFetchAllRegions:msg];
            }

            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.delegate) {
            [self.delegate regionManager:self didFailToFetchAllRegions:error.localizedDescription];
        }
    }];
    
}

@end
