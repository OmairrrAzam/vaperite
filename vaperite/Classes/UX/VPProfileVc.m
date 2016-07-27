//
//  VPDashboardVc.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProfileVc.h"

@interface VPProfileVc()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdatePassword;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateAddress;


- (IBAction)btnUpdateAddress:(id)sender;
- (IBAction)btnUpdatePassword:(id)sender;

@end

@implementation VPProfileVc

- (void)viewDidLoad {
    [super viewDidLoad];
    //initializing first view in container view
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"updateAddress"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.btnUpdateAddress.frame.size.height , self.btnUpdateAddress.frame.size.width, 2)];
    UIView *bottomBorder2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.btnUpdateAddress.frame.size.height , self.btnUpdateAddress.frame.size.width, 2)];
    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, self.btnUpdateAddress.frame.size.height)];

    UIColor *borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    bottomBorder.backgroundColor  = borderColor;
    bottomBorder2.backgroundColor = borderColor;
    leftBorder.backgroundColor    = borderColor;
    
    [self.btnUpdateAddress addSubview:bottomBorder];
    [self.btnUpdateAddress addSubview:leftBorder];
    [self.btnUpdatePassword addSubview:bottomBorder2];
    
    [self updateTabButtons:self.btnUpdatePassword];
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



- (void)addSubview:(UIView *)subView toView:(UIView*)parentView{
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

- (void)changeContainerView:(NSString*)viewIdentifier{
    UITableViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:viewIdentifier];
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
}

- (void)refreshTabButtonsBackground{
    [self.btnUpdatePassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btnUpdateAddress setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void) updateTabButtons:(UIButton*)activeBtn {
    [self refreshTabButtonsBackground];
    //activeBtn.backgroundColor = [UIColor colorWithRed:275/255.0 green:85/255.0 blue:20/255.0 alpha:1];
    [activeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


#pragma mark - Memory Cleanup Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)btnUpdateAddress:(id)sender {
    [self updateTabButtons:self.btnUpdateAddress];
    [self changeContainerView:@"updateAddress"];
}

- (IBAction)btnUpdatePassword:(id)sender {
     [self updateTabButtons:self.btnUpdatePassword];
    [self changeContainerView:@"updatePassword"];
}

@end
