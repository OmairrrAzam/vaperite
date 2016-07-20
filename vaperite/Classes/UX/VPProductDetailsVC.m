//
//  VPProductDetailsVC.m
//  vaperite
//
//  Created by Apple on 19/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProductDetailsVC.h"
#import "VPProductDetailTableViewCell.h"
#import "VPProductDetailCounterTableViewCell.h"

@interface VPProductDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) int qty;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnOptions:(id)sender;
- (IBAction)btnSubCount:(id)sender;
- (IBAction)btnAddCount:(id)sender;

@end

@implementation VPProductDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.qty = 1;
    [self.tableView setBackgroundColor : [UIColor colorWithRed:203/255.0 green:227/255.0 blue:222/255.0 alpha:1]];
    //self.tfCounter.text = @"1";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 4;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3){
        return 50;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3){
        return 70;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 260;
    }else if(indexPath.section == 1){
        return 150;
    }else if(indexPath.section == 2){
        return 140;
    }else if(indexPath.section == 3){
        return 260;
    }

    return 100;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *v = [UIView new];
//    [v setBackgroundColor:[UIColor clearColor]];
//    return v;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    if (indexPath.section == 0) {
        cellIdentifier = @"PRODUCT_DETAIL_HEADER";
    }
    else if(indexPath.section == 1) {
        cellIdentifier = @"PRODUCT_COUNTER";
    }
    else if(indexPath.section == 2) {
        cellIdentifier = @"PRODUCT_DESCRIPTION";
    }
    else if(indexPath.section == 3){
        cellIdentifier = @"PRODUCT_REVIEWS";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section == 1) {
        UITextField *tfCounter = (UITextField *)[cell.contentView viewWithTag:1];
        tfCounter.text = [NSString stringWithFormat:@"%d", self.qty];
    }

    if (indexPath.section == 0){
        //cell.productImage.layer.cornerRadius = 37;
        //cell.productImage.layer.masksToBounds = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 3) {
//        return @"Reviews";
//    }
//    return @"";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView;
    if(section == 3){
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor colorWithRed:203/255.0 green:227/255.0 blue:222/255.0 alpha:1];

    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
    tempLabel.backgroundColor = [UIColor clearColor];
    //tempLabel.shadowColor = [UIColor darkGrayColor];
//    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor darkGrayColor]; //here you can change the text color of header.
    //tempLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSizeForHeaders];
    //tempLabel.font = [UIFont boldSystemFontOfSize:fontSizeForHeaders];
    tempLabel.text = @"Reviews";
    
    [tempView addSubview:tempLabel];
    }
    
    return tempView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *tempView;
    if(section == 3){
        tempView = [[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
        tempView.backgroundColor=[UIColor colorWithRed:203/255.0 green:227/255.0 blue:222/255.0 alpha:1];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button addTarget:self
          //         action:@selector(aMethod:)
         //forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Add Review" forState:UIControlStateNormal];
        
        UIImage *newImage = [UIImage imageNamed:@"plus18-button.png"];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
        
        button.frame = CGRectMake(13.0, 10.0, 290.0, 36.0);
        [tempView addSubview:button];
    }
    return tempView;
}

- (IBAction)btnOptions:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Categories" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Category1" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //[self startAnimating];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Category2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Category3" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    /*[alertController addAction:[UIAlertAction actionWithTitle:@"Button 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     // [self loadDropBox];
     }]];*/
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });

}

- (IBAction)btnSubCount:(id)sender {
    self.qty -= 1;
    
    if (self.qty <=0) {
        self.qty = 1;
    }
    [self.tableView reloadData];
    
}

- (IBAction)btnAddCount:(id)sender {
    self.qty += 1;
    [self.tableView reloadData];
    
}

- (IBAction)btnBack:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
