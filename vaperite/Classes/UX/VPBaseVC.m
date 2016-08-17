//
//  VPBaseVC.m
//  vaperite
//
//  Created by Apple on 24/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseVC.h"
#import <KVNProgress/KVNProgress.h>
#import "VPProductModel.h"
#import "VPFavoriteModel.h"
#import "VPCartModel.h"
#import "UIBarButtonItem+Badge.h"

#define kSessionid   @"vaperite.session_id"
#define kStoreid     @"vaperite.store_id"

@interface VPBaseVC () 
@property (nonatomic) KVNProgressConfiguration *basicConfiguration;
@property (nonatomic) KVNProgressConfiguration *customConfiguration;
@property (strong, nonatomic) VPSessionManager *sessionManager;

@end



@implementation VPBaseVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];

    self.customConfiguration = [self customKVNProgressUIConfiguration];
    [KVNProgress setConfiguration:self.customConfiguration];
    
    [self refreshUser];
    self.currentStore = [VPMarkerModel currentStore];
    
    if (self.currentStore){
        self.navigationItem.rightBarButtonItem =[self cartButton];
        self.navigationItem.leftBarButtonItem  =[self menuButton];
        [self updateNavBadge];
        
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // it has to be here so that variable is available and updated
    // on every view controller
    [self refreshUser];
    self.currentStore = [VPMarkerModel currentStore];
    [self updateNavBadge];
   // [self startAnimating];
}

#pragma mark - Helpers

- (void)updateProgress
{
    dispatch_main_after(2.0f, ^{
        [KVNProgress updateProgress:0.3f
                           animated:YES];
    });
    dispatch_main_after(2.5f, ^{
        [KVNProgress updateProgress:0.5f
                           animated:YES];
    });
    dispatch_main_after(2.8f, ^{
        [KVNProgress updateProgress:0.6f
                           animated:YES];
    });
    dispatch_main_after(3.7f, ^{
        [KVNProgress updateProgress:0.93f
                           animated:YES];
    });
    dispatch_main_after(5.0f, ^{
        [KVNProgress updateProgress:1.0f
                           animated:YES];
    });
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}


#pragma mark - Private Methods

- (void)showProductStrengthsWithTitle:(NSString*)title andProduct:(VPProductModel*)product andTargetButton:(UIButton*)btn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *key in product.doses) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:[product.doses objectForKey:key]
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                                //self.selectedDose = key;
                                                                product.cartStrength = [key intValue];
                                                                product.cartStrengthValue = [product.doses objectForKey:key];
                                                                if (btn) {
                                                                    [btn  setTitle:[product.doses objectForKey:key] forState:UIControlStateNormal];
                                                                }
                                                                
                                                              
                                                                
                                                            }]];
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                                            //[self startAnimating];
                                                            
                                                            
                                                        }]];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });

}

- (void)refreshCartAndFav{
    self.userCart = [VPCartModel currentCart];
    self.userFav  = [VPFavoriteModel currentFav];
}

- (void)refreshUser{
    self.loggedInUser = [VPUsersModel currentUser];
}

-(void)updateNavBadge{
    [self refreshCartAndFav];
    NSString *badgeValue = [NSString stringWithFormat:@"%d", (int)[self.userCart.products count]];
    self.navigationItem.rightBarButtonItem.badgeValue = badgeValue;
}

-(void)changeViewThroughSlider:(NSString*)viewController{

    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:viewController];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(void)changeViewWithoutSlider:(NSString*)viewController{
    
    UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:viewController];
    loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginNavigator animated:YES completion:nil];
    
}

- (void) addToFavorites:(VPProductModel*)selectedProduct{
    if(self.loggedInUser){
        BOOL productPresentInFav = [self.userFav productPresentInFav:selectedProduct];
        
        if(productPresentInFav){
            NSMutableArray *favProducts = self.userFav.products;
            
            int count = 0;
            int foundIndex = -1;
            for (VPProductModel* favProduct in favProducts) {
                if ([favProduct.id isEqualToString:favProduct.id]) {
                    foundIndex = count;
                }
                count++;
            }
            
            if ([self.userFav productPresentInFav:selectedProduct]) {
                [favProducts removeObjectAtIndex:foundIndex];
                self.userFav.products = favProducts;
                [self.userFav save];
                [self startAnimatingWithSuccessMsg:@"Item Removed from Favorites"];
                
            }else{
                [self startAnimatingWithErrorMsg:@"Item Not Removed from Favorites"];
            }
            
            
        }else{
            
            [self.userFav.products addObject:selectedProduct];
            
            [self.userFav save];
            
            [self startAnimatingWithSuccessMsg:@"Added To Favorites"];
        }
        //userCart.products =
        [self refreshCartAndFav];
        
        
        
    }else{
        [self showLoginPage];
    }

}

