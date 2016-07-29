

#import "AFHTTPSessionManager.h"

@class VPSessionManager;

@protocol VPSessionManagerDelegate

@optional

- (void)sessionManager:(VPSessionManager *)sessionManager didFetchSession:(NSString*)sessionId;
- (void)sessionManager:(VPSessionManager *)sessionManager failToFetchSessionWithMessage:(NSString*)message;

@end

@interface VPSessionManager : AFHTTPSessionManager
@property (weak, nonatomic) id<VPSessionManagerDelegate> delegate;

+ (instancetype)sharedManager;
- (void)getSessionIdWithUserApi:(NSString*)apiuser apiKey:(NSString*)apikey;

@end
