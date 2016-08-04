//
//  VPDashboardVc.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPDashboardVc.h"
#import "QuartzCore/QuartzCore.h"

#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "VPTabsUISegmentedControl.h"
#import "VPUserManager.h"
#import "VPUsersModel.h"
#import "VPDashboardProductsVC.h"
#import "VPProductManager.h"
#import "VPBaseUIButton.h"
#import "VPProductCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "VPProductDetailsVC.h"
#import "VPCategoryManager.h"
#import "VPCategoryModel.h"
#import "VPBaseNavigationController.h"
#import "VPCategoriesVC.h"

#define ORANGE_COLOR        [UIColor colorWithRed:0.921 green:0.411 blue:0.145 alpha:1.0]

@interface VPDashboardVc ()< VPUserManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VPProductManagerDelegate,VPCategoryManagerDelegate>


@property (strong, nonatomic) VPUserManager *userManager;

@property (weak, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) VPProductModel *selectedProduct;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSArray *allCategories;
@property (strong, nonatomic) VPProductManager *productManager;
@property (strong, nonatomic) VPCategoryManager *categoryManager;
@property (strong, nonatomic) NSString *selectedTab;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnFeatured;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnRecommended;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnAward;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin;
- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister;
- (IBAction)btnFeatured_Pressed:(VPBaseUIButton *)btnFeatured;
- (IBAction)btnRecommended_Pressed:(VPBaseUIButton *)btnRecommended;
- (IBAction)btnAward_Pressed:(VPBaseUIButton *)btnAward;


@end

@implementation VPDashboardVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.selectedTab = @"featured";
    self.productType = @"featured";
    
    
    if (!self.categoryManager) {
        self.categoryManager = [[VPCategoryManager alloc]init];
        self.categoryManager.delegate = self;
    }
    
    
    //[self fetchProducts];
    
   
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchProducts];
}

- (void)fetchProducts {
    [self startAnimating];
    
    
    if (!self.productManager) {
        self.productManager = [[VPProductManager alloc]init];
        self.productManager.delegate = self;
    }
    
    if ([self.productType isEqualToString:@"featured"]){
        [self.productManager fetchFeaturedProductsWithSessionId:self.sessionId];
    }
    else if([self.productType isEqualToString:@"recommended"]){
        [self.productManager fetchRecommendedProductsWithSessionId:self.sessionId];
    }else{
        //productType will contain id of parent category
        //if it is directed from there.
        [self.productManager fetchProductsFromCategoryId:self.productType ];
    }
    
}

- (void)fetchRecommendedProducts {
    [self startAnimating];
    if (!self.productManager) {
        self.productManager = [[VPProductManager alloc]init];
        self.productManager.delegate = self;
    }
    [self.productManager fetchFeaturedProductsWithSessionId:self.sessionId];
}

#pragma mark - Private Methods 

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    // TODO: Set the starting state of your constraints here
    [newViewController.view layoutIfNeeded];
    
    // TODO: Set the ending state of your constraints here
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         // only need to call layoutIfNeeded here
                         [newViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}

- (void)updateTabsColors{
    
    if ([self.selectedTab isEqualToString:@"featured"]){
        [self highlightButton:self.btnFeatured];
        [self unhighlithButton:self.btnRecommended];
        [self unhighlithButton:self.btnAward];
    }else if([self.selectedTab isEqualToString:@"recommended"]){
        [self highlightButton:self.btnRecommended];
        [self unhighlithButton:self.btnFeatured];
        [self unhighlithButton:self.btnAward];

    }else if([self.selectedTab isEqualToString:@"award"]){
        [self highlightButton:self.btnAward];
        [self unhighlithButton:self.btnRecommended];
        [self unhighlithButton:self.btnFeatured];

    }
}
- (void)highlightButton:(VPBaseUIButton *)button {
    
    button.backgroundColor = ORANGE_COLOR;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)unhighlithButton:(VPBaseUIButton *)button {
    
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:ORANGE_COLOR forState:UIControlStateNormal];
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

#pragma mark - IBActions

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin {
    
    UINavigationController *loginNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_NAVIGATOR"];
    loginNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginNavigator animated:YES completion:nil];
}

- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister {
    
    UINavigationController *registerNavigator = [self.storyboard instantiateViewControllerWithIdentifier:@"REGISTER_NAVIGATOR"];
    registerNavigator.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerNavigator animated:YES completion:nil];
}

- (IBAction)btnFeatured_Pressed:(VPBaseUIButton *)btnFeatured {
    self.selectedTab = @"featured";
    self.productType = @"featured";
    [self updateTabsColors];
    [self fetchProducts];
}

- (IBAction)btnRecommended_Pressed:(VPBaseUIButton *)btnRecommended {
    self.selectedTab = @"recommended";
    self.productType = @"recommended";
    [self updateTabsColors];
    [self fetchProducts];
}

- (IBAction)btnAward_Pressed:(VPBaseUIButton *)btnAward {
    self.selectedTab = @"award";
    [self updateTabsColors];
    [self.tableView reloadData];
}

