//
//  VPSliderMenuVC.m
//  vaperite
//
//  Created by Apple on 23/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPSliderMenuVC.h"
#import "UIViewController+ECSlidingViewController.h"

@interface VPSliderMenuVC ()
@property (strong,nonatomic) NSArray *menuItems;
@end

@implementation VPSliderMenuVC

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.menuItems = [NSArray arrayWithObjects:@"Main", @"Second", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ];
    }

    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    cell.textLabel.text = menuItem;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    if ([menuItem isEqualToString:@"Main"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    } else if ([menuItem isEqualToString:@"Second"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Second"];
    }
    
    
    [self.slidingViewController resetTopViewAnimated:YES];
}


@end
