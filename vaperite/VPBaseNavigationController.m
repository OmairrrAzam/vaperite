//
//  VPBaseNavigationController.m
//  vaperite
//
//  Created by Apple on 29/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseNavigationController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"

@interface VPBaseNavigationController ()

@end

@implementation VPBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationBar.barTintColor = [UIColor colorWithRed:235 green:105 blue:37 alpha:1];
    // Do any additional setup after loading the view.
}

-(void)awakeFromNib {
    //it works
    
    /*[self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setBarTintColor:[UIColor colorWithRed:275/255.0 green:85/255.0 blue:20/255.0 alpha:0.7]];
    [newNavBar setTintColor:[UIColor whiteColor]];
    [newNavBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UINavigationItem *newItem = [[UINavigationItem alloc] init];
    newItem.title = @"Paths";

    
    UIImage *menuBarButtonImage = [[UIImage imageNamed:@"add-to-cart-icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    
    
    
    // BackButtonBlack is an image we created and added to the app’s asset catalog
    //UIImage *menuButtonImage = [UIImage imageNamed:@"add-to-cart-icon"];
    
    // any buttons in a navigation bar are UIBarButtonItems, not just regular UIButtons. backTapped: is the method we’ll call when this button is tapped
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
     [[UIBarButtonItem appearance] setBackButtonBackgroundImage:menuBarButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // the bar button item is actually set on the navigation item, not the navigation bar itself.
    newItem.leftBarButtonItem = menuBarButtonItem;
    
   // newItem.rightBarButtonItem = menuBarButtonItem;
    [newNavBar setItems:@[newItem]];
    [self.view addSubview:newNavBar];
   */
    self.navigationBar.barTintColor = [UIColor colorWithRed:275/255.0 green:85/255.0 blue:20/255.0 alpha:1];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
   // UIBarButtonItem* button1 = [[UIBarButtonItem alloc] initWithTitle:@"Button Text" style:UIBarButtonItemStyleBordered target:self action:@selector(myAction)] ;
    
}
- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (void)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
