//
//  VPFogotPasswordVC.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPFogotPasswordVC.h"
#import "VPUserManager.h"

@interface VPFogotPasswordVC ()<VPUserManagerDelegate>

@property (strong, nonatomic)  VPUserManager *userManager;

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

#pragma mark - Private Methods

- (VPUsersModel *)validate {
    
    NSString *email = [self.tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (email.length == 0) {
        [self showError:@"Email is required."];
        return nil;
    }
    
    if (![super validateEmail:email]) {
        [self showError:@"Invalid email."];
        return nil;
    }
    
    
    VPUsersModel *user = [[VPUsersModel alloc] init];
    user.email         = email;
    return user;
}


#pragma mark - IBActions

- (IBAction)btnForgot:(UIButton *)sender {
    VPUsersModel *user = [self validate];
    [self startAnimating];
    if (user) {
        if (!self.userManager) {
            self.userManager = [[VPUserManager alloc]init];
            self.userManager.delegate = self;
        }
        [self.userManager forgotPassword:user.email];
    }
    
}
- (IBAction)btnCancel:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - VPUserManagerDelegates


- (void)userManager:(VPUserManager *)userManager didForgotPassword:(NSString *)response{
    [self startAnimatingWithSuccessMsg:@"You will recieve email with instrutions to reset your password"];
    [self dismissMe];
}

- (void)userManager:(VPUserManager *)userManager didFailToForgotPassword:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
}


@end
