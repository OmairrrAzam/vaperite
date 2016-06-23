//
//  VPTest1VC.m
//  vaperite
//
//  Created by Apple on 23/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPTest1VC.h"
#import "VPSliderMenuVC.h"
#import "UIViewController+ECSlidingViewController.h"

@interface VPTest1VC ()

@end

@implementation VPTest1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius  = 10.0f;
    self.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
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
