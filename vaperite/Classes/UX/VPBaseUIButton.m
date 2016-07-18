//
//  VPBaseUIButton.m
//  vaperite
//
//  Created by Apple on 23/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseUIButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation VPBaseUIButton

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
}
@end
