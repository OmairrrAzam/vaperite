

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPUsersModel.h"

@class VPUserManager;
@class VPUsersModel;
@protocol VPUserManagerDelegate

@optional

- (void)userManager:(VPUserManager *)userManager didAuthenticateWithUser:(VPUsersModel *)user;
- (void)userManager:(VPUserManager *)userManager didFailToAuthenticateWithMessage:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didGetCart:(NSArray *)cartProducts;
- (void)userManager:(VPUserManager *)userManager didFailToGetCart:(NSString *)message;

@end

@interface VPUserManager : VPBaseManager

@property (weak, nonatomic) id<VPUserManagerDelegate> delegate;

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken;
- (void)getCartFromSession:(NSString*)sessionid andCartid:(NSString*)cartId;

@end
