//
//  VPBaseVC.m
//  vaperite
//
//  Created by Apple on 24/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseVC.h"
#import <KVNProgress/KVNProgress.h>
#import "UIViewController+ECSlidingViewController.h"


@interface VPBaseVC ()
@property (nonatomic) KVNProgressConfiguration *basicConfiguration;
@property (nonatomic) KVNProgressConfiguration *customConfiguration;
@end

@implementation VPBaseVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    self.customConfiguration = [self customKVNProgressUIConfiguration];
    [KVNProgress setConfiguration:self.customConfiguration];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self startAnimating];
}

#pragma mark - Helpers

- (void)updateProgress
{
    dispatch_main_after(2.0f, ^{
        [KVNProgress updateProgress:0.3f
                           animated:YES];
    });
    dispatch_main_after(2.5f, ^{
        [KVNProgress updateProgress:0.5f
                           animated:YES];
    });
    dispatch_main_after(2.8f, ^{
        [KVNProgress updateProgress:0.6f
                           animated:YES];
    });
    dispatch_main_after(3.7f, ^{
        [KVNProgress updateProgress:0.93f
                           animated:YES];
    });
    dispatch_main_after(5.0f, ^{
        [KVNProgress updateProgress:1.0f
                           animated:YES];
    });
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}


#pragma mark - UI

- (KVNProgressConfiguration *)customKVNProgressUIConfiguration
{
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    // See the documentation of KVNProgressConfiguration
    configuration.statusColor = [UIColor blackColor];
    //configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    configuration.circleStrokeForegroundColor = [UIColor blueColor];
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    configuration.backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
    //configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.4f];
    configuration.successColor = [UIColor whiteColor];
    configuration.errorColor = [UIColor whiteColor];
    configuration.stopColor = [UIColor whiteColor];
    configuration.circleSize = 110.0f;
    configuration.lineWidth = 1.0f;
    configuration.showStop = YES;
    configuration.stopRelativeHeight = 0.3f;
    
    configuration.tapBlock = ^(KVNProgress *progressView) {
        [KVNProgress dismiss];
    };
    
    return configuration;
}

- (void)startAnimating {
      [KVNProgress showWithStatus:@"Loading..."];
}

- (void)stopAnimating{
    
    [KVNProgress dismiss];
}

- (void)showError:(NSString*)errorMsg{
    [KVNProgress showErrorWithStatus:errorMsg];
}

- (BOOL)validateEmail:(NSString *)emailAddress {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

- (void)beautifyTextFields {
    
    for (UITextField *textField in self.textFields) {
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.bounds.size.width, 0.5);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
        [textField.layer addSublayer:bottomBorder];
    }
}

- (BOOL)isStaging {
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"STAGING"] boolValue];
}

- (IBAction)menuButtonTapped:(id)sender {
    
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - Memory Cleanup Methods 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
