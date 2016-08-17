//
//  VPLoginVC.m
//  vaperite
//
//  Created by Apple on 24/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPLoginVC.h"
#import "VPBaseUIButton.h"
#import "VPBaseTextField.h"
#import "AFNetworkReachabilityManager.h"
#import "NXOAuth2.h"
#import "VPRegisterVC.h"
#import "UIViewController+ECSlidingViewController.h"
#import "VPUserManager.h"

@interface VPLoginVC ()<VPUserManagerDelegate>

@property (weak, nonatomic) IBOutlet VPBaseTextField *tfUsername;
@property (weak, nonatomic) IBOutlet VPBaseTextField *tfPassword;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnRegister;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnForgot;
@property (strong, nonatomic) VPUserManager *userManager;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin;
- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister;
- (IBAction)btnForgot_Pressed:(VPBaseUIButton *)btnForgot;
- (IBAction)btnCancel:(id)sender;

@end

@implementation VPLoginVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self beautifyTextFields];
    
    self.btnRegister.layer.borderColor = [UIColor grayColor].CGColor;
    self.btnForgot.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.btnRegister.layer.borderWidth = 1.0;
    self.btnForgot.layer.borderWidth = 1.0;
}


#pragma mark - Private Methods

- (void)mapToLoggedInUser:(VPUsersModel*)user{
    self.loggedInUser.street      = user.street;
    self.loggedInUser.city        = user.city;
    self.loggedInUser.state       = user.state;
    self.loggedInUser.postalcode  = user.postalcode;
    self.loggedInUser.region      = user.region;
}

- (BOOL)validate {
    
    self.username = [self.tfUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = self.tfPassword.text;
    
    if (self.username.length == 0) {
        [self showError:@"Username is required."];
        return NO;
    }
    
    if (![self validateEmail:self.username]) {
        [self showError:@"Invalid email."];
        return NO;
    }
    
    if (self.password.length == 0) {
        [self showError:@"Password is required."];
        return NO;
    }
    
    return YES;
}

#pragma mark - IBActions

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin {
    
    if ([self validate]) {
        if (!self.userManager) {
            self.userManager = [[VPUserManager alloc]init];
            self.userManager.delegate = self;
        }
        [self startAnimating];
        [self.userManager authenticateWithEmail:self.username password:self.password pushToken:@""];
    }
}

- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    VPRegisterVC *registerVC =
    [storyboard instantiateViewControllerWithIdentifier:@"REGISTER"];
    
    [self presentViewController:registerVC
                       animated:YES
                     completion:nil];

}

- (IBAction)btnForgot_Pressed:(VPBaseUIButton *)btnForgot {
    
}

- (IBAction)btnCancel:(id)sender {
//    for (UIViewController *controller in [self.navigationController viewControllers])
//    {
//            [self.navigationController popToViewController:controller animated:YES];
//    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UserManagerDelegate Method

- (void)userManager:(VPUserManager *)userManager didAuthenticateWithUser:(VPUsersModel *)user{
    self.loggedInUser = user;
    
    [self mapToLoggedInUser:user];
    [self.loggedInUser save];
    [self refreshUser];
    
    if(self.loggedInUser){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self startAnimatingWithSuccessMsg:@"Logged In Successfully"];
    }
    
    [self.userManager fetchAddressFromCustomerId:self.loggedInUser.customer_id];
    
}

- (void)userManager:(VPUserManager *)userManager didFailToAuthenticateWithMessage:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
}


- (void)userManager:(VPUserManager *)userManager didFetchAddress:(VPUsersModel *)user{
    
}

- (void)userManager:(VPUserManager *)userManager didFailToFetchAddress:(NSString *)message{
    [self stopAnimating];
    //[self startAnimatingWithErrorMsg:message];
    
}


#pragma mark - Memory Cleanup Methods 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
