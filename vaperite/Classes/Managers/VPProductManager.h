

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPSessionManager.h"

@class VPProductManager;

@protocol VPProductManagerDelegate

@optional

- (void)productManager:(VPProductManager *)manager didFetchProducts:(NSArray *)products;
- (void)productManager:(VPProductManager *)manager didFailToFetchProducts:(NSString *)message;

@end

@interface VPProductManager : VPBaseManager

@property (weak, nonatomic) id<VPProductManagerDelegate> delegate;

- (void)fetchProducts;

@end
