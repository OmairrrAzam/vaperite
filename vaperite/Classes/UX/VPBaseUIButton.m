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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib {
    //it works
    self.layer.cornerRadius = 12;
    self.clipsToBounds = YES;
    //[btn setTitle:@"My title"];
}
@end
