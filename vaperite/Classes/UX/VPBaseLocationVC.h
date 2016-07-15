//
//  VPBaseLocationVC.h
//  vaperite
//
//  Created by Apple on 11/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseVC.h"
#import "VPMarkerModel.h"

@class CLLocationManager;
@class CLLocation;
@class VPLocationManager;


@interface VPBaseLocationVC : VPBaseVC

@property (weak, nonatomic) CLLocation *currentLocation;
@property(retain,nonatomic) NSMutableArray *markers;

- (void)locationManager:(VPLocationManager *)manager didFetchDistance:(NSMutableArray *)markerArray;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;


@end
