//
//  VPBaseLocationVC.m
//  vaperite
//
//  Created by Apple on 11/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseLocationVC.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

#import "VPLocationManager.h"


@interface VPBaseLocationVC ()<CLLocationManagerDelegate, VPLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic)   UIViewController *currentViewController;
@property (weak, nonatomic)   CLPlacemark *placemark;
@property (strong, nonatomic) VPLocationManager *locManager;

@end

@implementation VPBaseLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locManager = [[VPLocationManager alloc]init];
    self.locManager.delegate = self;
    
    self.markers = [[NSMutableArray alloc]init];
    
    [self showMyLocation];
    
    
    //[self setupMarkerData];

    //Geocoder initilization
    self.geocoder = [[CLGeocoder alloc] init];
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

- (void)showMyLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    self.currentLocation = [locations lastObject];
    
    [self.locManager fetchDistance:self.currentLocation];
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

#pragma mark - VPLocationManagerDelegate Methods

- (void)locationManager:(VPLocationManager *)manager didFetchDistance:(NSMutableArray *)markerArray {
    self.markers = markerArray;
    [self stopAnimating];
}

- (void)locationManager:(VPLocationManager *)manager didFailToFetchAssets:(NSString *)message {
    [self showError:message];
}


@end
