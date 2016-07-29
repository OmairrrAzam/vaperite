//
//  VPUsersModel.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#define kOauthToken         @"oauth_token"
#define kOauthTokenSecret   @"oauth_token_secret"
#import "VPUsersModel.h"
#import "NSDictionary+Helper.h"

@implementation VPUsersModel

+ (VPUsersModel *)currentUser {
    
    VPUsersModel *user = nil;
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [defaults objectForKey:kUserId];
    //    NSString *apiToken = [defaults objectForKey:kUserApiToken];
    //    if (userId && apiToken) {
    //        user = [[TMUserModel alloc] init];
    //        user.id = userId;
    //        user.email = [defaults objectForKey:kUserEmail];
    //        user.firstName = [defaults objectForKey:kUserFirstName];
    //        user.lastName = [defaults objectForKey:kUserLastName];
    //        user.address = [defaults objectForKey:kUserAddress];
    //        user.city = [defaults objectForKey:kUserCity];
    //        user.state = [defaults objectForKey:kUserState];
    //        user.zipcode = [defaults objectForKey:kUserZipcode];
    //        user.country = [defaults objectForKey:kUserCountry];
    //        user.phoneNumber = [defaults objectForKey:kUserPhone];
    //        user.apiToken = [defaults objectForKey:kUserApiToken];
    //
    //    }
    return user;
}


+ (NSArray *)loadFromArray:(NSArray *)arrUsers {
    
    NSMutableArray *users = [[NSMutableArray alloc] init];
    for (NSDictionary *dictUser in arrUsers) {
        VPUsersModel *user = [[VPUsersModel alloc] initWithDictionary:dictUser];
        [users addObject:user];
    }
    return users;
}


+(void)saveToSession:(NSDictionary*)dict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict[@"oauth_token"] forKey:kOauthToken];
    [defaults setObject:dict[@"oauth_token_secret"] forKey:kOauthTokenSecret];
}

+(NSDictionary*)getTokenFromSession{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *tokenDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                [defaults objectForKey:kOauthToken], kOauthToken,
                                                [defaults objectForKey:kOauthTokenSecret], kOauthTokenSecret,nil];
    
    return tokenDict;
}

- (id)initWithDictionary:(NSDictionary *)dictUser {
    
    self = [super init];
    
    self.firstName   = [dictUser objectForKeyHandlingNull:@"firstname"];
    self.lastName    = [dictUser objectForKeyHandlingNull:@"lastname"];
    self.customer_id = [dictUser objectForKeyHandlingNull:@"customer_id"];
    self.email       = [dictUser objectForKeyHandlingNull:@"email"];
    self.store_id    = [dictUser objectForKeyHandlingNull:@"store_id"];

    return self;
}




@end
