
#import "VPUserManager.h"
#import "VPSessionManager.h"
#import "NSString+URLEncoding.h"
#import "VPUsersModel.h"

static NSString *kBaseUrl  = @"http://ec2-54-208-24-225.compute-1.amazonaws.com/";
static NSString *kApiKey   = @"techverx";
static NSString *kApiUser  = @"techverx";
@implementation VPUserManager


- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken {
    
    
//    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"constants" ofType:@"plist"];
//   // self.cellDescriptors = [NSMutableArray arrayWithContentsOfFile:plistPath];
//    NSMutableArray *constants = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/authenticate/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"apiuser=techverx&apikey=techverx&email=%@&password=%@",email,password ];
    
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
       
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSArray *users = [VPUsersModel loadFromArray:array];
       
        
       // VPUsersModel *user = [[VPUsersModel alloc]initWithDictionary:jsonResponse];
        
        [self.delegate userManager:self didAuthenticateWithUser:[users objectAtIndex:0] ];

        //NSArray *products = [VPUserModel loadFromArray:array];
        //[self.delegate productManager:self didFetchProducts:products];
    
        //VPProductModel *products = [VPProductModel alloc]
        
        
    }] resume];
}

- (void)getCartFromSession:(NSString*)sessionId andCartid:(NSString*)cartId{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getCart"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"session=%@&cartid=%@",sessionId,cartId ];
    
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        
        [self.delegate userManager:self didGetCart:array];
        
        
    }] resume];
    
}

@end
