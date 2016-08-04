

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPSessionManager.h"
#import "VPProductModel.h"
@class VPProductManager;

@protocol VPProductManagerDelegate

@optional

- (void)productManager:(VPProductManager *)manager didFetchALLProducts:(NSArray *)products;
- (void)productManager:(VPProductManager *)manager didFailToFetchALLProducts:(NSString *)message;

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

- (void)productManager:(VPProductManager *)manager didFetchProductRating:(NSString *)rating;
- (void)productManager:(VPProductManager *)manager didFailToFetchProductRating:(NSString *)message;

- (void)productManager:(VPProductManager *)manager didAddRating:(NSString *)rating;
- (void)productManager:(VPProductManager *)manager didFailToAddRating:(NSString *)message;

- (void)productManager:(VPProductManager *)manager didFetchProductsFromCategoryId:(NSArray *)products;
- (void)productManager:(VPProductManager *)manager didFailToFetchProductsFromCategoryId:(NSString *)message;


@end

@interface VPProductManager : VPBaseManager

@property (weak, nonatomic) id<VPProductManagerDelegate> delegate;

- (void)fetchFeaturedProductsWithSessionId:(NSString*)sessionId;
- (void)fetchRecommendedProductsWithSessionId:(NSString*)sessionId;
- (void)fetchProductDetailsWithProductId:(NSString*)productId andStoreId:(NSString*)storeId;
- (void)fetchProductReviewswithProductId:(NSString*)productId andStoreId:(NSString*)storeId;
- (void)fetchProductImageWithProductId:(NSString*)productId andSessionId:(NSString*)sessionId;
- (void) addProductRatingFromSession:(NSString*)sessionId rating:(NSString*)rating reviewId:(NSString*)reviewId productId:(NSString*)productId;
- (void) fetchProductRatingFromSession:(NSString*)sessionId storeId:(NSString*)storeId andProductId:(NSString*)productId;
- (void) fetchProductsFromCategoryId:(NSString*)categoryId;
@end
