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
#import "VPCartModel.h"

@interface VPProductDetailsVC ()<UITableViewDelegate, UITableViewDataSource, VPProductManagerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *lblReviewsCount;
@property (strong, nonatomic) VPProductManager *productManager;
@property (nonatomic) int qty;

@property (strong, nonatomic) NSString *selectedDose;
@property (nonatomic) BOOL productPresentInCart;
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
@property (weak, nonatomic) IBOutlet UIButton *btnDoses;

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
    
    self.userCart = [VPCartModel currentCart];

    [self.productManager fetchProductDetailsWithProductId:self.product.id andStoreId:self.currentStore.id];
    
    [self.tableView setBackgroundColor : [UIColor colorWithRed:203/255.0 green:227/255.0 blue:222/255.0 alpha:1]];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startAnimating];
    [self.productManager fetchProductDetailsWithProductId:self.product.id andStoreId:self.currentStore.id];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void) addToCart:(VPProductModel*)selectedProduct{
    
    if ([selectedProduct.stockQty intValue] <= 0) {
        [self startAnimatingWithErrorMsg:@"Product out of stock"];
        return;
    }
    
    if(self.loggedInUser){
        
        if([self.userCart productPresentInCart:selectedProduct]){
            if ([self.userCart updateProductInCart:selectedProduct]){
                [self startAnimatingWithSuccessMsg:@"Cart Updated"];
            }else{
                [self startAnimatingWithErrorMsg:@"Cart Not Updated"];
            }
        }else{
            
            if (selectedProduct.doses && !selectedProduct.cartStrength) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Strength Options" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                
                for (NSString *key in selectedProduct.doses) {
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:[selectedProduct.doses objectForKey:key]
                                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                                            //self.selectedDose = key;
                                                                            selectedProduct.cartStrength = [key intValue];
                                                                            selectedProduct.cartStrengthValue = [selectedProduct.doses objectForKey:key];
                                                                            
                                                                            if ([self.userCart addProductInCart:selectedProduct]) {
                                                                                [self updateNavBadge];
                                                                                [self startAnimatingWithSuccessMsg:@"Added To Cart"];
                                                                                [self refreshCartAndFav];
                                                                                [self.tableView reloadData];
                                                                            }else{
                                                                                [self startAnimatingWithSuccessMsg:@"Not Added To Cart"];
                                                                            }
                                                                            
                                                                            
                                                                            
                                                                        }]];
                    
                }
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                    style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                                                        //[self startAnimating];
                                                                        
                                                                        
                                                                    }]];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }else{
                
                if ([self.userCart addProductInCart:selectedProduct]) {
                    [self updateNavBadge];
                    [self startAnimatingWithSuccessMsg:@"Added To Cart"];
                }else{
                    [self startAnimatingWithSuccessMsg:@"Not Added To Cart"];
                }
            }
            
        }
        
    }else{
        [self showLoginPage];
    }
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + [self.product.reviews count] ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 3) {
//        return [self.product.reviews count];
//    }
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
    if (section == 3 + [self.product.reviews count] -1){
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
    }else if(indexPath.section >= 3){
        return 200;
    }

    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.productPresentInCart = [self.userCart productPresentInCart:self.product];
    
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
    else if(indexPath.section >= 3){
        cellIdentifier = @"PRODUCT_REVIEWS";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    if (indexPath.section == 0){
        
        UILabel *lblName          = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *lblPrice         = (UILabel *)[cell.contentView viewWithTag:3];
        UIImageView *productImage = (UIImageView *)[cell.contentView viewWithTag:5];
        UIButton *btnFav          = (UIButton*)[cell.contentView viewWithTag:6];
        self.btnDoses             = (UIButton*)[cell.contentView viewWithTag:10];
        UIView *viewItemStrength  = (UIView*)[cell.contentView viewWithTag:200];
         UILabel *lblReviewsCount = (UILabel *)[cell.contentView viewWithTag:16];
         UILabel *lblStockCount   = (UILabel *)[cell.contentView viewWithTag:499];
        
        lblStockCount.text = [NSString stringWithFormat:@"Products in stock (%d)",[self.product.stockQty intValue]];
        
        if(!self.product.doses || [self.product.doses count] == 0){
            viewItemStrength.hidden = YES;
        }else{
            viewItemStrength.hidden = NO;
        }
        
         self.btnStar1 = (UIButton *)[cell.contentView viewWithTag:51];
         self.btnStar2 = (UIButton *)[cell.contentView viewWithTag:52];
         self.btnStar3 = (UIButton *)[cell.contentView viewWithTag:53];
         self.btnStar4 = (UIButton *)[cell.contentView viewWithTag:54];
         self.btnStar5 = (UIButton *)[cell.contentView viewWithTag:55];
        
        
        lblReviewsCount.text = [NSString stringWithFormat:@"(%d) Reviews", (int)[self.product.reviews count] ];
//        int value = [self.product.rating intValue];
//        int ratingValue = 100/value;
        UIImage *filledStar = [UIImage imageNamed:@"yellow-star.png"];
        UIImage *imgNFav    = [UIImage imageNamed:@"products-heart-icon.png"];
        UIImage *imgFav     = [UIImage imageNamed:@"heart-icon.png"];
        
        int ratingValue = [self.product.rating intValue];
        
        if (ratingValue <= 20) {
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
        }else if(ratingValue > 20 && ratingValue <= 40 ){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
        }else if(ratingValue > 40 && ratingValue <= 60 ){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar3 setImage:filledStar forState:UIControlStateNormal];
        }else if(ratingValue > 60 && ratingValue <= 80 ){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar3 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar4 setImage:filledStar forState:UIControlStateNormal];
        }else if((ratingValue > 80 && ratingValue <= 100 )){
            [self.btnStar1 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar2 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar3 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar4 setImage:filledStar forState:UIControlStateNormal];
            [self.btnStar5 setImage:filledStar forState:UIControlStateNormal];
        }
        
        if ([self.userFav productPresentInFav:self.product]) {
            [btnFav setImage:imgFav forState:UIControlStateNormal];
        }else{
            [btnFav setImage:imgNFav forState:UIControlStateNormal];
        }
        
        lblName.text       = self.product.name;
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        double price = [self.product.price doubleValue];
        [fmt setPositiveFormat:@"0.##"];
        
        lblPrice.text      = [NSString stringWithFormat:@"$%@", [fmt stringFromNumber:[NSNumber numberWithFloat:price]]];
        
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
            UIButton *btnAddToCart = (UIButton *)[cell.contentView viewWithTag:2];
            
            if(self.productPresentInCart){
                
                [btnAddToCart setTitle:@"Update Cart" forState:UIControlStateNormal];
                
                VPProductModel *cartState = [self.userCart getCartProduct:self.product.id];
                
                if (cartState.cartStrength) {
                    [self.btnDoses setTitle:cartState.cartStrengthValue forState:UIControlStateNormal];
                }
                
            }else{
                [btnAddToCart  setTitle:@"Add to Cart"   forState:UIControlStateNormal];
                [self.btnDoses setTitle:@"Pick Strength" forState:UIControlStateNormal];
            }
            
            tfCounter.text = [NSString stringWithFormat:@"%d", self.product.cartQty];
        }else if (indexPath.section == 2){
            UITextView *tvDescription      = (UITextView *)[cell.contentView viewWithTag:10];
            tvDescription.text             = self.product.desc;
        }else if (indexPath.section >= 3){
            UILabel    *lblReviewTitle     = (UILabel*)[cell.contentView viewWithTag:20];
            UITextView *tvReviewDetail     = (UITextView*)[cell.contentView viewWithTag:21];
            UILabel    *lblReviewRating     = (UILabel*)[cell.contentView viewWithTag:500];
            
            
            
            VPReviewsModel *currentReview = [self.product.reviews objectAtIndex:indexPath.section - 3];
            
            lblReviewTitle.text  = currentReview.titl;
            tvReviewDetail.text  = currentReview.desc;
            lblReviewRating.text = [NSString stringWithFormat:@"Rating (%@/5)", currentReview.rating];
            
            UIButton *reviewBtnStar1 = (UIButton *)[cell.contentView viewWithTag:151];
            UIButton *reviewBtnStar2 = (UIButton *)[cell.contentView viewWithTag:152];
            UIButton *reviewBtnStar3 = (UIButton *)[cell.contentView viewWithTag:153];
            UIButton *reviewBtnStar4 = (UIButton *)[cell.contentView viewWithTag:154];
            UIButton *reviewBtnStar5 = (UIButton *)[cell.contentView viewWithTag:155];
            
            UIImage *filledStar = [UIImage imageNamed:@"yellow-star.png"];
            
            
            int ratingValue = [currentReview.rating intValue];
            
            if (ratingValue == 1) {
                [reviewBtnStar1 setImage:filledStar forState:UIControlStateNormal];
            }else if(ratingValue == 2 ){
                [reviewBtnStar1 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar2 setImage:filledStar forState:UIControlStateNormal];
            }else if(ratingValue == 3 ){
                [reviewBtnStar1 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar2 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar3 setImage:filledStar forState:UIControlStateNormal];
            }else if(ratingValue == 4  ){
                [reviewBtnStar1 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar2 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar3 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar4 setImage:filledStar forState:UIControlStateNormal];
            }else if(ratingValue == 5  ){
                [reviewBtnStar1 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar2 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar3 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar4 setImage:filledStar forState:UIControlStateNormal];
                [reviewBtnStar5 setImage:filledStar forState:UIControlStateNormal];
            }
            
    }
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView;
    if(section == 3){
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor colorWithRed:203/255.0 green:227/255.0 blue:222/255.0 alpha:1];

    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textColor = [UIColor darkGrayColor]; //here you can change the text color of header.
    tempLabel.text = @"Reviews";
    
    [tempView addSubview:tempLabel];
    }
    
    return tempView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *tempView;
        if(section == 3 + [self.product.reviews count] - 1){
        tempView = [[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
        tempView.backgroundColor=[UIColor colorWithRed:203/255.0 green:227/255.0 blue:222/255.0 alpha:1];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(addReview:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Add Review" forState:UIControlStateNormal];
        
        UIImage *newImage = [UIImage imageNamed:@"plus18-button.png"];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
        
        button.frame = CGRectMake(13.0, 10.0, 300, 36.0);
            
            button.translatesAutoresizingMaskIntoConstraints = NO;
           
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                            attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:tempView
                                                                            attribute:NSLayoutAttributeTop
                                                                           multiplier:1.0
                                                                             constant:10];
            NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:tempView
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:10];
            NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:button
                                                                             attribute:NSLayoutAttributeTrailing
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:tempView
                                                                             attribute:NSLayoutAttributeTrailing
                                                                            multiplier:1.0
                                                                              constant:-10];
           
            [tempView addSubview:button];
            [tempView addConstraint:topConstraint];
            [tempView addConstraint:leadConstraint];
            [tempView addConstraint:trailConstraint];
    }
    
    return tempView;
}

