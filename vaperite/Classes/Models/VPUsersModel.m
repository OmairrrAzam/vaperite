//
//  VPUsersModel.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#define kCustomerId  @"vp.user.customer_id"

#import "VPUsersModel.h"
#import "NSDictionary+Helper.h"


@implementation VPUsersModel

+ (VPUsersModel *)currentUser {
    
    VPUsersModel *user = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:kCustomerId];
    
    if (userId ) {
        user = [[VPUsersModel alloc] init];
        user.customer_id             = userId;
    }
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

-(void)save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.customer_id forKey:kCustomerId];
    [defaults synchronize];
}


- (id)initWithDictionary:(NSDictionary *)dictUser {
    
    self = [super init];
   
    
    self.firstName   = [dictUser objectForKeyHandlingNull:@"firstname"];
    self.lastName    = [dictUser objectForKeyHandlingNull:@"lastname"];
    self.customer_id = [dictUser objectForKeyHandlingNull:@"customer_id"];
    self.email       = [dictUser objectForKeyHandlingNull:@"email"];
    self.store_id    = [dictUser objectForKeyHandlingNull:@"store_id"];
    self.city        = [dictUser objectForKeyHandlingNull:@"city"];
    self.postalcode  = [dictUser objectForKeyHandlingNull:@"postcode"];
    self.street      = [dictUser objectForKeyHandlingNull:@"street"];
    return self;
}




@end
