//
//  VPGMapVC.m
//  vaperite
//
//  Created by Apple on 01/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPGMapVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface VPGMapVC ()<GMSMapViewDelegate>
@property(strong, nonatomic) GMSMapView *mapView;
@end

@implementation VPGMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)showMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                            longitude:self.currentLocation.coordinate.longitude
                                                                 zoom:1
                                                              bearing:0
                                                         viewingAngle:0];
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    
    // self.mapView = [GMSMapView  mapWithFrame:CGRectMake(0, 0, 320, 456) camera:camera];
    //CLLocationCoordinate2D target = CLLocationCoordinate2DMake(31.4810933, 74.30338789999996);
    //self.mapView.camera = [GMSCameraPosition cameraWithTarget:target zoom:2];
    //[self.mapView setMinZoom:5 maxZoom:18];
    //GMSMarkerOptions *myLocationOptions = [GMSMarkerOptions options];
    //myLocationOptions.title = @"My Location";
    //myLocationOptions.snippet = @"Lat:...., Lang:....";
    
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)drawMarkers{
    for (GMSMarker *location in self.markers ) {
        if (location.map == nil) {
            location.map = self.mapView;
            self.mapView.selectedMarker = location;
            [self.mapView setSelectedMarker:location];
        }
    }
}

- (void)focusMapToShowAllMarkers{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (VPMarkerModel *marker in self.markers){
        bounds = [bounds includingCoordinate:marker.position];
    }
    VPMarkerModel *currentPosition = [VPMarkerModel markerWithPosition: CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude)];
    bounds = [bounds includingCoordinate: currentPosition.position];
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:60.0f]];
}

-(void)closeAlertview{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [super locationManager:manager didUpdateLocations:locations];
    [self showMap];
    [self drawMarkers];

    [self focusMapToShowAllMarkers];
}

#pragma mark - VPLocationManagerDelegate Methods

- (void)locationManager:(VPLocationManager *)manager didFetchDistance:(NSMutableArray *)markerArray {
    [super locationManager:manager didFetchDistance:markerArray];
}

#pragma mark - MapView Delegate Methods

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:marker.title message:@"You will be directed to this store, please confirm" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // [self closeAlertview];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //[self loadGooglrDrive];
    }]];
    
    /*[alertController addAction:[UIAlertAction actionWithTitle:@"Button 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     // [self loadDropBox];
     }]];*/
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


@end
