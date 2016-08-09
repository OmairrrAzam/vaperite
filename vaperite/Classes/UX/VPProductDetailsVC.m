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
#import  "VPProductModel.h"
#import "VPProductManager.h"
#import "VPReviewsModel.h"
#import "UIImageView+AFNetworking.h"
#import "VPAddReviewVC.h"

@interface VPProductDetailsVC ()<UITableViewDelegate, UITableViewDataSource, VPProductManagerDelegate>


@property (strong, nonatomic) VPProductManager *productManager;
@property (nonatomic) int qty;
@property (strong, nonatomic) UIButton *btnStar1;
@property (strong, nonatomic) UIButton *btnStar2;
@property (strong, nonatomic) UIButton *btnStar3;
@property (strong, nonatomic) UIButton *btnStar4;
@property (strong, nonatomic) UIButton *btnStar5;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnOptions:(id)sender;
- (IBAction)btnSubCount:(id)sender;
- (IBAction)btnAddCount:(id)sender;

- (IBAction)btn1star_pressed:(id)sender;
- (IBAction)btn2star_pressed:(id)sender;
- (IBAction)btn3star_pressed:(id)sender;
- (IBAction)btn4star_pressed:(id)sender;
- (IBAction)btn5star_pressed:(id)sender;
- (IBAction)addToCart_pressed:(id)sender;
- (IBAction)btnFavourite_pressed:(id)sender;


@end

@implementation VPProductDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.productManager) {
        self.productManager = [[VPProductManager alloc]init];
        self.productManager.delegate = self;
    }
    [self startAnimating];
    
    [self.productManager fetchProductDetailsWithProductId:self.product.id andStoreId:self.currentStore.id];
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
        return [self.product.reviews count];
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
        return 300;
    }else if(indexPath.section == 1){
        return 150;
    }else if(indexPath.section == 2){
        return 140;
    }else if(indexPath.section == 3){
        return 260;
    }

    return 100;
}

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
    
    if (indexPath.section == 0){
        
        UILabel *lblName          = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *lblPrice         = (UILabel *)[cell.contentView viewWithTag:3];
        UIImageView *productImage = (UIImageView *)[cell.contentView viewWithTag:5];
        
         self.btnStar1 = (UIButton *)[cell.contentView viewWithTag:51];
         self.btnStar2 = (UIButton *)[cell.contentView viewWithTag:52];
         self.btnStar3 = (UIButton *)[cell.contentView viewWithTag:53];
         self.btnStar4 = (UIButton *)[cell.contentView viewWithTag:54];
         self.btnStar5 = (UIButton *)[cell.contentView viewWithTag:55];
        
        self.product.rating = @"3";
        int value = [self.product.rating intValue];
        int ratingValue = 100/value;
        UIImage *filledStar = [UIImage imageNamed:@"yellow-star.png"];
        
        if (ratingValue < 20) {
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
        }else if(ratingValue > 20 && ratingValue < 40 ){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
        }else if(ratingValue > 40 && ratingValue < 60 ){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar3 setImage:filledStar forState:UIControlStateNormal];
        }else if(ratingValue > 60 && ratingValue < 80 ){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar3 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar4 setImage:filledStar forState:UIControlStateNormal];
        }else if((ratingValue > 80 && ratingValue < 100 )){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar3 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar4 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar5 setImage:filledStar forState:UIControlStateNormal];
        }
        
        
        lblName.text       = self.product.name;
        lblPrice.text      = [NSString stringWithFormat:@"$%@", self.product.price];
        
        NSURL *url = [NSURL URLWithString: self.product.imgUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UIImageView *weakImg = productImage;
        [weakImg setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              productImage.image = image;
                                              [weakImg setNeedsLayout];
                                              
                                          } failure:nil];    }
    
    if (indexPath.section == 1) {
        UITextField *tfCounter = (UITextField *)[cell.contentView viewWithTag:1];
        tfCounter.text = [NSString stringWithFormat:@"%d", self.qty];
    }else if (indexPath.section == 2){
        UITextView *tvDescription      = (UITextView *)[cell.contentView viewWithTag:10];
        tvDescription.text             = self.product.desc;
    }else if (indexPath.section == 3){
        UILabel *lblReviewTitle     = (UILabel*)[cell.contentView viewWithTag:20];
        UITextView *tvReviewDetail  = (UITextView*)[cell.contentView viewWithTag:21];
        
        VPReviewsModel *currentReview = [self.product.reviews objectAtIndex:indexPath.row];
        
        lblReviewTitle.text = currentReview.titl;
        tvReviewDetail.text = currentReview.desc;
    
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
    //tempLabel.shadowOffset = CGSizeMake(0,2);
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
        [button addTarget:self action:@selector(addReview:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Add Review" forState:UIControlStateNormal];
        
        UIImage *newImage = [UIImage imageNamed:@"plus18-button.png"];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
        
        button.frame = CGRectMake(13.0, 10.0, 290.0, 36.0);
        [tempView addSubview:button];
    }
    return tempView;
}

#pragma  mark - IBActions
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

- (IBAction)btn1star_pressed:(id)sender {
    
}


- (IBAction)addReview:(id)sender{
    if(self.loggedInUser){
     [self performSegueWithIdentifier:@"add_review_segue" sender:self];
    }else{
        UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_NAVIGATOR"];
        loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:loginNavigator animated:YES completion:nil];
    }

    //UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"AddReviewID"];
    //loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:loginNavigator animated:YES completion:nil];
}

