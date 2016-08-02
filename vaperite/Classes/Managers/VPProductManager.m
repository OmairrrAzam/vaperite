

#import "VPProductManager.h"
#import "VPSessionManager.h"
#import "VPProductModel.h"
#import "VPMarkerModel.h"
#import "VPReviewsModel.h"

static NSString *kBaseUrl  = @"http://ec2-54-208-24-225.compute-1.amazonaws.com/";
static NSString *kApiKey   = @"techverx";
static NSString *kApiUser  = @"techverx";

@implementation VPProductManager

- (void)fetchFeaturedProductsWithSessionId:(NSString*)sessionId {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getAwardedProducts/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"session=%@",sessionId ];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSArray *products = [VPProductModel loadFromArray:array];
        [self.delegate productManager:self didFetchFeaturedProducts:products];

        //VPProductModel *products = [VPProductModel alloc]
        
        
    }] resume];
}

- (void)fetchRecommendedProductsWithSessionId:(NSString*)sessionId{
    NSURLSession *session = [NSURLSession sharedSession];
    
    //NSString *path = @"customapi/index/getAwardedProducts/";
    NSURL *url = [NSURL URLWithString:@"https://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getRecommendedProducts"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"session=%@",sessionId ];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSArray *products = [VPProductModel loadFromArray:array];
        [self.delegate productManager:self didFetchFeaturedProducts:products];
        
        //VPProductModel *products = [VPProductModel alloc]
        
        
    }] resume];
}

- (void)fetchProductDetailsWithProductId:(NSString*)productId andSessionId:(NSString*)sessionId{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getProductDetail"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"session=%@&productid=%@",sessionId, productId ];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        VPProductModel *product = [[VPProductModel alloc]initWithDictionary:dict];
        
       // NSArray *products = [VPProductModel loadFromArray:array];
        [self.delegate productManager:self didFetchProductDetails:product];
        
        //VPProductModel *products = [VPProductModel alloc]
    
    }] resume];
}

- (void)fetchProductReviewswithProductId:(NSString*)productId andStoreId:(NSString*)storeId{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-208-24-225.compute-1.amazonaws.com/customapi/index/getReview"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *params = [NSString stringWithFormat:@"productid=%@&storeid=%@",productId, storeId ];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strResponse);
        
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:[strResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        
        NSArray *reviews = [VPReviewsModel loadFromArray:dict];
        [self.delegate productManager:self didFetchProductReviews:reviews];
        
    }] resume];
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
    
}

@end
