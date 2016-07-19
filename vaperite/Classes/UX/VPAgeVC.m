//
//  VPAgeVC.m
//  vaperite
//
//  Created by Aftab Baig on 15/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPAgeVC.h"
#import "VPBaseUIButton.h"

#define kUserOver18  @"vaperite.user.over18"

@interface VPAgeVC ()

@property (weak, nonatomic) IBOutlet UIView *whiteFrame;

- (IBAction)btnOver18_Pressed:(VPBaseUIButton *)btnOver18;
- (IBAction)btnUnder18_Pressed:(VPBaseUIButton *)btnUnder18;

@end

@implementation VPAgeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.whiteFrame.layer.cornerRadius = 5.0;
}

#pragma mark - IBActions

- (IBAction)btnOver18_Pressed:(VPBaseUIButton *)btnOver18 {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kUserOver18];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnUnder18_Pressed:(VPBaseUIButton *)btnUnder18 {
    exit(0);
}

#pragma mark - Memory Cleanup Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
