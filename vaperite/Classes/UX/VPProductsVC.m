//
//  VPProductsVC.m
//  vaperite
//
//  Created by Apple on 25/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProductsVC.h"

@interface VPProductsVC ()<UITableViewDataSource, UITableViewDelegate>

- (IBAction)btnAddFav:(id)sender;
- (IBAction)btnAddCart:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *ivContainer;

@end

@implementation VPProductsVC
NSMutableArray *productNames;
NSMutableArray *productImages;
NSMutableArray *productPrices;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    productNames  = [[NSMutableArray alloc]initWithObjects:@"Product1",@"product2", nil];
    productImages = [[NSMutableArray alloc]initWithObjects:@"vaperite_atlanta",@"vaperite_atlanta", nil];
    productPrices = [[NSMutableArray alloc]initWithObjects:@"$100",@"$200", nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [productNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 3;
//}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
//    [headerView setBackgroundColor:[UIColor clearColor]];
//    
//    return headerView;
//}
//
//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
//    [headerView setBackgroundColor:[UIColor clearColor]];
//    
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"productViewCell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIView *ivContainer      = (UIView *)[cell.contentView viewWithTag:33];
    UILabel *productName     = (UILabel *)[cell.contentView viewWithTag:30];
    UILabel *productPrice    = (UILabel *)[cell.contentView viewWithTag:31];
    UIImageView *productImgV = (UIImageView*)[cell.contentView viewWithTag:32];
    
    productImgV.layer.cornerRadius = 38.0f;
    productImgV.clipsToBounds      = YES;
    
    UIImage *productImg            = [UIImage imageNamed:[productImages objectAtIndex:indexPath.section]];
    ivContainer.layer.cornerRadius = 15.0f;
    
    productImgV.image = productImg;
    productName.text  = [productNames objectAtIndex:indexPath.section];
    productPrice.text = [productPrices objectAtIndex:indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"product_list_to_show" sender:self];
}

#pragma mark - IBActions

- (IBAction)btnAddFav:(id)sender {
}

- (IBAction)btnAddCart:(id)sender {
}
@end
