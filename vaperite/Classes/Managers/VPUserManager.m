
#import "VPUserManager.h"
#import "VPSessionManager.h"
#import "NSString+URLEncoding.h"


@implementation VPUserManager

- (void)authenticate {
    [self obtainRequestTokenWithCompletion:^(NSError *error, NSDictionary *responseParams)
     {
         NSString *oauth_token_secret = responseParams[@"oauth_token_secret"];
         NSString *oauth_token        = responseParams[@"oauth_token"];
         
         if (oauth_token_secret && oauth_token){
             [self.delegate userManager:self didAuthenticate:responseParams];
         }else{
             [self.delegate userManager:self didFailToAuthenticate:@"Token not recieved - manual string"];
         }
         
    }];

}

- (void)obtainRequestTokenWithCompletion:(void (^)(NSError *error, NSDictionary *responseParams))completion
{
    
    NSString *request_url = [AUTH_URL stringByAppendingString:REQUEST_TOKEN_URL];
    //NSString *oauth_consumer_secret = CONSUMER_SECRET;
    
    NSMutableDictionary *allParameters = [self standardOauthParameters];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:request_url];
    [str appendString:@"?"];
    
    //NSMutableArray *parameterPairs = [NSMutableArray array];
    for (NSString *name in allParameters) {
        [str appendFormat:@"%@=%@&", name, allParameters[name]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    request.HTTPMethod = REQUEST_TOKEN_METHOD;
    
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *reponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               completion(nil, CHParametersFromQueryString(reponseString));
                           }];
}


- (NSMutableDictionary *)standardOauthParameters
{
    NSString *oauth_timestamp = [NSString stringWithFormat:@"%lu", (unsigned long)[NSDate.date timeIntervalSince1970]];
    
    NSString *oauth_nonce = [NSString getNonce];
    NSString *oauth_consumer_key = CONSUMER_KEY;
    NSString *oauth_signature_method = @"PLAINTEXT";
    NSString *oauth_version = @"1.0";
    NSString *oauth_signature = CONSUMER_SIGNATURE;
    NSString *oauth_callback  = OAUTH_CALLBACK;
    
    NSMutableDictionary *standardParameters = [NSMutableDictionary dictionary];
    [standardParameters setValue:oauth_consumer_key     forKey:@"oauth_consumer_key"];
    [standardParameters setValue:oauth_nonce            forKey:@"oauth_nonce"];
    [standardParameters setValue:oauth_signature_method forKey:@"oauth_signature_method"];
    [standardParameters setValue:oauth_timestamp        forKey:@"oauth_timestamp"];
    [standardParameters setValue:oauth_version          forKey:@"oauth_version"];
    [standardParameters setValue:oauth_signature        forKey:@"oauth_signature"];
    [standardParameters setValue:oauth_callback         forKey:@"oauth_callback"];
    
    
    return standardParameters;
}


static inline NSDictionary *CHParametersFromQueryString(NSString *queryString)
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (queryString)
    {
        NSScanner *parameterScanner = [[NSScanner alloc] initWithString:queryString];
        NSString *name = nil;
        NSString *value = nil;
        
        while (![parameterScanner isAtEnd]) {
            name = nil;
            [parameterScanner scanUpToString:@"=" intoString:&name];
            [parameterScanner scanString:@"=" intoString:NULL];
            
            value = nil;
            [parameterScanner scanUpToString:@"&" intoString:&value];
            [parameterScanner scanString:@"&" intoString:NULL];
            
            if (name && value)
            {
                [parameters setValue:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              forKey:[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    return parameters;
}


@end
