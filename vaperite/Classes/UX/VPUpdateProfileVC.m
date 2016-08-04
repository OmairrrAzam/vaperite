//
//  VPUpdateProfileVC.m
//  vaperite
//
//  Created by Apple on 26/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPUpdateProfileVC.h"
#import "VPUserManager.h"
#import "VPUsersModel.h"

@interface VPUpdateProfileVC ()<VPUserManagerDelegate>

@end

@implementation VPUpdateProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)userManager:(VPUserManager *)userManager didFetchAddress:(VPUsersModel *)review{
    
    
}
- (void)userManager:(VPUserManager *)userManager didFailToFetchAddress:(NSString *)message{
    
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
