
#import "VPUserManager.h"
#import "VPSessionManager.h"
#import "NSString+URLEncoding.h"


@implementation VPUserManager


- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken {
    
    
    
    NSDictionary *params;
//    if (pushToken) {
//        params = @{@"email": email, @"password": password, @"device": @"iOS", @"push_token": pushToken};
//    }
//    else {
        params = @{@"email": email, @"password": password, @"apiuser":@"techverx", @"apikey":@"techverx"};
   // }
    

    VPSessionManager *manager = [VPSessionManager sharedManager];

//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain; charset=UTF-8"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    
//    TMSessionManager *manager = [TMSessionManager sharedManager];
//    
    [manager POST:@"customapi/index/authenticate" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
    }
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSString *message = [self extractMessageFromTask:task andError:error];
//        if (self.delegate) {
//            [self.delegate userManager:self didFailToAuthenticateWithMessage:message];
//        }
    }];
    
}


@end
