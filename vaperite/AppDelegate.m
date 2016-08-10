//
//  AppDelegate.m
//  vaperite
//
//  Created by Apple on 22/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NXOAuth2.h"
#import "AFNetworkActivityLogger.h"
#import <KVNProgress/KVNProgress.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Gmap initialization
    [GMSServices provideAPIKey:@"AIzaSyA43C2z1MgZLiqNA9E4Et32hdD2d3YTYCo"];
    
    
    
    
    // aftnetworking initialization
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (![AFNetworkReachabilityManager sharedManager].reachable){
            [KVNProgress showErrorWithStatus:@"No Connectivity"];
        }
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    // oauth initialization
    
    [[NXOAuth2AccountStore sharedStore] setClientID:@"6e1d10e6193b08ecd310c227d7b158c3"
                                             secret:@"1e8b98d07d01ded22a3062d5f5aca59e"
                                   authorizationURL:[NSURL URLWithString:@"www.vaperite.com/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"www.vaperite.com/oauth/token"]
                                        redirectURL:[NSURL URLWithString:@"myapp://callback"]
                                     forAccountType:@"Magento"];
    
    
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelInfo];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
   
    
    return YES;
}

- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"We recieved a callback");
    
   return  [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