- (IBAction)btnBack:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)btn2star_pressed:(id)sender {
}

- (IBAction)btn3star_pressed:(id)sender {
}

- (IBAction)btn4star_pressed:(id)sender {
}

- (IBAction)btn5star_pressed:(id)sender {
}

- (IBAction)addToCart_pressed:(id)sender {
    if(self.loggedInUser){
        
    }else{
        UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_NAVIGATOR"];
        loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:loginNavigator animated:YES completion:nil];
    }
}

- (IBAction)btnFavourite_pressed:(id)sender {
    
    if(self.loggedInUser){
        if (!self.productManager) {
            self.productManager = [[VPProductManager alloc]init];
            self.productManager.delegate = self;
        }
        [self startAnimating];
        
        [self.productManager addToFavouriteWithCustomerId:self.loggedInUser.customer_id andProduct:self.product];
    }else{
        
        UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_NAVIGATOR"];
        loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:loginNavigator animated:YES completion:nil];
        
    }
    
   
    
}

#pragma mark - ProductDetails Manager Delegates

- (void)productManager:(VPProductManager *)manager didFetchProductDetails:(VPProductModel *)product{
    //[self stopAnimating];
    self.product = product;
    //[self.tableView reloadData];
    
    [self.productManager fetchProductReviewswithProductId:self.product.id andStoreId:self.storeId];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProductDetails:(NSString *)message{
}

- (void)productManager:(VPProductManager *)manager didFetchProductReviews:(NSArray *)reviews{
    
    self.product.reviews = reviews;
    [self stopAnimating];
    [self.tableView reloadData];
    //[self.productManager fetchProductImageWithProductId:self.product.id andSessionId:self.sessionId];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProductReviews:(NSString *)message{
}

- (void)productManager:(VPProductManager *)manager didFetchProductImage:(NSString *)imgURL{
    self.product.imgUrl = imgURL;
    [self stopAnimating];
    [self.tableView reloadData];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProductImage:(NSString *)message{
}


- (void)productManager:(VPProductManager *)manager didAddToFavourites:(NSString *)message{
    [self startAnimatingWithSuccessMsg:message];
    
    
}
- (void)productManager:(VPProductManager *)manager didFailToAddToFavourites:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
}

#pragma mark - Segue Callbacks

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"add_review_segue"]) {
        VPAddReviewVC *reviewVC = [segue destinationViewController];
        reviewVC.productId = self.product.id;
    }
}



//- (void)productManager:(VPProductManager *)manager didFetchProductRating:(NSString *)rating{
//     [self stopAnimating];
//     self.product.rating = rating;
//    
//}
//- (void)productManager:(VPProductManager *)manager didFailToFetchProductRating:(NSString *)message{
//    
//}
@end
