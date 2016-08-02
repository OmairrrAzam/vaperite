

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPSessionManager.h"
#import "VPProductModel.h"
@class VPProductManager;

@protocol VPProductManagerDelegate

@optional

- (void)productManager:(VPProductManager *)manager didFetchFeaturedProducts:(NSArray *)products;
- (void)productManager:(VPProductManager *)manager didFailToFetchFeaturedProducts:(NSString *)message;

- (void)productManager:(VPProductManager *)manager didFetchRecommendedProducts:(NSArray *)products;
- (void)productManager:(VPProductManager *)manager didFailToFetchRecommendedProducts:(NSString *)message;

- (void)productManager:(VPProductManager *)manager didFetchProductDetails:(VPProductModel *)product;
- (void)productManager:(VPProductManager *)manager didFailToFetchProductDetails:(NSString *)message;

- (void)productManager:(VPProductManager *)manager didFetchProductReviews:(NSArray *)reviews;
- (void)productManager:(VPProductManager *)manager didFailToFetchProductReviews:(NSString *)message;

- (void)productManager:(VPProductManager *)manager didFetchProductImage:(NSString *)imgDetails;
- (void)productManager:(VPProductManager *)manager didFailToFetchProductImage:(NSString *)message;

@end

@interface VPProductManager : VPBaseManager

@property (weak, nonatomic) id<VPProductManagerDelegate> delegate;

- (void)fetchFeaturedProductsWithSessionId:(NSString*)sessionId;
- (void)fetchRecommendedProductsWithSessionId:(NSString*)sessionId;
- (void)fetchProductDetailsWithProductId:(NSString*)productId andSessionId:(NSString*)sessionId;
- (void)fetchProductReviewswithProductId:(NSString*)productId andStoreId:(NSString*)storeId;
- (void)fetchProductImageWithProductId:(NSString*)productId andSessionId:(NSString*)sessionId;
@end
