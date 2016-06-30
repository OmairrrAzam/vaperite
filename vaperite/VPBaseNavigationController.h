//
//  VPBaseNavigationController.h
//  vaperite
//
//  Created by Apple on 29/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface VPBaseNavigationController : UINavigationController<ECSlidingViewControllerDelegate>
- (IBAction)menuButtonTapped:(id)sender;
@end
