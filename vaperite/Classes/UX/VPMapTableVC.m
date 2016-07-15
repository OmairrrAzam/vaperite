//
//  VPMapTableVC.m
//  vaperite
//
//  Created by Apple on 02/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPMapTableVC.h"
#import "VPMapTableViewCell.h"
#import "VPDashboardVc.h"
#import "UIViewController+ECSlidingViewController.h"

@interface VPMapTableVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation VPMapTableVC
NSArray *tableData;
NSArray *thumbnails;
NSArray *numbers;
NSArray *timess;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor : [UIColor colorWithRed:203/255.0 green:227/255.0 blue:222/255.0 alpha:1]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

   return [self.markers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *cellIdentifier = @"MapCell";
    VPMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[VPMapTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ];
    }
    
    VPMarkerModel *location = [self.markers objectAtIndex:indexPath.section];
    VPMarkerModel *selectedLocation =  [VPMarkerModel currentStore];
    
    cell.imgMap.image       = [UIImage imageNamed:location.imgName];
    cell.lblName.text       = location.title;
    cell.lblCellNo.text     = location.contactNumber;
    cell.lblDistance.text   = [NSString stringWithFormat:@"%i Km",(int)location.distantFromCurrentLocation.intValue];
    cell.lblTime.text       = location.timings;
    cell.backgroundColor    = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:248/255.0 alpha:1];
    

    if (selectedLocation) {
        if (selectedLocation.id == location.id) {
            cell.backgroundColor = [UIColor  colorWithRed:210/255.0 green:190/255.0 blue:29/255.0 alpha:1];
        
        }
    }
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //VPMarkerModel *selectedLocation =  [VPMarkerModel currentStore];
    VPMarkerModel *clickedLocation = [self.markers objectAtIndex:indexPath.section];
//    if (selectedLocation) {
//        if (selectedLocation.id == clickedLocation.id) {
//            return;
//        }
//    }
    [clickedLocation save];
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];
    [self.slidingViewController resetTopViewAnimated:YES];//    NSString * storyboardName = @"Main";
    
    
    

}

#pragma mark - VPLocationManagerDelegate Methods

- (void)locationManager:(VPLocationManager *)manager didFetchDistance:(NSMutableArray *)markerArray {
    [super locationManager:manager didFetchDistance:markerArray];
    [self.tableView reloadData];
    
}





@end
