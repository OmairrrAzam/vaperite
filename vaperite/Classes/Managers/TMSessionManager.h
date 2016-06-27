//
//  TMSessionManager.h
//  Vaperite
//
//
//  Copyright (c) 2015 Techverx. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface TMSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