#pragma  mark - IBActions

- (IBAction)btnOptions:(id)sender {
    [self showProductStrengthsWithTitle:@"Pick Strength" andProduct:self.product andTargetButton:self.btnDoses];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pick Strength" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    for (NSString *key in self.product.doses) {
//        
//        [alertController addAction:[UIAlertAction actionWithTitle:[self.product.doses objectForKey:key]
//                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                                                                //self.selectedDose = key;
//                                                                self.product.cartStrength = [key intValue];
//                                                                [self.btnDoses  setTitle:[self.product.doses objectForKey:key] forState:UIControlStateNormal];
//                                                            }]];
//        
//    }
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
//                                                        style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                                                            //[self startAnimating];
//                                                            
//                                                            
//                                                        }]];
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        [self presentViewController:alertController animated:YES completion:nil];
//    });
//
}

- (IBAction)btnSubCount:(id)sender {
    self.product.cartQty -= 1;
    if (self.product.cartQty <=0) {
        self.product.cartQty = 1;
    }
    [self.tableView reloadData];
}

- (IBAction)btnAddCount:(id)sender {
    self.product.cartQty += 1;
    [self.tableView reloadData];
}

- (IBAction)addReview:(id)sender{
    if(self.loggedInUser){
     [self performSegueWithIdentifier:@"add_review_segue" sender:self];
    }else{
        [self showLoginPage];
    }
}

