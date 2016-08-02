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
    NSURLSession *session = [NSURLSession sharedSession];

    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getCategories"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"session=%@",sessionId];
    
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSArray *categories = [VPCategoryModel loadFromArray:dict];
        
        [self.delegate categoryManager:self didLoadCategories:categories];
        //VPUsersModel *user = [[VPUsersModel alloc]initWithDictionary:dict];
        //[self.delegate userManager:self didCreateUser:user];
        
     }] resume];
}

- (void)loadCategoriesByParentId: (NSString*)parentId sessionId:(NSString*)sessionId{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getCategoriesByParentId"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"parentid=%@&session=%@",parentId,sessionId];
    
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSArray *categories = [VPCategoryModel loadFromArray:dict];
        
        [self.delegate categoryManager:self didLoadCategoriesFromParentId:categories];
        //VPUsersModel *user = [[VPUsersModel alloc]initWithDictionary:dict];
        //[self.delegate userManager:self didCreateUser:user];
        
    }] resume];
}

@end
