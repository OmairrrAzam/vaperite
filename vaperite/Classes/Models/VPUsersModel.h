//
//  VPUsersModel.h
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VPCartModel;

@interface VPUsersModel : NSObject 

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *customer_id;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *store_id;
@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *postalcode;
@property (strong, nonatomic) VPCartModel *cart;


+ (VPUsersModel *)currentUser;
+ (NSArray *)loadFromArray:(NSArray *)arrUsers;
- (id)initWithDictionary:(NSDictionary *)dictUser;
-(void)save;

@end



