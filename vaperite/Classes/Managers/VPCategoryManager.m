//
//  VPCategoriesManager.m
//  vaperite
//
//  Created by Apple on 02/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPCategoryManager.h"
#import "VPCategoryModel.h"

@implementation VPCategoryManager

- (void)loadCategoriesWithSessionId: (NSString*)sessionId{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx"};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getCategories" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            NSArray *arrCategories = [responseObject objectForKey:@"data"];
            NSArray *categories = [VPCategoryModel loadFromArray:arrCategories];
            [self.delegate categoryManager:self didLoadCategories:categories];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = @"testing";
        if (self.delegate) {
            [self.delegate categoryManager:self didFailToLoadCategories:message];
        }
        
        if (self.delegate) {
            NSString *message = [self extractMessageFromTask:task andError:error];
            [self.delegate categoryManager:self didFailToLoadCategories:message];
        }
    }];
    
}

- (void)loadCategoriesByParentId: (NSString*)parentId sessionId:(NSString*)sessionId{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx", @"parentid":parentId};
 
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getCategoriesByParentId" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            NSArray *arrDetails = [responseObject objectForKey:@"data"];
            NSArray *categories = [VPCategoryModel loadFromArray:arrDetails];
            
            [self.delegate categoryManager:self didLoadCategoriesFromParentId:categories];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        if (self.delegate) {
            NSString *message = [self extractMessageFromTask:task andError:error];
            [self.delegate categoryManager:self didFailToLoadCategoriesFromParentId:message];
        }
    }];
    
}

@end
