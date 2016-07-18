//
//  VPRegisterVC.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPRegisterVC.h"
#import "VPUsersModel.h"

@interface VPRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

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
    NSString *password = [self.tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
    
    if (password.length == 0) {
        [self showError:@"Password is required."];
        return nil;
    }
    
    if (![password isEqualToString:confirm]) {
        [self showError:@"Password and Confirm password should match."];
        return nil;
    }
    
    VPUsersModel *user = [[VPUsersModel alloc] init];
    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    user.password = password;
    return user;
}

#pragma mark - IBActions

- (IBAction)btnRegister_Pressed:(UIButton *)btnRegister {
    
    VPUsersModel *user = [self validate];
    if (user) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
