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
@property(copy,nonatomic) NSSet *markers;
@end

@implementation VPGMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:28.5382
                                                            longitude:-81.3687
                                                                 zoom:14
                                                              bearing:0
                                                         viewingAngle:0];
    self.mapView = [GMSMapView  mapWithFrame:CGRectMake(0, 0, 320, 456) camera:camera];
    
    
    self.mapView.delegate = self;
    [self setupMarkerData];
    [self drawMarkers];
    [self focusMapToShowAllMarkers];
    //CLLocationCoordinate2D target = CLLocationCoordinate2DMake(31.4810933, 74.30338789999996);
    //self.mapView.camera = [GMSCameraPosition cameraWithTarget:target zoom:2];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:5 maxZoom:18];
    
   
    
    //GMSMarkerOptions *myLocationOptions = [GMSMarkerOptions options];
    //myLocationOptions.title = @"My Location";
    //myLocationOptions.snippet = @"Lat:...., Lang:....";
    
    
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupMarkerData{
    GMSMarker *location1 = [[GMSMarker alloc]init];
    GMSMarker *location2 = [[GMSMarker alloc]init];
    GMSMarker *location3 = [[GMSMarker alloc]init];
   
    location1.title = @"Techverx";
    location1.snippet = @"This is Awesome Store. Click to see products ";
    location1.appearAnimation = kGMSMarkerAnimationPop;
    
 
    

    
    location1.position = CLLocationCoordinate2DMake(31.4810933, 74.30338789999996);
    location2.position = CLLocationCoordinate2DMake(31.4870159, 74.29788770000005);
    //location3.position = CLLocationCoordinate2DMake(-35.868, 151.208);
    self.markers = [NSSet setWithObjects:location1,location2, nil];
    
    //[self drawMarkers];
    
    
}
- (void)drawMarkers{
    for (GMSMarker *location in self.markers ) {
        if (location.map == nil) {
            location.map = self.mapView;
            //self.mapView.selectedMarker = location;
            [self.mapView setSelectedMarker:location];
        }
    }
}
- (void)focusMapToShowAllMarkers{
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    
    for (GMSMarker *marker in self.markers)
        bounds = [bounds includingCoordinate:marker.position];
    
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:60.0f]];
    
    
}
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

-(void)closeAlertview{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
