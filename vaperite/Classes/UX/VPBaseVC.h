//
//  VPBaseVC.h
//  vaperite
//
//  Created by Apple on 24/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "VPSessionManager.h"
#import "VPUsersModel.h"
#import "UIViewController+ECSlidingViewController.h"
#import "VPMarkerModel.h"
#import "VPProductModel.h"
#import "VPFavoriteModel.h"

@interface VPBaseVC : UIViewController <ECSlidingViewControllerDelegate,VPSessionManagerDelegate>

- (void)startAnimating;
- (void)stopAnimating;
- (IBAction)menuButtonTapped:(id)sender;
- (void)showError:(NSString*)errorMsg;
- (BOOL)validateEmail:(NSString *)emailAddress;
- (void)beautifyTextFields;
- (BOOL)isStaging;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (strong, nonatomic)  NSString *sessionId;
@property (strong, nonatomic)  NSString *storeId;
@property (strong, nonatomic)  VPUsersModel *loggedInUser;
@property (strong, nonatomic)  VPMarkerModel *currentStore;
@property (strong, nonatomic) VPCartModel *userCart;
@property (strong, nonatomic) VPFavoriteModel *userFav;

- (void) changeViewThroughSlider:(NSString*)viewController;
- (void) dismissMe;
- (void)refreshUser;
- (void) startAnimatingWithSuccessMsg:(NSString*)msg;
- (void) addToFavorites:(VPProductModel*)selectedProduct;
- (int) addToCart:(VPProductModel*)selectedProduct;
- (void) showLoginPage;
- (void) refreshCartAndFav;
- (void) startAnimatingWithErrorMsg:(NSString*)msg;
- (void) startAnimatingWithCustomMsg:(NSString*)message;
- (void) sessionManager:(VPSessionManager *)sessionManager didFetchSession:(NSString*)sessionId;
- (void) showProductStrengthsWithTitle:(NSString*)title andProduct:(VPProductModel*)product andTargetButton:(UIButton*)btn;
-(void)updateNavBadge;
@end
