//
//  VP18plusVC.m
//  vaperite
//
//  Created by Apple on 14/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VP18plusVC.h"

@interface VP18plusVC ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation VP18plusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.containerView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.containerView.layer setBorderWidth:1.5f];
    [self.containerView.layer setCornerRadius:10.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnOver18:(id)sender {
   // NSString * storyboardName = @"Main";
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
   // UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Location"];
   // [self presentViewController:vc animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnUnder18:(id)sender {
    exit(0);
}

@end
