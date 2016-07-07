//
//  VPSliderMenuVC.m
//  vaperite
//
//  Created by Apple on 23/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPSliderMenuVC.h"
#import "UIViewController+ECSlidingViewController.h"
#import "VPMenuTableViewCell.h"

@interface VPSliderMenuVC ()
@property (strong,nonatomic) NSArray *menuItems;
@property (nonatomic, strong) NSMutableArray *cellDescriptors;
@property (nonatomic, strong) NSMutableArray *visibleRowsPerSection;
@end

@implementation VPSliderMenuVC


- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCellDescriptors];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.menuItems = [NSArray arrayWithObjects:@"Main", @"Second", nil];
    //self.tableView.separatorColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)loadCellDescriptors{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"leftMenu" ofType:@"plist"];
    self.cellDescriptors = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [self getIndicesOfVisibleRows];
    [self.tableView reloadData];
}

- (void)getIndicesOfVisibleRows{
    self.visibleRowsPerSection = [[NSMutableArray alloc]init];
    for (NSArray *section in self.cellDescriptors) {
        NSMutableArray *visibleRows = [[NSMutableArray alloc]init];
        for (NSDictionary *item in section){
            NSNumber *visible = [item valueForKey:@"isVisible"];
            BOOL isVisible = [visible boolValue];
            if (isVisible) {
                NSNumber *index = [NSNumber numberWithInt:(int)[section indexOfObject:item]];
                [visibleRows addObject:index];
                
            }
        }
        [self.visibleRowsPerSection addObject:visibleRows];
        
    }
}

- (NSDictionary*)getCellDescriptorForIndexPath:(NSIndexPath *)indexPath{
     NSMutableArray *section = [self.visibleRowsPerSection objectAtIndex:indexPath.section];
     NSNumber *indexOfVisibleRow = [section objectAtIndex:indexPath.row];
     NSDictionary *cellDescriptor = self.cellDescriptors[indexPath.section][indexOfVisibleRow.intValue];
    return cellDescriptor;
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.cellDescriptors != nil) {
        return self.cellDescriptors.count;
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *sect = [self.visibleRowsPerSection objectAtIndex:section];
    
    return sect.count;
    //return self.visibleRowsPerSection[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *currentElement = [self getCellDescriptorForIndexPath:indexPath ];
    
    static NSString *cellIdentifier = @"MenuCell";
    VPMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        
        cell = [[VPMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ];
    }
    
    cell.menuItem = currentElement;
    [cell configure];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
     self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    
    
    //NSString *menuItem = self.menuItems[indexPath.row];
    NSMutableArray *selectedSection = [self.visibleRowsPerSection objectAtIndex:indexPath.section];
    NSNumber *selectedRow = [selectedSection objectAtIndex:indexPath.row];
    
    NSDictionary *actualElement = [[self.cellDescriptors objectAtIndex:indexPath.section]objectAtIndex:selectedRow.intValue];
    
    if ([actualElement objectForKey:@"isExpandable"] ) {
        
        NSNumber *shouldExpandAndShowSubRows = [NSNumber numberWithBool:FALSE];
        Boolean isExpanded = [[actualElement objectForKey:@"isExpanded"]boolValue];
        if (!isExpanded) {
            shouldExpandAndShowSubRows = [NSNumber numberWithBool:YES];
        }
        
        [actualElement setValue:shouldExpandAndShowSubRows forKey:@"isExpanded"];
       
        NSNumber *noOfChildren = [actualElement objectForKey:@"additionalRows"];
        int childrenCount = (int)noOfChildren.integerValue;
        
        while (childrenCount) {
            
            [[[self.cellDescriptors objectAtIndex:indexPath.section ] objectAtIndex:(int)selectedRow.intValue + childrenCount]setValue:shouldExpandAndShowSubRows forKey:@"isVisible"];
            //[child setValue:shouldExpandAndShowSubRows forKey:@"isVisible"];
            childrenCount--;
        }
        [self getIndicesOfVisibleRows];
        [self.tableView reloadData];
    }else{
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Location"];
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    
   // NSMutableIndexSet *reloadSectionsContainer = [[NSMutableIndexSet alloc]init];
    
    //[reloadSectionsContainer addIndex:indexPath.section];
   
   
//    if ([menuItem isEqualToString:@"Main"]) {
//        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
//    } else if ([menuItem isEqualToString:@"Second"]) {
//        self.slidingViewController.topViewController = [self.storyboard   instantiateViewControllerWithIdentifier:@"Second"];
//    }
    
    
    
}




@end
