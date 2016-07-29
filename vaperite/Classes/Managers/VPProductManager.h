

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPSessionManager.h"
#import "VPProductModel.h"
@class VPProductManager;

@protocol VPProductManagerDelegate

@optional

- (void)productManager:(VPProductManager *)manager didFetchProducts:(NSArray *)products;
- (void)productManager:(VPProductManager *)manager didFailToFetchProducts:(NSString *)message;

- (void)productManager:(VPProductManager *)manager didFetchProductDetails:(VPProductModel *)product;
- (void)productManager:(VPProductManager *)manager didFailToFetchProductDetails:(NSString *)message;

@end

@interface VPProductManager : VPBaseManager

@property (weak, nonatomic) id<VPProductManagerDelegate> delegate;

- (void)fetchProductsWithSessionId:(NSString*)sessionId;
- (void)fetchProductDetailsWithProductId:(NSString*)productId andSessionId:(NSString*)sessionId;

@end
