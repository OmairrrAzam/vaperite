

#import "VPProductManager.h"
#import "VPSessionManager.h"
#import "VPProductModel.h"
#import "VPMarkerModel.h"

static NSString *kBaseUrl  = @"http://ec2-54-208-24-225.compute-1.amazonaws.com/";
static NSString *kApiKey   = @"techverx";
static NSString *kApiUser  = @"techverx";

@implementation VPProductManager

- (void)fetchProductsWithSessionId:(NSString*)sessionId {
    
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
        [self.delegate productManager:self didFetchProducts:products];

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


@end
