
#import "VPUserManager.h"
#import "VPSessionManager.h"
#import "NSString+URLEncoding.h"
#import "VPUsersModel.h"
#import "VPReviewsModel.h"
#import "VPUsersModel.h"
#import "VPRegionModel.h"
#import "VPProductOptionsModel.h"

static NSString *kBaseUrl  = @"http://ec2-54-208-24-225.compute-1.amazonaws.com/";
static NSString *kApiKey   = @"techverx";
static NSString *kApiUser  = @"techverx";
@implementation VPUserManager


- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken {
    NSDictionary *params = @{@"email": email, @"password": password, @"apikey": @"techverx", @"apiuser":@"techverx"};
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"authenticate" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            NSString *status  = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                NSDictionary *dictUser = [responseObject objectForKey:@"data"];
                VPUsersModel *user = [[VPUsersModel alloc] initWithDictionary:dictUser];
                
                [self.delegate userManager:self didAuthenticateWithUser:user ];
                
            }else{
                NSString *msg = [responseObject objectForKey:@"data"];
                [self.delegate userManager:self didFailToAuthenticateWithMessage:msg];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if (self.delegate) {
            [self.delegate userManager:self didFailToAuthenticateWithMessage:error.localizedDescription];
        }
    }];
}

- (void)getCartFromSession:(NSString*)sessionId andCartid:(NSString*)cartId{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
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

- (void)createUserFromStoreId:(NSString*)storeId password:(NSString*)password user:(VPUsersModel*)u{
    
    NSDictionary *params = @{@"email": u.email, @"password": password, @"apikey": @"techverx", @"apiuser":@"techverx", @"storeid":storeId, @"fn": u.firstName, @"ln": u.lastName};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"createCustomer" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            NSString *status  = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                NSDictionary *userDict = [responseObject objectForKey:@"data"];
                
                VPUsersModel *user = [[VPUsersModel alloc]initWithDictionary:userDict];
                
                [self.delegate userManager:self didCreateUser:user];
            }else{
                NSString *msg = [responseObject objectForKey:@"data"];
                [self.delegate userManager:self didFailToCreateUser:msg];
            }

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate) {
            NSString *message = [self extractMessageFromTask:task andError:error];
            [self.delegate userManager:self didFailToCreateUser:message];
        }
        
    }];
}

- (void)getCustomerInfoFromCustomerId:(NSString*)customerId andSession:(NSString*)sessionId{
    NSURLSession *session = [NSURLSession sharedSession];
    
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
            [self.delegate userManager:self didFailToFetchAddress:error.localizedDescription];
        }
    }];

}

-(void) updateAddressWithCustomerID:(NSString*)customerId firstName:(NSString*)fn  lastName:(NSString*)ln streetAddress:(NSString*)street city:(NSString*)city postalCode:(NSString*)postal region:(NSString*)regionid{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"customerid":customerId, @"billing_flag":@"1",@"shipping_flag":@"1",@"fn":fn, @"ln":ln, @"street_address":street, @"city":city, @"post_code":postal, @"country_code": @"US", @"phone":@"123", @"regionid":regionid};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"addCustomerAddress" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            NSString  *status  = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                NSDictionary *address = [responseObject objectForKey:@"data"];
                VPUsersModel *user    = [[VPUsersModel alloc]initWithDictionary:address];
                
                [self.delegate userManager:self didUpdateAddress:user];
            }else{
                NSString *msg = [responseObject objectForKey:@"data"];
                [self.delegate userManager:self didFailToFetchAddress:msg];
            }
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.delegate) {
            [self.delegate userManager:self didFailToUpdateAddress:error.localizedDescription];
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
             NSString *status = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                
                [self.delegate userManager:self didUpdatePassword:msg];
            }else{
                
                [self.delegate userManager:self didFailToUpdatePassword:msg];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.delegate) {
            [self.delegate userManager:self didFailToUpdatePassword:error.localizedDescription];
        }
    }];
    
}

- (void) forgotPassword:(NSString*)email {
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"email":email};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"forgortPassword" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            NSString *msg = [responseObject objectForKey:@"data"];
            NSString *status = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                
                [self.delegate userManager:self didForgotPassword:msg];
            }else{
                
                [self.delegate userManager:self didFailToForgotPassword:msg];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.delegate) {
            [self.delegate userManager:self didFailToForgotPassword:error.localizedDescription];
        }
    }];
    
}


- (void)addReviewFromSession:(NSString*)sessionId storeId:(NSString*)storeId productId:(NSString*)productId customerId:(NSString*)customerId title:(NSString*)title detail:(NSString*)detail nickName:(NSString*)nickName{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
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

- (void) createOrder:(VPUsersModel*)u andProducts:(NSArray*)products{
    
    
    NSMutableArray *jsonProductsArray = [[NSMutableArray alloc] init];
    
    
    
    
   // NSMutableArray *jsonArrayOptionCustom =  [[NSMutableArray alloc] init];
   // NSMutableArray *jsonArrayOptionDefault = [[NSMutableArray alloc] init];
    
    BOOL customOptionPresent  = false;
    BOOL defaultOptionPresent = false;
    
    for (VPProductModel *product in products) {
         NSMutableDictionary *jsonProducts = [[NSMutableDictionary alloc] init];
        [jsonProducts setObject:product.id forKey:@"id"];
        [jsonProducts setObject:[NSString stringWithFormat:@"%d",product.cartQty] forKey:@"quantity"];
        
        if (product.options && [product.options count]) {
            
             NSMutableDictionary *dictOption = [[NSMutableDictionary alloc] init];
            for(VPProductOptionsModel *option in product.options){
                
               
                
                if ([option.type isEqualToString: @"default"]) {
                    defaultOptionPresent = true;
                    [dictOption setObject:option.pickedId forKey:option.title];
                    
                }else if ([option.type isEqualToString: @"custom"]){
                    customOptionPresent = true;
                    [dictOption setObject:option.pickedId forKey:option.id];
                    
                }
            }
            
            if (defaultOptionPresent) {
                [jsonProducts setObject:dictOption forKey:@"configurable"];
                defaultOptionPresent = false;
                //[jsonArrayOptionDefault addObject:dictOption];
            }
            
            if (customOptionPresent) {
                [jsonProducts setObject:dictOption forKey:@"options"];
                defaultOptionPresent = false;
                //[jsonArrayOptionCustom addObject:dictOption];
            }
        }
        
        [jsonProductsArray addObject:jsonProducts];
        
    }
    
    if (defaultOptionPresent) {
        //[jsonProducts setObject:jsonArrayOptionDefault forKey:@"configurable"];
    }
    
    if (customOptionPresent) {
        //[jsonProducts setObject:jsonArrayOptionCustom forKey:@"options"];
    }

    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:jsonProductsArray options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"email":u.email, @"storeid":@"1",@"firstname":u.firstName, @"lastname":u.lastName, @"street_address":u.street, @"city":u.city, @"postcode":u.postalcode, @"phone":@"123", @"regionid":u.region.regionId, @"product_hash":myString};
    
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"createOrder" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            NSString *msg = [responseObject objectForKey:@"data"];
            NSString *status = [responseObject objectForKey:@"success"];
            
            if ([status boolValue] == 1){
                [self.delegate userManager:self didCreateOrder:@"Order Created Successfully.."];
            }else{
                [self.delegate userManager:self didFailToCreateOrder:msg];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate) {
            [self.delegate userManager:self didFailToCreateOrder:error.localizedDescription];
        }
    }];
}

@end
