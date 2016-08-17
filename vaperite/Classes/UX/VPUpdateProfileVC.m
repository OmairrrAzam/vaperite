//
//  VPUpdateProfileVC.m
//  vaperite
//
//  Created by Apple on 26/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPUpdateProfileVC.h"
#import "VPUserManager.h"
#import "VPUsersModel.h"

@interface VPUpdateProfileVC ()<VPUserManagerDelegate>
@property (strong, nonatomic)VPUserManager *userManager;
@property (strong, nonatomic)VPUsersModel *userAddress;

@property (strong, nonatomic)  NSString *FirstName;
@property (strong, nonatomic)  NSString *LastName;
@property (strong, nonatomic)  NSString *Email;
@property (strong, nonatomic)  NSString *Password;

@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

- (IBAction)btnUpdatePressed:(id)sender;
@end

@implementation VPUpdateProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    if (!self.userManager){
        self.userManager = [[VPUserManager alloc]init];
        self.userManager.delegate = self;
    }
    
    [self populateFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateFields{
    
    self.tfEmail.text     = self.loggedInUser.email;
    self.tfFirstName.text = self.loggedInUser.firstName;
    self.tfLastName.text  = self.loggedInUser.lastName;
    
}

#pragma mark - VPUSerManagerDelegate Methods

- (void)userManager:(VPUserManager *)userManager didUpdatePassword:(NSString *)response{
    
    [self startAnimatingWithSuccessMsg:response];
}

- (void)userManager:(VPUserManager *)userManager didFailToUpdatePassword:(NSString *)message{
    [self stopAnimating];
    [self startAnimatingWithErrorMsg:message];
    
}

#pragma mark - IBActions

- (IBAction)btnUpdatePressed:(id)sender {
    self.Email     = self.tfEmail.text;
    self.FirstName = self.tfFirstName.text;
    self.LastName  = self.tfLastName.text;
    self.Password  = self.tfPassword.text;
    
    [self startAnimating];
    if ([self validFields]) {
        
        [self.userManager updatePasswordWithCustomerID:self.loggedInUser.customer_id firstName:self.FirstName lastName:self.LastName email:self.Email password:self.Password];
        
    }
}

- (BOOL)validFields{
    if ([self.Email isEqualToString:@""] || [self.FirstName isEqualToString:@""] || [self.LastName isEqualToString:@""] || [self.Password isEqualToString:@""]) {
        [self startAnimatingWithErrorMsg:@"Please Enter all Fields"];
        return false;
    }
    
    if (self.Password.length < 8) {
        [self startAnimatingWithErrorMsg:@"Password length must be atleaast 8 characters"];
        return false;
    }
    return true;
    
}
@end
