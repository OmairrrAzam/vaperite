

#import "VPProductManager.h"
#import "VPSessionManager.h"
#import "VPProductModel.h"
#import "VPMarkerModel.h"
#import "VPReviewsModel.h"

static NSString *kBaseUrl  = @"http://ec2-54-208-24-225.compute-1.amazonaws.com/";
static NSString *kApiKey   = @"techverx";
static NSString *kApiUser  = @"techverx";

@implementation VPProductManager

- (void)fetchALLProductsWithSessionId:(NSString*)sessionId andStoreId:(NSString*)storeId  {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getProductList"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"session=%@&storeid%@&limit=10&page=1",sessionId,storeId ];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSArray *products = [VPProductModel loadFromArray:array];
        
        [self.delegate productManager:self didFetchALLProducts:products];
        
        //VPProductModel *products = [VPProductModel alloc]
        
        
    }] resume];

}
- (void)fetchFeaturedProductsWithSessionId:(NSString*)sessionId {
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx"};
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getFeaturedProducts" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            NSArray *dictProducts = [responseObject objectForKey:@"data"];
            
            NSArray *products = [VPProductModel loadFromArray:dictProducts];
            
            [self.delegate productManager:self didFetchFeaturedProducts:products];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = @"testing";
        if (self.delegate) {
            [self.delegate productManager:self didFailToFetchFeaturedProducts:message];
        }
    }];
    
}

- (void)fetchRecommendedProductsWithSessionId:(NSString*)sessionId{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx"};
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getRecommendedProducts" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            NSArray *dictProducts = [responseObject objectForKey:@"data"];
            
            NSArray *products = [VPProductModel loadFromArray:dictProducts];
            
            [self.delegate productManager:self didFetchRecommendedProducts:products];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = @"testing";
        if (self.delegate) {
            [self.delegate productManager:self didFailToFetchRecommendedProducts:message];
        }
    }];
    

}

- (void)fetchProductDetailsWithProductId:(NSString*)productId andStoreId:(NSString*)storeId{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx", @"productid": productId, @"storeid":storeId};
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getProductDetail" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            NSDictionary *dictDetails = [responseObject objectForKey:@"data"];
            
            VPProductModel *details = [[VPProductModel alloc]initWithDetailsDictionary:dictDetails];
            
             [self.delegate productManager:self didFetchProductDetails:details];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = @"testing";
        if (self.delegate) {
            [self.delegate productManager:self didFailToFetchFeaturedProducts:message];
        }
    }];

}

- (void)fetchProductReviewswithProductId:(NSString*)productId andStoreId:(NSString*)storeId{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx", @"productid": productId,@"storeid":@"1"};
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getReview" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            //NSArray *arrDetails = [responseObject objectForKey:@"data"];
            
            NSArray *reviews = [VPReviewsModel loadFromArray:responseObject];
            
            [self.delegate productManager:self didFetchProductReviews:reviews];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = @"testing";
        if (self.delegate) {
            [self.delegate productManager:self didFailToFetchFeaturedProducts:message];
        }
    }];
    
    
//    
//    NSURL *url = [NSURL URLWithString:@"http://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getReview"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    NSString *params = [NSString stringWithFormat:@"productid=%@&storeid=%@",productId, storeId ];
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", strResponse);
//        
//        NSArray *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
//        
//        
//        NSArray *reviews = [VPReviewsModel loadFromArray:dict];
//        [self.delegate productManager:self didFetchProductReviews:reviews];
//        
//    }] resume];
}

- (void)fetchProductImageWithProductId:(NSString*)productId andSessionId:(NSString*)sessionId{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getProductImage"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"productid=%@&session=%@",productId, sessionId ];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSString *imgUrl;
        for (NSDictionary *d in dict) {
            imgUrl = [d objectForKey:@"url"];
        }
        
       [self.delegate productManager:self didFetchProductImage:imgUrl];
       // NSArray *reviews = [VPReviewsModel loadFromArray:dict];
       //[self.delegate productManager:self didFetchProductReviews:reviews];
        
    }] resume];
}

- (void) fetchProductRatingFromSession:(NSString*)sessionId storeId:(NSString*)storeId andProductId:(NSString*)productId{
    
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"productid":@"8535", @"storeid":storeId};
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getRatting" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            //NSArray *dictProducts = [responseObject objectForKey:@"data"];
            //NSArray *products = [VPProductModel loadFromArray:dictProducts];
            [self.delegate productManager:self didFetchProductRating:responseObject];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = @"testing";
        if (self.delegate) {
            [self.delegate productManager:self didFailToFetchProductsFromCategoryId:message];
        }
    }];
    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getRatting"];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    NSString *params = [NSString stringWithFormat:@"session=%@&storeid=%@&productid=%@",sessionId, storeId, productId ];
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//       // NSLog(@"%@", strResponse);
//        
//    
//        // NSArray *reviews = [VPReviewsModel loadFromArray:dict];
//        //[self.delegate productManager:self didFetchProductReviews:reviews];
//        
//    }] resume];
//
}


- (void) fetchProductsFromCategoryId:(NSString*)categoryId {
    NSDictionary *params = @{ @"apikey": @"techverx", @"apiuser":@"techverx",@"categoryid":categoryId};
    VPSessionManager *manager = [VPSessionManager sharedManager];
    
    [manager POST:@"getproductsbycategory" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.delegate) {
            
            NSArray *dictProducts = [responseObject objectForKey:@"data"];
            NSArray *products = [VPProductModel loadFromArray:dictProducts];
            [self.delegate productManager:self didFetchProductsFromCategoryId:products];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *message = @"testing";
        if (self.delegate) {
            [self.delegate productManager:self didFailToFetchProductsFromCategoryId:message];
        }
    }];
    
}



@end
