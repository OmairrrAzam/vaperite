//
//  VPUsersModel.h
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPUsersModel : NSObject

@property (strong, nonatomic) NSString *token;
+(void)saveToSession:(NSDictionary*)dict;
+(NSDictionary*)getTokenFromSession;
@end
