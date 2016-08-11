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

@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *postal;

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

#pragma mark - Private Methods

- (void)populateFields{
    self.tfStreet.text     = self.loggedInUser.street;
    self.tfCity.text       = self.loggedInUser.city;
    self.tfPostal.text     = self.loggedInUser.postalcode;
    self.tfState.text      = self.loggedInUser.state;
}

- (void)mapToLoggedInUser:(VPUsersModel*)user{
    self.loggedInUser.street      = user.street;
    self.loggedInUser.city        = user.city;
    self.loggedInUser.state       = user.state;
    self.loggedInUser.postalcode  = user.postalcode;
}

#pragma mark - VPUserManagerDelegateMethods

- (void)userManager:(VPUserManager *)userManager didUpdateAddress:(VPUsersModel *)user{
    [self mapToLoggedInUser:user];
    [self.loggedInUser save];
    [self refreshUser];
    [self stopAnimating];
    [self startAnimatingWithSuccessMsg:@"Address Updated"];
    [self populateFields];
}

- (void)userManager:(VPUserManager *)userManager didFailToUpdateAddress:(NSString *)message{
    [self stopAnimating];
    [self startAnimatingWithErrorMsg:message];
}

- (void)userManager:(VPUserManager *)userManager didFetchAddress:(VPUsersModel *)user{
    
    [self mapToLoggedInUser:user];
    [self.loggedInUser save];
    [self refreshUser];
    [self populateFields];
    [self stopAnimating];
    
}

- (void)userManager:(VPUserManager *)userManager didFailToFetchAddress:(NSString *)message{
    [self stopAnimating];
    [self startAnimatingWithErrorMsg:message];
}

#pragma mark - IBActions

- (IBAction)btnUpdate_pressed:(id)sender {
    
    self.street = self.tfStreet.text;
    self.city   = self.tfCity.text;
    self.state  = self.tfState.text;
    self.postal = self.tfPostal.text;
    
    if (![self validFields]) {
        return;
    }
    
    [self.userManager updateAddressWithCustomerID:self.loggedInUser.customer_id  firstName:@"hardcoded coz of nil" lastName:@"hardcoded coz of nil" streetAddress:self.street  city:self.city postalCode:@"12312"];
    
        
}

- (BOOL) validFields{
    
    if([self.street isEqualToString:@""] || [self.state isEqualToString:@""] || [self.city isEqualToString:@""] || [self.postal isEqualToString:@""]){
        [self startAnimatingWithErrorMsg:@"Please Enter all fields"];
        return false;
    }
    
    return true;
}
@end
