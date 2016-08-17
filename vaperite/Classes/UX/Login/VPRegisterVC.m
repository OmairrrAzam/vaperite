//
//  VPRegisterVC.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPRegisterVC.h"
#import "VPUsersModel.h"
#import "VPUserManager.h"

@interface VPRegisterVC ()<VPUserManagerDelegate>

@property (strong, nonatomic)  VPUserManager     *userManager;
@property (strong, nonatomic)  NSString          *password;

@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton    *btnRegister;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnRegister_Pressed:(UIButton *)btnRegister;

@end

@implementation VPRegisterVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self beautifyTextFields];
    self.btnRegister.layer.cornerRadius = 20.0;
}

#pragma mark - Private Methods 

- (VPUsersModel *)validate {
    
    NSString *firstName = [self.tfFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastName = [self.tfLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [self.tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *confirm = [self.tfConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if (firstName.length == 0) {
        [self showError:@"First name is required."];
        return nil;
    }
    
    if (lastName.length == 0) {
        [self showError:@"Last name is required."];
        return nil;
    }
    
    if (email.length == 0) {
        [self showError:@"Email is required."];
        return nil;
    }
    
    if (![super validateEmail:email]) {
        [self showError:@"Invalid email."];
        return nil;
    }
    
    if (self.password.length == 0) {
        [self showError:@"Password is required."];
        return nil;
    }
    
    if (![self.password isEqualToString:confirm]) {
        [self showError:@"Password and Confirm password should match."];
        return nil;
    }
    
    VPUsersModel *user = [[VPUsersModel alloc] init];
    user.email         = email;
    user.firstName     = firstName;
    user.lastName      = lastName;
    user.email         = email;
    //user.password = password;
    return user;
}

#pragma mark - IBActions

- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnRegister_Pressed:(UIButton *)btnRegister {
    
    VPUsersModel *user = [self validate];
    
    if (user) {
        [self startAnimatingWithCustomMsg:@"Registering New User"];
        
        
        if (!self.userManager) {
            self.userManager = [[VPUserManager alloc]init];
            self.userManager.delegate = self;
        }
        
        [self.userManager createUserFromStoreId:@"1" password:self.password user:user];
    }
}

#pragma mark - VPUserManagerDelegateMethods

- (void)userManager:(VPUserManager *)userManager didCreateUser:(VPUsersModel *)user{
    [self stopAnimating];
    
    [self startAnimatingWithSuccessMsg:@"Logging You In"];
    [self.userManager authenticateWithEmail:user.email password:self.password pushToken:nil];
    
}

- (void)userManager:(VPUserManager *)userManager didFailToCreateUser:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
}

- (void)userManager:(VPUserManager *)userManager didAuthenticateWithUser:(VPUsersModel *)user{
    [self startAnimatingWithSuccessMsg:@"You are now logged in!"];
    
    self.loggedInUser = user;
    [user save];
    [self refreshUser];
    if(self.loggedInUser){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self changeViewThroughSlider:@"Dashboard"];
    }

}

- (void)userManager:(VPUserManager *)userManager didFailToAuthenticateWithMessage:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
