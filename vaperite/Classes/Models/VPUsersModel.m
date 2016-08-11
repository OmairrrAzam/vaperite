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
#import "VPCartModel.h"



@implementation VPUsersModel

+ (VPUsersModel *)currentUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    
    VPUsersModel *user;
    if (data) {
        user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        
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
    self.state       = [dictUser objectForKeyHandlingNull:@"state"];
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        self.firstName      = [decoder decodeObjectForKey:@"firstName"];
        self.lastName       = [decoder decodeObjectForKey:@"lastName"];
        self.customer_id    = [decoder decodeObjectForKey:@"customer_id"];
        self.store_id       = [decoder decodeObjectForKey:@"store_id"];
        self.city           = [decoder decodeObjectForKey:@"city"];
        self.postalcode     = [decoder decodeObjectForKey:@"postalcode"];
        self.street         = [decoder decodeObjectForKey:@"street"];
        self.state          = [decoder decodeObjectForKey:@"state"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.firstName   forKey:@"firstName"];
    [encoder encodeObject:self.lastName    forKey:@"lastName"];
    [encoder encodeObject:self.customer_id forKey:@"customer_id"];
    [encoder encodeObject:self.store_id    forKey:@"store_id"];
    [encoder encodeObject:self.city        forKey:@"city"];
    [encoder encodeObject:self.postalcode  forKey:@"postalcode"];
    [encoder encodeObject:self.street      forKey:@"street"];
    [encoder encodeObject:self.state       forKey:@"state"];
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:@"user"];
}

@end
