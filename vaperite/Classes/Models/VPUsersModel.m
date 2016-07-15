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

@implementation VPUsersModel


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

@end
