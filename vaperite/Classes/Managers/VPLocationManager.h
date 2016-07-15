

#import <Foundation/Foundation.h>
#import "VPBaseManager.h"
#import "VPSessionManager.h"
#import "VPMarkerModel.h"
#import <CoreLocation/CoreLocation.h>


@class VPLocationManager;

@protocol VPLocationManagerDelegate

@optional
- (void)locationManager:(VPLocationManager *)manager didFetchDistance:(NSArray *)markerArray ;
- (void)locationManager:(VPLocationManager *)manager didFailToFetchAssets:(NSString *)message;
@end

@interface VPLocationManager : VPBaseManager

@property (weak, nonatomic) id<VPLocationManagerDelegate> delegate;
- (void)fetchDistance:(CLLocation*) currentLocation ;

@end