- (IBAction)btnSearch:(id)sender {
    [self startAnimating];
    [self.categoryManager loadCategoriesWithSessionId:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 20;
    if (indexPath.row == 0) {
        height = 120;
//        if (self.loggedInUser) {
//            height = 0;
//        }else{
//            height = 120;
//        }
    }else if(indexPath.row == 1){
        height = 100;
    }else if (indexPath.row == 2){
        if (self.loggedInUser){
            height = 600;
        }else{
            height = 300;
        }
    }
    return height;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 3;
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    
    if (indexPath.row == 0) {
        cellIdentifier = @"dashboard_cell";
    }else if(indexPath.row == 1){
        cellIdentifier = @"dashboard_tabs";
        
        
    }else if(indexPath.row == 2){
        if ([self.selectedTab isEqualToString:@"featured"] || [self.selectedTab isEqualToString:@"recommended"]) {
            cellIdentifier = @"dashboard_products";
        }else{
            cellIdentifier = @"dashboard_award";
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 1){
        self.btnFeatured    = (VPBaseUIButton*)[cell viewWithTag:1];
        self.btnRecommended = (VPBaseUIButton*)[cell viewWithTag:2];
        self.btnAward       = (VPBaseUIButton*)[cell viewWithTag:3];
        
        self.btnFeatured.layer.borderColor    = [UIColor lightGrayColor].CGColor;
        self.btnRecommended.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btnAward.layer.borderColor       = [UIColor lightGrayColor].CGColor;
        
        self.btnFeatured.layer.borderWidth    = 0.5;
        self.btnRecommended.layer.borderWidth = 0.5;
        self.btnAward.layer.borderWidth       = 0.5;
        
        
        [self updateTabsColors];
        
    }
    else if (indexPath.row == 2){
        if ([self.selectedTab isEqualToString:@"featured"] || [self.selectedTab isEqualToString:@"recommended"]) {
             UICollectionView *productCollectionView=(UICollectionView *)[cell viewWithTag:10];
            [productCollectionView reloadData];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)configureCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:YES];
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.borderColor = [UIColor colorWithRed:203 green:226 blue:221 alpha:1].CGColor;
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.products count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    VPProductModel *currentProduct = [self.products objectAtIndex:indexPath.row];
    
    VPProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.contentView.superview setClipsToBounds:NO];
    
    cell.name.text  = currentProduct.sku;
    cell.price.text = [NSString stringWithFormat:@"$%@", currentProduct.price];
    
    NSString *urlString = currentProduct.imgUrl;
    if (!self.isStaging) {
        urlString = [urlString stringByReplacingOccurrencesOfString:@"https://"
                                                         withString:@"http://"];
    }
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak VPProductCollectionViewCell *weakCell = cell;
    [cell.productImage setImageWithURLRequest:request
                             placeholderImage:placeholderImage
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          
                                          weakCell.productImage.image = image;
                                          [weakCell setNeedsLayout];
                                          
                                      } failure:nil];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    cell.contentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    cell.contentView.layer.cornerRadius = 8.0f;
    cell.productImage.layer.cornerRadius = 8.0f;
    cell.productImage.clipsToBounds = YES;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blueColor]; // highlight selection
    self.selectedProduct = [self.products objectAtIndex:[indexPath row]];
    
    [self performSegueWithIdentifier:@"product_detail_segue" sender:self];
    
}

#pragma mark UICollectionViewDelegateFlowLayout Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize mElementSize = CGSizeMake(125, 180);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0,30.0,0.0,30.0);  // top, left, bottom, right
}


#pragma mark - VPProductManagerDelegate Methods

- (void)productManager:(VPProductManager *)manager didFetchFeaturedProducts:(NSArray *)products {
    [self stopAnimating];
    self.products = products;
    [self.tableView reloadData];
    
}

- (void)productManager:(VPProductManager *)manager didFailToFetchFeaturedProducts:(NSString *)message{
    //[self showError:message];
}

- (void)productManager:(VPProductManager *)manager didFetchRecommendedProducts:(NSArray *)products{
    [self stopAnimating];
    self.products = products;
    [self.tableView reloadData];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchRecommendedProducts:(NSString *)message{
    
}

- (void)productManager:(VPProductManager *)manager didFetchProductsFromCategoryId:(NSArray *)products{
    
}
- (void)productManager:(VPProductManager *)manager didFailToFetchProductsFromCategoryId:(NSString *)message{
    
}


#pragma mark - VPUserManagerDelegate Methods

- (void)userManager:(VPUserManager *)userManager didAuthenticate:(NSDictionary *)response {
   
}

- (void)userManager:(VPUserManager *)userManager didFailToAuthenticate:(NSString *)message{
    
}

#pragma mark - VPCategoryManagerDelegate Methods

- (void)categoryManager:(VPCategoryManager *)categoryManager didLoadCategories:(NSArray *)categories{
    
    [self stopAnimating];
    self.allCategories = categories;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Categories" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
   
    for (VPCategoryModel *category in self.allCategories) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:category.name
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        VPBaseNavigationController *nav = (VPBaseNavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Categories"];
        VPCategoriesVC *rootController =(VPCategoriesVC *)[nav.viewControllers objectAtIndex: 0];
        rootController.parentId = category.id;
        self.slidingViewController.topViewController = nav;
        [self.slidingViewController resetTopViewAnimated:YES];
            
        }]];
        
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                                            //[self startAnimating];
                                                            
                                                        }]];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

- (void)categoryManager:(VPCategoryManager *)categoryManager didFailToLoadCategories:(NSString *)message{
    
}

#pragma mark - Segue Callbacks

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"product_detail_segue"]) {
        VPProductDetailsVC *productDetailVC = [segue destinationViewController];
        productDetailVC.product = self.selectedProduct;
    }
}


#pragma mark - Memory Cleanup Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
