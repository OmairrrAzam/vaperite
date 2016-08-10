
#import "VPUserManager.h"
#import "VPSessionManager.h"
#import "NSString+URLEncoding.h"
#import "VPUsersModel.h"
#import "VPReviewsModel.h"
#import "VPUsersModel.h"

static NSString *kBaseUrl  = @"http://ec2-54-208-24-225.compute-1.amazonaws.com/";
static NSString *kApiKey   = @"techverx";
static NSString *kApiUser  = @"techverx";
@implementation VPUserManager


- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken {
    NSDictionary *params = @{@"email": email, @"password": password, @"apikey": @"techverx", @"apiuser":@"techverx"};
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"authenticate" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
                NSDictionary *dictUser = [responseObject objectForKey:@"data"];
                VPUsersModel *user = [[VPUsersModel alloc] initWithDictionary:dictUser];
                [self.delegate userManager:self didAuthenticateWithUser:user ];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if (self.delegate) {
            NSString *message = [self extractMessageFromTask:task andError:error];
            [self.delegate userManager:self didFailToAuthenticateWithMessage:message];
        }
    }];
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

-(void) fetchAddressFromCustomerId:(NSString*)customerId{
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"customerid":customerId, @"billing_flag":@"1",@"shipping_flag":@"1"};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getCustomerAddress" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            NSString     *status  = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                
                NSDictionary *address = [responseObject objectForKey:@"data"];
                VPUsersModel *user = [[VPUsersModel alloc]initWithDictionary:address];
                [self.delegate userManager:self didFetchAddress:user];
            }else{
                 NSString *msg = [responseObject objectForKey:@"data"];
                [self.delegate userManager:self didFailToFetchAddress:msg];
            }
          
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate) {
            NSString *message = [self extractMessageFromTask:task andError:error];
            [self.delegate userManager:self didFailToFetchAddress:message];
        }
    }];

}

-(void) updateAddressWithCustomerID:(NSString*)customerId firstName:(NSString*)fn  lastName:(NSString*)ln streetAddress:(NSString*)street city:(NSString*)city postalCode:(NSString*)postal{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"customerid":customerId, @"billing_flag":@"1",@"shipping_flag":@"1",@"fn":fn, @"ln":ln, @"street_address":street, @"city":city, @"post_code":postal, @"country_code": @"US", @"phone":@"123"};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"addCustomerAddress" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            NSString *addressStr = [responseObject objectForKey:@"data"];
            
            [self.delegate userManager:self didUpdateAddress:addressStr];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.delegate) {
            NSString *message = [self extractMessageFromTask:task andError:error];
            [self.delegate userManager:self didFailToUpdateAddress:message];
        }
    }];
    
}

-(void) updatePasswordWithCustomerID:(NSString*)customerId firstName:(NSString*)fn  lastName:(NSString*)ln email:(NSString*)email password:(NSString*)password{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"customerid":customerId, @"fn":fn, @"ln":ln,
                              @"email":email, @"password":password};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"updateCustomerProfile" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
             NSString *msg = [responseObject objectForKey:@"data"];
             NSString *status = [responseObject objectForKey:@"status"];
            if ([status boolValue] == 1){
                [self.delegate userManager:self didUpdatePassword:msg];
            }else{
                [self.delegate userManager:self didFailToUpdatePassword:msg];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.delegate) {
            NSString *message = [self extractMessageFromTask:task andError:error];
            [self.delegate userManager:self didFailToUpdatePassword:message];
        }
    }];
    
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
