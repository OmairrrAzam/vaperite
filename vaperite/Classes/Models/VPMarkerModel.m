//
//  VPMakerModel.m
//  vaperite
//
//  Created by Apple on 11/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPMarkerModel.h"
#import "NSDictionary+Helper.h"
#define kSelectedStoreId         @"vaperite.store_id"


@implementation VPMarkerModel
MKRoute *currentRoute;
MKRouteStep *lastStep;


+ (NSArray *)loadFromArray:(NSArray *)arrProducts {
    
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *dictProduct in arrProducts) {
        VPMarkerModel *marker = [[VPMarkerModel alloc] initWithDictionary:dictProduct];
        [markers addObject:marker];
    }
    return markers;
}



- (id)initWithDictionary:(NSDictionary *)dictMarker {
    
    self = [super init];
    
    NSNumber *latitude  = [dictMarker objectForKeyHandlingNull:@"latitude"];
    NSNumber *longitude = [dictMarker objectForKeyHandlingNull:@"longitude"];
    
    self.title              = [dictMarker objectForKeyHandlingNull:@"title"];
    self.snippet            = [dictMarker objectForKeyHandlingNull:@"snippet"] ;
    self.appearAnimation    = kGMSMarkerAnimationPop;
    self.contactNumber      = [dictMarker objectForKeyHandlingNull:@"contactNumber"];
    self.timings            = [dictMarker objectForKeyHandlingNull:@"timings"];
    self.imgName            = [dictMarker objectForKeyHandlingNull:@"imageName"];
    self.position           = CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]);
    
    return self;
}

+(void)saveToSession:(NSDictionary*)dict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict[@"oauth_token"] forKey:kSelectedStoreId];
}

+(NSDictionary*)getTokenFromSession{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *tokenDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                               [defaults objectForKey:kOauthToken], kOauthToken,
                               [defaults objectForKey:kOauthTokenSecret], kOauthTokenSecret,nil];
    
    
    return tokenDict;
}
@end
