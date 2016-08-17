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
#import "VPRegionManager.h"
#import "VPRegionModel.h"

@interface VPUpdateBillingAddressVC ()<VPUserManagerDelegate, VPRegionManagerDelegate>
@property (strong, nonatomic)VPUserManager   *userManager;
@property (strong, nonatomic)VPRegionManager *regionManager;
@property (strong, nonatomic)VPUsersModel    *userAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnRegions;

@property (strong, nonatomic) NSString      *street;
@property (strong, nonatomic) NSString      *city;
@property (strong, nonatomic) NSString      *state;
@property (strong, nonatomic) NSString      *postal;
@property (strong, nonatomic) VPRegionModel *selectedRegion;
@property (strong, nonatomic) NSArray       *regions;

@property (weak, nonatomic) IBOutlet UITextField *tfStreet;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfState;
@property (weak, nonatomic) IBOutlet UITextField *tfPostal;

- (IBAction)btnUpdate_pressed:(id)sender;
- (IBAction)btnShowRegions:(id)sender;

@end

@implementation VPUpdateBillingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (!self.userManager){
        self.userManager = [[VPUserManager alloc]init];
        self.userManager.delegate = self;
    }
    
    if (!self.regionManager) {
        self.regionManager = [[VPRegionManager alloc]init];
        self.regionManager.delegate = self;
    }
    
    [self.regionManager fetchAllRegions];
    self.selectedRegion = self.loggedInUser.region;
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
    [self.btnRegions setTitle:self.loggedInUser.region.name forState:UIControlStateNormal];
}

- (void)mapToLoggedInUser:(VPUsersModel*)user{
    self.loggedInUser.street      = user.street;
    self.loggedInUser.city        = user.city;
    self.loggedInUser.state       = user.state;
    self.loggedInUser.postalcode  = user.postalcode;
    self.loggedInUser.region      = user.region;
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
    [self.userManager fetchAddressFromCustomerId:self.loggedInUser.customer_id];
}

- (void)userManager:(VPUserManager *)userManager didFetchAddress:(VPUsersModel *)user{
    
    [self mapToLoggedInUser:user];
    [self.loggedInUser save];
    [self refreshUser];
    [self populateFields];

}

- (void)userManager:(VPUserManager *)userManager didFailToFetchAddress:(NSString *)message{
    [self stopAnimating];
    [self startAnimatingWithErrorMsg:message];
}

#pragma mark - VPRegionManagerDelegateMethods

- (void)regionManager:(VPRegionManager *)regionManager didFetchAllRegions:(NSArray *)regions{
    self.regions = regions;
    [self stopAnimating];
}

- (void)regionManager:(VPRegionManager *)regionManager didFailToFetchAllRegions:(NSString *)message{
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
    [self startAnimating];
    [self.userManager updateAddressWithCustomerID:self.loggedInUser.customer_id  firstName:@"hardcoded coz of nil" lastName:@"hardcoded coz of nil" streetAddress:self.street  city:self.city postalCode:@"12312" region:self.selectedRegion.regionId];
    
        
}

- (IBAction)btnShowRegions:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pick Your Region" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (VPRegionModel *region in self.regions) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:region.name
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                                self.selectedRegion = region;
                                                                [self.btnRegions  setTitle:self.selectedRegion.name forState:UIControlStateNormal];
                                                            }]];
        
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                                            //[self startAnimating];
                                                            
                                                            
                                                        }]];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (BOOL) validFields{
    
    if([self.street isEqualToString:@""] || [self.state isEqualToString:@""] || [self.city isEqualToString:@""] || [self.postal isEqualToString:@""] || self.selectedRegion.regionId == nil){
        [self startAnimatingWithErrorMsg:@"Please Enter all fields"];
        return false;
    }
    if ([self.postal intValue] < 1001 || [self.postal intValue] > 99926) {
        [self showError:@"Invalid zipcode format."];
        return false;
    }
    
    return true;
}
@end
