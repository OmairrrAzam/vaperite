

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPUsersModel.h"

@class VPUserManager;

@protocol VPUserManagerDelegate

@optional

- (void)userManager:(VPUserManager *)userManager didAuthenticate:(NSDictionary *)response ;
- (void)userManager:(VPUserManager *)userManager didFailToAuthenticate:(NSString *)message;



@end

@interface VPUserManager : VPBaseManager

@property (weak, nonatomic) id<VPUserManagerDelegate> delegate;

- (void)authenticate;


@end
