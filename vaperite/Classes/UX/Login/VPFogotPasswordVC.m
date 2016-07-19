//
//  VPFogotPasswordVC.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPFogotPasswordVC.h"

@interface VPFogotPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
- (IBAction)btnCancel:(id)sender;

@end

@implementation VPFogotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - IBActions

- (IBAction)btnForgot:(UIButton *)sender {
}
- (IBAction)btnCancel:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
