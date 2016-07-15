
#import "VPLocationManager.h"


@interface VPLocationManager ()
@property (strong, nonatomic) NSArray *markers;


@end

@implementation VPLocationManager


- (void)fetchDistance:(CLLocation*)currentLocation {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"stores" ofType:@"plist"];
    NSArray *markers = [NSMutableArray arrayWithContentsOfFile:plistPath];
    self.markers = [VPMarkerModel loadFromArray:markers];
    [self addDistanceToMarkers:currentLocation];
    [self.delegate locationManager:self didFetchDistance:self.markers ];
}

#pragma mark - private Methods

-(void)addDistanceToMarkers:(CLLocation *)currentLocation{
    for(VPMarkerModel *marker in self.markers) {
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
        CLLocationDistance distanceA = [loc1 distanceFromLocation:currentLocation];
        marker.distantFromCurrentLocation = [NSNumber numberWithInt:(int)distanceA];
    }
}

@end
