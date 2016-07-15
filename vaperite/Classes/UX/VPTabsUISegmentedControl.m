//
//  VPTabsUISegmentedControl.m
//  vaperite
//
//  Created by Apple on 13/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPTabsUISegmentedControl.h"

@implementation VPTabsUISegmentedControl

- (id)initWithItems:(NSArray *)items {
    self = [super initWithItems:items];
    if (self) {
        // Initialization code
        
        // Set background images
        UIImage *normalBackgroundImage = [UIImage imageNamed:@"small-white-button.png"];
        [self setBackgroundImage:normalBackgroundImage
                        forState:UIControlStateNormal
                      barMetrics:UIBarMetricsDefault];
        UIImage *selectedBackgroundImage = [UIImage imageNamed:@"small-orange-button.png"];
        [self setBackgroundImage:selectedBackgroundImage
                        forState:UIControlStateSelected
                      barMetrics:UIBarMetricsDefault];
        
        // Set divider images
        [self setDividerImage:[UIImage imageNamed:@"tab-no-selected.png"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"tab-left-selected.png"]
          forLeftSegmentState:UIControlStateSelected
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage imageNamed:@"tab-right-selected.png"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateSelected
                   barMetrics:UIBarMetricsDefault];
        
        [self setContentPositionAdjustment:UIOffsetMake(34 / 2, 0)
                            forSegmentType:UISegmentedControlSegmentLeft
                                barMetrics:UIBarMetricsDefault];
        [self setContentPositionAdjustment:UIOffsetMake(- 34 / 2, 0)
                            forSegmentType:UISegmentedControlSegmentRight
                                barMetrics:UIBarMetricsDefault];
       
    }
    return self;
}

@end
