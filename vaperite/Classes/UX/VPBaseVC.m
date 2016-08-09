//
//  VPBaseVC.m
//  vaperite
//
//  Created by Apple on 24/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseVC.h"
#import <KVNProgress/KVNProgress.h>


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
    
    self.loggedInUser = [VPUsersModel currentUser];
    self.currentStore = [VPMarkerModel currentStore];
    
    if (self.currentStore){
        self.navigationItem.rightBarButtonItem =[self cartButton];
        self.navigationItem.leftBarButtonItem  =[self menuButton];
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // it has to be here so that variable is available and updated
    // on every view controller
    self.loggedInUser = [VPUsersModel currentUser];
    self.currentStore = [VPMarkerModel currentStore];
    
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

-(void)changeViewThroughSlider:(NSString*)viewController{
    //ask ECSlider to Change view
    //so that we could access menu from this new view as well.
    UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:viewController];
    loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginNavigator animated:YES completion:nil];
    
//    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:viewController];
//    [self.slidingViewController resetTopViewAnimated:YES];
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
    configuration.circleStrokeForegroundColor = [UIColor blueColor];
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    configuration.backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
    //configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.4f];
    configuration.successColor = [UIColor whiteColor];
    configuration.errorColor = [UIColor whiteColor];
    configuration.stopColor = [UIColor whiteColor];
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
     [self changeViewThroughSlider:@"RightMenu"];
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