- (void) addToCart:(VPProductModel*)selectedProduct{
    if(self.loggedInUser){
        if ([selectedProduct.stockQty intValue] <= 0) {
            [self startAnimatingWithErrorMsg:@"Product out of stock"];
            return;
        }
        
        
        if([self.userCart productPresentInCart:selectedProduct]){
            if ([self.userCart updateProductInCart:selectedProduct]){
                [self startAnimatingWithSuccessMsg:@"Cart Updated"];
            }else{
                [self startAnimatingWithErrorMsg:@"Cart Not Updated"];
            }
        }else{
            
            if (selectedProduct.doses && !selectedProduct.cartStrength) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Strength Options" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                
                for (NSString *key in selectedProduct.doses) {
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:[selectedProduct.doses objectForKey:key]
                                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                                            //self.selectedDose = key;
                                                                            selectedProduct.cartStrength = [key intValue];
                                                                            selectedProduct.cartStrengthValue = [selectedProduct.doses objectForKey:key];
                                                                            
                                                                            if ([self.userCart addProductInCart:selectedProduct]) {
                                                                                [self updateNavBadge];
                                                                                [self startAnimatingWithSuccessMsg:@"Added To Cart"];
                                                                                [self refreshCartAndFav];
                                                                            }else{
                                                                                [self startAnimatingWithSuccessMsg:@"Not Added To Cart"];
                                                                            }
                                                                            
                                                                            
                                                                            
                                                                        }]];
                    
                }
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                                                        //[self startAnimating];
                                                                        
                                                                        
                                                                    }]];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }else{
            
                if ([self.userCart addProductInCart:selectedProduct]) {
                    [self updateNavBadge];
                    [self startAnimatingWithSuccessMsg:@"Added To Cart"];
                }else{
                    [self startAnimatingWithSuccessMsg:@"Not Added To Cart"];
                }
            }
            
        }
        
    }else{
        [self showLoginPage];
    }

}

- (void) showLoginPage{
    UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_NAVIGATOR"];
    loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginNavigator animated:YES completion:nil];
}

- (void)dismissMe {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (KVNProgressConfiguration *)customKVNProgressUIConfiguration
{
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    // See the documentation of KVNProgressConfiguration
    configuration.statusColor = [UIColor blackColor];
    //configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    configuration.circleStrokeForegroundColor = [UIColor orangeColor];
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    configuration.backgroundFillColor = [UIColor colorWithRed:1.0f green:0.8f blue:0.4f alpha:0.5f];
    //configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.4f];
    configuration.successColor = [UIColor orangeColor];
    configuration.errorColor = [UIColor orangeColor];
    configuration.stopColor = [UIColor orangeColor];
    configuration.circleSize = 110.0f;
    configuration.lineWidth = 1.0f;
    configuration.showStop = YES;
    configuration.stopRelativeHeight = 0.3f;
    
    configuration.tapBlock = ^(KVNProgress *progressView) {
        [KVNProgress dismiss];
    };
    
    return configuration;
}

- (void)startAnimatingWithSuccessMsg:(NSString*)msg {
    
    [KVNProgress showSuccessWithStatus:msg];
}

- (void)startAnimatingWithErrorMsg:(NSString*)msg {
    [KVNProgress showErrorWithStatus:msg];
}

- (void)startAnimating {
    
      [KVNProgress showWithStatus:@"Loading..."];
}

- (void)startAnimatingWithCustomMsg:(NSString*)message {
    [KVNProgress showWithStatus:message];
}

- (void)stopAnimating{
    
    [KVNProgress dismiss];
}

- (void)showError:(NSString*)errorMsg{
    [KVNProgress showErrorWithStatus:errorMsg];
}

- (BOOL)validateEmail:(NSString *)emailAddress {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

- (void)beautifyTextFields {
    
    for (UITextField *textField in self.textFields) {
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.bounds.size.width, 0.5);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        [textField.layer addSublayer:bottomBorder];
    }
}

- (BOOL)isStaging {
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"STAGING"] boolValue];
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    if ([self.slidingViewController currentTopViewPosition] == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

- (IBAction)cartButtonTapped:(id)sender {
     [self changeViewWithoutSlider:@"RightMenu"];
//    [self.slidingViewController anchorTopViewToRightAnimated:YES];
//    if ([self.slidingViewController currentTopViewPosition] == ECSlidingViewControllerTopViewPositionAnchoredRight) {
//        [self.slidingViewController resetTopViewAnimated:YES];
//    }
}


- (UIBarButtonItem *)cartButton
{
    UIImage *image = [UIImage imageNamed:@"add-to-cart-icon.png"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(cartButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    return item;
}

- (UIBarButtonItem *)menuButton
{
    UIImage *image = [UIImage imageNamed:@"menu-icon.png"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

#pragma mark - SessionManagerDelegate Methods

- (void)sessionManager:(VPSessionManager *)sessionManager didFetchSession:(NSString*)sessionId{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionId forKey:kSessionid];
    
}
- (void)sessionManager:(VPSessionManager *)sessionManager failToFetchSessionWithMessage:(NSString*)message{
    
}


#pragma mark - Memory Cleanup Methods 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
