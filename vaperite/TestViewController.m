//
//  TestViewController.m
//  vaperite
//
//  Created by Apple on 01/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "TestViewController.h"


@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBtns;
@property (weak, nonatomic) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *eighteenPlusView;
@end

@implementation TestViewController
BOOL over18 = FALSE;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //showing eighteen+ view over all other view ..... can't be set from storyboard
    //self.eighteenPlusView.layer.zPosition = 100;
    
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.segmentBtns
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:46];
    [self.segmentBtns addConstraint:constraint];
    [[UISegmentedControl appearance] setBackgroundColor:[UIColor colorWithRed:98/255.0 green:99/255.0 blue:100/255.0 alpha:1]];
   
    
    self.segmentBtns.tintColor = [UIColor  colorWithRed:210/255.0 green:190/255.0 blue:29/255.0 alpha:1];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [self.segmentBtns setTitleTextAttributes:attributes forState:UIControlStateNormal];
     NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.segmentBtns setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
   
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if(over18){
        self.eighteenPlusView.hidden = YES;
        [self loadMapTableContainer];
        //[self startAnimating];
    }else{
        self.navigationController.navigationBar.layer.zPosition = -1;
        [self stopAnimating];
    }
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)showComponent:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        UITableViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"A"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    } else {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Map"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
    }
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    [newViewController.view layoutIfNeeded];
    
    // set starting state of the transition
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}

#pragma mark - IBAction methods

- (IBAction)btnOver18:(id)sender {
    [self.eighteenPlusView removeFromSuperview];
    over18 = TRUE;
    self.navigationController.navigationBar.layer.zPosition = 1;
    [self loadMapTableContainer];
    
}
- (IBAction)btnUnder18:(id)sender {
    exit(0);
}
#pragma mark - private methods

- (void)loadMapTableContainer{
    //Container Views Switching
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"A"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
}

@end
