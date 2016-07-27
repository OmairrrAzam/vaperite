//
//  VPRightMenuVC.m
//  vaperite
//
//  Created by Apple on 20/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPRightMenuVC.h"
#import "VPSliderMenuVC.h"

@interface VPRightMenuVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnDismiss:(id)sender;
- (IBAction)btnRemoveProduct:(id)sender;

@end

@implementation VPRightMenuVC
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {}
NSMutableArray *testProducts;

- (void)viewDidLoad {
    [super viewDidLoad];
    testProducts  = [[NSMutableArray alloc]initWithObjects:@"first", @"second",@"third", @"fourth", nil ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 2) {
        return 1;
    }else if (section == 1){
        return [testProducts count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    if (indexPath.section == 0){
        cellIdentifier = @"cartHeader";
        
    }else if (indexPath.section == 1){
        cellIdentifier = @"rightMenuProductCell";
    }else{
        cellIdentifier = @"rightMenuCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ];
    }
    
    if (indexPath.section == 1){
        UILabel *productName = (UILabel *)[cell.contentView viewWithTag:10];
        productName.text     = [testProducts objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return 0;
    }else if(section == 1){
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 ){
        return 35;
    }
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1){
        return 10;
    }
    return 0;
}

#pragma mark - IBActions

- (IBAction)btnDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];}

- (IBAction)btnRemoveProduct:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    [testProducts removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}


@end
