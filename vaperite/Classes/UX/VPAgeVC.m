//
//  VPAgeVC.m
//  vaperite
//
//  Created by Aftab Baig on 15/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPAgeVC.h"
#import "VPBaseUIButton.h"

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
    
}

- (IBAction)btnUnder18_Pressed:(VPBaseUIButton *)btnUnder18 {
    
}

#pragma mark - Memory Cleanup Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
