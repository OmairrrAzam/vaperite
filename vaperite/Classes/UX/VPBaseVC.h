//
//  VPBaseVC.h
//  vaperite
//
//  Created by Apple on 24/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface VPBaseVC : UIViewController <ECSlidingViewControllerDelegate>
- (void)startAnimating;
- (void)stopAnimating;
- (IBAction)menuButtonTapped:(id)sender;
- (void)showError:(NSString*)errorMsg;
@end
