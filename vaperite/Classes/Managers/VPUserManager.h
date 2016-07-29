

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPUsersModel.h"

@class VPUserManager;
@class VPUsersModel;
@protocol VPUserManagerDelegate

@optional

- (void)userManager:(VPUserManager *)userManager didAuthenticateWithUser:(VPUsersModel *)user;
- (void)userManager:(VPUserManager *)userManager didFailToAuthenticateWithMessage:(NSString *)message;

@end

@interface VPUserManager : VPBaseManager

@property (weak, nonatomic) id<VPUserManagerDelegate> delegate;

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password pushToken:(NSString *)pushToken;


@end
