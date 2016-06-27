//
//  TMBaseManager.m
//  Vaperite
//
// 
//  Copyright (c) 2015 Techverx. All rights reserved.
//

#import "TMBaseManager.h"
#import "AFNetworkReachabilityManager.h"
#import "NSDictionary+Helper.h"

@implementation TMBaseManager

/*- (id)initWithOrganization:(TMOrganizationModel *)organization {
    self = [super init];
    self.organization = organization;
    return self;
}

- (NSString *)getPath:(NSString *)path {
    return [NSString stringWithFormat:@"organizations/%@/%@/", self.organization.id, path];
}

- (NSString *)getResourcePath:(NSString *)resource forResourceId:(NSString *)resourceId {
    return [NSString stringWithFormat:@"organizations/%@/%@/%@/", self.organization.id, resource, resourceId];
}
*/
- (NSString *)extractMessageFromTask:(NSURLSessionDataTask *)task andError:(NSError *)error {
    
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
    if (response.statusCode >= 400 && response.statusCode < 500) {
        NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id json = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
        if ([json respondsToSelector:@selector(objectForKey:)]) {
            return [json objectForKeyHandlingNull:@"error"];
        }
        else {
            return @"Unknown Error. Please try again later.";
        }
    }
    else if (response.statusCode >= 500) {
        return @"Internal Server Error.";
    }
    else {
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        if (reachabilityManager.reachable) {
            return @"Unknown Error. Please try again later.";
        }
        else {
            return @"The request timed out.";
        }
    }
}

@end
