//
//  VPMenuTableViewCell.m
//  vaperite
//
//  Created by Apple on 05/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPMenuTableViewCell.h"
#import "NSDictionary+Helper.h"

@implementation VPMenuTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 
    // Drawing code
}
*/


- (void)configure
{
    // ignore the style argument, use our own to override
    
        // If you need any further customization
        if ([[self.menuItem objectForKey:@"isExpandable"]boolValue]){
            if ([[self.menuItem objectForKey:@"isExpanded"]boolValue]) {
                self.ivDropDown.image = [UIImage imageNamed:@"menu-down-arrow"];
                self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
            }else{
                self.ivDropDown.image = [UIImage imageNamed:@"menu-left-arrow"];
                self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }else{
            self.ivDropDown.image = [UIImage imageNamed:@"uk"];
            self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            if ([[self.menuItem objectForKey:@"isChild"]boolValue]){
                self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
            }
        }
        self.ivIcon.image = [UIImage imageNamed:[self.menuItem objectForKey:@"ivIcon"]];
        self.lblTitle.text = [self.menuItem objectForKey:@"value"];
    self.id = [self.menuItem objectForKeyHandlingNull:@"id"];
        [self setBackgroundColor:[UIColor clearColor]];
}

@end
