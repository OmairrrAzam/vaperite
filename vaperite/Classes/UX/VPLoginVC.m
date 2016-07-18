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

@interface VPLoginVC ()

@property (weak, nonatomic) IBOutlet VPBaseTextField *tfUsername;
@property (weak, nonatomic) IBOutlet VPBaseTextField *tfPassword;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnRegister;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnForgot;

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin;
- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister;
- (IBAction)btnForgot_Pressed:(VPBaseUIButton *)btnForgot;

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

- (BOOL)validate {
    
    NSString *username = [self.tfUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.tfPassword.text;
    
    if (username.length == 0) {
        [self showError:@"Username is required."];
        return NO;
    }
    
    if (![self validateEmail:username]) {
        [self showError:@"Invalid email."];
        return NO;
    }
    
    if (password.length == 0) {
        [self showError:@"Password is required."];
        return NO;
    }
    
    return YES;
}

#pragma mark - IBActions

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin {
    
    if ([self validate]) {
        
    }
}

- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister {
    
}

- (IBAction)btnForgot_Pressed:(VPBaseUIButton *)btnForgot {
    
}

#pragma mark - Memory Cleanup Methods 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
