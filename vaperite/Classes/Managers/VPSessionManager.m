


#import "VPSessionManager.h"
#import "VPUsersModel.h"

static NSString *kBaseUrl = @"http://ec2-54-208-24-225.compute-1.amazonaws.com/";

#define AUTH_URL             @"http://ec2-54-208-24-225.compute-1.amazonaws.com"
#define OAUTH_CALLBACK       @"http%3A%2F%2Flocalhost%2Fmagento"
#define CONSUMER_KEY         @"fcaeb82cb3645b69d2c5fbc0d2983991"
#define kSessionid           @"vp_session_id"
#define CONSUMER_SECRET      @"7c305911f666276126a10628ac3746d8"
#define CONSUMER_SIGNATURE   @"7c305911f666276126a10628ac3746d8%26"
#define REQUEST_TOKEN_URL    @"/oauth/initiate"

#define REQUEST_TOKEN_METHOD @"POST"
#define ACCESS_TOKEN_METHOD  @"POST"


@implementation VPSessionManager

+ (instancetype)sharedManager {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        ((VPSessionManager*)instance).session.configuration.timeoutIntervalForRequest = 45.0;
        ((VPSessionManager*)instance).session.configuration.timeoutIntervalForResource = 45.0;
    });
    
    
    return instance;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler {

    NSMutableURLRequest *r = (NSMutableURLRequest *)request;
    
//    NSDictionary *sessionToken   = [VPUsersModel getTokenFromSession];
//    NSString *oauth_token_secret = sessionToken[@"oauth_token_secret"];
//    NSString *oauth_token        = sessionToken[@"oauth_token"];
//    
//    //NSString *apiKey = [NSString stringWithFormat:@"Token %@", currentUser.apiToken];
//  
//    [r setValue:oauth_token_secret forHTTPHeaderField:@"oauth_signature"];
//    [r setValue:oauth_token forHTTPHeaderField:@"oauth_token"];
//    [r setValue:CONSUMER_KEY forHTTPHeaderField:@"oauth_consumer_key"];
//    [r setValue:@"1468431919" forHTTPHeaderField:@"oauth_timestamp"];
//    [r setValue:@"uUZ062aVoUL9xud" forHTTPHeaderField:@"oauth_nonce"];
//    [r setValue:@"PLAINTEXT" forHTTPHeaderField:@"oauth_signature_method"];
//    [r setValue:@"1.0" forHTTPHeaderField:@"oauth_version"];
    
    
    

    return [super dataTaskWithRequest:r completionHandler:completionHandler];

}

- (void)getSessionIdWithUserApi:(NSString*)apiuser apiKey:(NSString*)apikey{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getSession"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"apiuser=techverx&apikey=techverx" ];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
      
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:strResponse forKey:kSessionid];
        
        [self.delegate sessionManager:self didFetchSession:strResponse];
        //VPProductModel *products = [VPProductModel alloc]
        
    }] resume];
   
}
@end
