

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPUsersModel.h"

@class VPUserManager;
@class VPUsersModel;
@class VPReviewsModel;
@class VPUsersModel;
@protocol VPUserManagerDelegate

@optional

- (void)userManager:(VPUserManager *)userManager didAuthenticateWithUser:(VPUsersModel *)user;
- (void)userManager:(VPUserManager *)userManager didFailToAuthenticateWithMessage:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didGetCart:(NSArray *)cartProducts;
- (void)userManager:(VPUserManager *)userManager didFailToGetCart:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didCreateUser:(VPUsersModel *)user;
- (void)userManager:(VPUserManager *)userManager didFailToCreateUser:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didGetCustomerInfo:(VPUsersModel *)user;
- (void)userManager:(VPUserManager *)userManager didFailToGetCustomerInfo:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didAddReview:(VPReviewsModel *)review;
- (void)userManager:(VPUserManager *)userManager didFailToAddReview:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didFetchAddress:(VPUsersModel *)review;
- (void)userManager:(VPUserManager *)userManager didFailToFetchAddress:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didUpdateAddress:(VPUsersModel *)response;
- (void)userManager:(VPUserManager *)userManager didFailToUpdateAddress:(NSString *)message;

- (void)userManager:(VPUserManager *)userManager didUpdatePassword:(NSString *)response;
- (void)userManager:(VPUserManager *)userManager didFailToUpdatePassword:(NSString *)message;

@end

@interface VPUserManager : VPBaseManager

@property (weak, nonatomic) id<VPUserManagerDelegate> delegate;

- (void) authenticateWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken;

- (void) getCartFromSession:(NSString*)sessionid andCartid:(NSString*)cartId;

- (void) createUserFromStoreId:(NSString*)storeId password:(NSString*)password user:(VPUsersModel*)u;

- (void) getCustomerInfoFromCustomerId:(NSString*)customerId andSession:(NSString*)sessionId;

- (void) addReviewFromSession:(NSString*)sessionId storeId:(NSString*)storeId productId:(NSString*)productId customerId:(NSString*)customerId title:(NSString*)title detail:(NSString*)detail nickName:(NSString*)nickName;

- (void) fetchAddressFromCustomerId:(NSString*)cutomerId;

- (void) updateAddressWithCustomerID:(NSString*)customerId firstName:(NSString*)fn  lastName:(NSString*)ln streetAddress:(NSString*)street city:(NSString*)city postalCode:(NSString*)postal;

- (void) updatePasswordWithCustomerID:(NSString*)customerId firstName:(NSString*)fn  lastName:(NSString*)ln email:(NSString*)email password:(NSString*)password;
@end
