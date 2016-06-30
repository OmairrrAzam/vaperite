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

- (IBAction)btnLogin:(VPBaseUIButton *)sender;
- (IBAction)btnForgot:(VPBaseUIButton *)sender;
- (IBAction)btnRegister:(VPBaseUIButton *)sender;


@end

@implementation VPLoginVC

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

#pragma mark - Private Methods

- (BOOL)validate {
    
    NSString *username = [self.tfUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.tfPassword.text;
    
    if (username.length == 0) {
        //[self showError:@"Email cannot be empty."];
        return NO;
    }
    
//    if (![TMUserModel validateEmail:email]) {
//        //[self showError:@"Invalid email."];
//        return NO;
//    }
    
    if (password.length == 0) {
        //[self showError:@"Password cannot be empty."];
        return NO;
    }
    return YES;
}




#pragma mark - IBActions

- (IBAction)btnLogin:(VPBaseUIButton *)sender {
    
    [[NXOAuth2AccountStore sharedStore]requestAccessToAccountWithType:@"Magento"];
    /*[self.tfUsername resignFirstResponder];
    [self.tfPassword resignFirstResponder];
    
    if ([self validate]) {
        
    }*/

}
@end
