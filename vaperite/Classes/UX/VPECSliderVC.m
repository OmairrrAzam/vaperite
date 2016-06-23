//
//  VPECSliderVC.m
//  vaperite
//
//  Created by Apple on 23/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPECSliderVC.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"

@interface VPECSliderVC ()
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation VPECSliderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitions.dynamicTransition.slidingViewController = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *transitionData = self.transitions.all[2];
    id transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.delegate = nil;
    } else {
        self.delegate = transition;
    }
}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
