//
//  VPMakerModel.h
//  vaperite
//
//  Created by Apple on 11/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
@import MapKit;

@interface VPMarkerModel : GMSMarker

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSNumber *distantFromCurrentLocation;
@property (strong, nonatomic) NSString *timings;
@property (strong, nonatomic) NSString *contactNumber;
@property (strong, nonatomic) NSString *imgName;

+ (NSArray *)loadFromArray:(NSArray *)arrMarkers;
+ (VPMarkerModel *)currentStore;
- (id)initWithDictionary:(NSDictionary *)dictMarker;
- (NSDictionary *)toDictionary;
- (void)save;

@end
