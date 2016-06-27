//
//  TMSessionManager.m
//  TrackMyAssets
//
//  Created by Aftab Baig on 09/07/2015.
//  Copyright (c) 2015 Techverx. All rights reserved.
//

#import "TMSessionManager.h"


//static NSString *kBaseUrl = @"http://www.splicked.com/api/";
 static NSString *kBaseUrl = @"http://www.trackmyassets.biz/api/";
//static NSString *kBaseUrl = @"http://8fd22047.ngrok.io/api/";

@implementation TMSessionManager

+ (instancetype)sharedManager {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        ((TMSessionManager*)instance).session.configuration.timeoutIntervalForRequest = 45.0;
        ((TMSessionManager*)instance).session.configuration.timeoutIntervalForResource = 45.0;
    });
    return instance;
}

/*- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler {

    NSMutableURLRequest *r = (NSMutableURLRequest *)request;
    TMUserModel *currentUser = [TMUserModel currentUser];
    if (currentUser) {
        NSString *apiKey = [NSString stringWithFormat:@"Token %@", currentUser.apiToken];
        [r setValue:apiKey forHTTPHeaderField:@"Authorization"];
    }
    return [super dataTaskWithRequest:r completionHandler:completionHandler];

}*/

@end
