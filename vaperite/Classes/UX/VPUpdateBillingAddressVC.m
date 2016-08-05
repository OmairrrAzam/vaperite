//
//  VPUpdateBillingAddressVC.m
//  vaperite
//
//  Created by Apple on 26/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPUpdateBillingAddressVC.h"
#import "VPUserManager.h"
#import "VPUsersModel.h"

@interface VPUpdateBillingAddressVC ()<VPUserManagerDelegate>
@property (strong, nonatomic)VPUserManager *userManager;
@property (strong, nonatomic)VPUsersModel *userAddress;

@property (weak, nonatomic) NSString *street;
@property (weak, nonatomic) NSString *city;
@property (weak, nonatomic) NSString *state;
@property (weak, nonatomic) NSString *postal;

@property (weak, nonatomic) IBOutlet UITextField *tfStreet;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfState;
@property (weak, nonatomic) IBOutlet UITextField *tfPostal;
- (IBAction)btnUpdate_pressed:(id)sender;

@end

@implementation VPUpdateBillingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.userManager){
        self.userManager = [[VPUserManager alloc]init];
        self.userManager.delegate = self;
    }
    [self startAnimating];
    [self.userManager fetchAddressFromCustomerId:self.loggedInUser.customer_id];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateFields{
    self.tfStreet.text     = self.userAddress.street;
    self.tfCity.text       = self.userAddress.city;
    self.tfPostal.text     = self.userAddress.postalcode;
    self.tfState.text      = self.userAddress.state;
    
}

- (void)userManager:(VPUserManager *)userManager didUpdateAddress:(NSString *)response{
    [self stopAnimating];
    [self startAnimatingWithSuccessMsg:response];
    
}

- (void)userManager:(VPUserManager *)userManager didFailToUpdateAddress:(NSString *)message{
    [self stopAnimating];
    [self startAnimatingWithErrorMsg:message];
}


- (void)userManager:(VPUserManager *)userManager didFetchAddress:(VPUsersModel *)user{
    self.userAddress = user;
    [self populateFields];
    [self stopAnimating];
    
}
- (void)userManager:(VPUserManager *)userManager didFailToFetchAddress:(NSString *)message{
    [self stopAnimating];
    [self startAnimatingWithErrorMsg:message];
}

- (IBAction)btnUpdate_pressed:(id)sender {
    
    self.street = self.tfStreet.text;
    self.city   = self.tfCity.text;
    self.state  = self.tfState.text;
    self.postal = self.tfPostal.text;
    
    if (![self validFields]) {
        return;
    }
    
    [self.userManager updateAddressWithCustomerID:self.loggedInUser.customer_id  firstName:@"hardcoded coz of nil" lastName:@"hardcoded coz of nil"    streetAddress:self.street  city:self.city postalCode:@"12312"];
    
        
}

- (BOOL) validFields{
    
    if([self.street isEqualToString:@""] || [self.state isEqualToString:@""] || [self.city isEqualToString:@""] || [self.postal isEqualToString:@""]){
        [self startAnimatingWithErrorMsg:@"Please Enter all fields"];
        return false;
    }
    return true;
}
@end
