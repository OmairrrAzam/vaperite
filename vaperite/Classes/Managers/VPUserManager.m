
#import "VPUserManager.h"
#import "VPSessionManager.h"
#import "NSString+URLEncoding.h"
#import "VPUsersModel.h"
#import "VPReviewsModel.h"

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

- (void)createUserFromStoreId:(NSString*)storeId session:(NSString*)sessionId email:(NSString*)email password:(NSString*)password firstname:(NSString*)fname lastname:(NSString*)lname{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/createCustomer"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"storeid=%@&session=%@&email=%@&password=%@&fn%@&ln%@",storeId,sessionId, email,password,fname,lname ];
    
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        VPUsersModel *user = [[VPUsersModel alloc]initWithDictionary:dict];
        [self.delegate userManager:self didCreateUser:user];
        
    }] resume];
    
}

- (void)getCustomerInfoFromCustomerId:(NSString*)customerId andSession:(NSString*)sessionId{
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getCustomerInfo"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"customerid=%@&session=%@",customerId,sessionId];
    
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        VPUsersModel *user = [[VPUsersModel alloc]initWithDictionary:dict];
        [self.delegate userManager:self didGetCustomerInfo:user];
        
    }] resume];
}

- (void)addReviewFromSession:(NSString*)sessionId storeId:(NSString*)storeId productId:(NSString*)productId customerId:(NSString*)customerId title:(NSString*)title detail:(NSString*)detail nickName:(NSString*)nickName{
    
     NSURLSession *session = [NSURLSession sharedSession];
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/addReview"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"session=%@&storeid=%@&productid=%@&customerid=%@&title=%@&detail=%@&nickname=%@",sessionId,storeId,productId,customerId,title,detail,nickName];
    
    
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        VPReviewsModel *review = [[VPReviewsModel alloc]initWithDictionary:dict];
        [self.delegate userManager:self didAddReview:review];
        
    }] resume];

}
@end
