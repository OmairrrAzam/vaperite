//
//  VPProductOptionsModel.h
//  vaperite
//
//  Created by Apple on 17/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPProductOptionsModel : NSObject<NSCoding>

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString* id;
@property (strong,nonatomic) NSDictionary *values;
@property (strong,nonatomic) NSString* pickedId;
@property (strong,nonatomic) NSString* pickedValue;
@property (strong,nonatomic) NSString* type;

@end