- (IBAction)btnBack:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}


- (IBAction)addToCart_pressed:(id)sender {
    [self addToCart:self.product];
    
    [self.tableView reloadData];
}

- (IBAction)btnFavourite_pressed:(id)sender {
    [self addToFavorites:self.product];
    [self.tableView reloadData];
}

#pragma mark - ProductDetails Manager Delegates

- (void)productManager:(VPProductManager *)manager didFetchProductDetails:(VPProductModel *)product{
    self.product = product;
    self.product.cartQty = 1;
    
    [self.productManager fetchProductReviewswithProductId:self.product.id andStoreId:self.storeId];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProductDetails:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
    [self.productManager fetchProductDetailsWithProductId:self.product.id andStoreId:self.currentStore.id];
}

- (void)productManager:(VPProductManager *)manager didFetchProductReviews:(NSArray *)reviews{
    self.product.reviews = reviews;
    [self stopAnimating];
    [self.tableView reloadData];
    //[self.productManager fetchProductImageWithProductId:self.product.id andSessionId:self.sessionId];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProductReviews:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
    [self.productManager fetchProductReviewswithProductId:self.product.id andStoreId:self.storeId];
}

- (void)productManager:(VPProductManager *)manager didFetchProductImage:(NSString *)imgURL{
    self.product.imgUrl = imgURL;
    [self stopAnimating];
    [self.tableView reloadData];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProductImage:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
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


@end
