//
//  VPDashboardVc.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPDashboardVc.h"
#import "QuartzCore/QuartzCore.h"

#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "VPTabsUISegmentedControl.h"
#import "VPUserManager.h"
#import "VPUsersModel.h"
#import "VPDashboardProductsVC.h"

#import "VPBaseUIButton.h"

#define ORANGE_COLOR        [UIColor colorWithRed:0.921 green:0.411 blue:0.145 alpha:1.0]

@interface VPDashboardVc ()< VPUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnFeatured;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnRecommended;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnAward;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) VPUserManager *userManager;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;


- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin;
- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister;
- (IBAction)btnFeatured_Pressed:(VPBaseUIButton *)btnFeatured;
- (IBAction)btnRecommended_Pressed:(VPBaseUIButton *)btnRecommended;
- (IBAction)btnAward_Pressed:(VPBaseUIButton *)btnAward;


@end

@implementation VPDashboardVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self highlightButton:self.btnFeatured];
    [self unhighlithButton:self.btnRecommended];
    [self unhighlithButton:self.btnAward];
    
    self.btnFeatured.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnRecommended.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnAward.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.btnFeatured.layer.borderWidth = 0.5;
    self.btnRecommended.layer.borderWidth = 0.5;
    self.btnAward.layer.borderWidth = 0.5;
    
    //initializing first view in container view
    VPDashboardProductsVC *defaultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DASHBOARD_PRODUCTS"];
    defaultVC.productType = @"featured";
    self.currentViewController = defaultVC;
    
    //self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    
    
//    if (!self.userManager) {
//        self.userManager = [[VPUserManager alloc]init];
//        self.userManager.delegate = self;
//    }
//    [self.userManager authenticateWithEmail:@"qubaish@gems.techverx.com" password:@"helloworld81" pushToken:@""];
    
}

#pragma mark - Private Methods 

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    // TODO: Set the starting state of your constraints here
    [newViewController.view layoutIfNeeded];
    
    // TODO: Set the ending state of your constraints here
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         // only need to call layoutIfNeeded here
                         [newViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}


- (void)highlightButton:(VPBaseUIButton *)button {

    button.backgroundColor = ORANGE_COLOR;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)unhighlithButton:(VPBaseUIButton *)button {
    
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:ORANGE_COLOR forState:UIControlStateNormal];
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

#pragma mark - IBActions

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin {
    
    UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_NAVIGATOR"];
    loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginNavigator animated:YES completion:nil];
}

- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister {
    
    UINavigationController *registerNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"REGISTER_NAVIGATOR"];
    registerNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerNavigator animated:YES completion:nil];
}

- (IBAction)btnFeatured_Pressed:(VPBaseUIButton *)btnFeatured {
    
    [self highlightButton:btnFeatured];
    [self unhighlithButton:self.btnRecommended];
    [self unhighlithButton:self.btnAward];
    
    VPDashboardProductsVC *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DASHBOARD_PRODUCTS"];
    newViewController.productType = @"featured";
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}

- (IBAction)btnRecommended_Pressed:(VPBaseUIButton *)btnRecommended {
    
    [self highlightButton:btnRecommended];
    [self unhighlithButton:self.btnFeatured];
    [self unhighlithButton:self.btnAward];
    
    VPDashboardProductsVC *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DASHBOARD_PRODUCTS"];
    newViewController.productType = @"recommended";
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}

- (IBAction)btnAward_Pressed:(VPBaseUIButton *)btnAward {
    
    [self highlightButton:btnAward];
    [self unhighlithButton:self.btnFeatured];
    [self unhighlithButton:self.btnRecommended];
    
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DASHBOARD_AWARDS"];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
    
}
#pragma mark - VPUserManagerDelegate Methods

- (void)userManager:(VPUserManager *)userManager didAuthenticate:(NSDictionary *)response {
    [VPUsersModel saveToSession:response];
}

- (void)userManager:(VPUserManager *)userManager didFailToAuthenticate:(NSString *)message{
    
}

#pragma mark - Memory Cleanup Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
