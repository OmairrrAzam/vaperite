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



- (id)initWithDictionary:(NSDictionary *)dictMarker;
+ (NSArray *)loadFromArray:(NSArray *)arrMarkers;
+(void)saveToSession:(NSDictionary*)dict;
+ (VPMarkerModel *)currentStore;
@end
