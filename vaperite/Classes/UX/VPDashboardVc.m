//
//  VPDashboardVc.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPDashboardVc.h"
#import "QuartzCore/QuartzCore.h"
#import "VPProductCollectionViewCell.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "VPTabsUISegmentedControl.h"
#import "VPUserManager.h"
#import "VPUsersModel.h"
#import "VPProductManager.h"
#import "UIImageView+AFNetworking.h"
#import "VPBaseUIButton.h"

#define ORANGE_COLOR        [UIColor colorWithRed:0.921 green:0.411 blue:0.145 alpha:1.0]

@interface VPDashboardVc ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VPUserManagerDelegate, VPProductManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnFeatured;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnRecommended;
@property (weak, nonatomic) IBOutlet VPBaseUIButton *btnAward;

@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) VPUserManager *userManager;
@property (strong, nonatomic) VPProductManager *productManager;
@property (strong, nonatomic) NSArray *products;

- (IBAction)btnLogin_Pressed:(VPBaseUIButton *)btnLogin;
- (IBAction)btnRegister_Pressed:(VPBaseUIButton *)btnRegister;
- (IBAction)btnFeatured_Pressed:(VPBaseUIButton *)btnFeatured;
- (IBAction)btnRecommended_Pressed:(VPBaseUIButton *)btnRecommended;
- (IBAction)btnAward_Pressed:(VPBaseUIButton *)btnAward;

@end

@implementation VPDashboardVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self highlightButton:self.btnFeatured];
    [self unhighlithButton:self.btnRecommended];
    [self unhighlithButton:self.btnAward];
    
    self.btnFeatured.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnRecommended.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnAward.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.btnFeatured.layer.borderWidth = 0.5;
    self.btnRecommended.layer.borderWidth = 0.5;
    self.btnAward.layer.borderWidth = 0.5;
    
    [self configureCollectionView];
    [self fetchProducts];
}

#pragma mark - Private Methods 

- (void)fetchProducts {
    
    if (!self.productManager) {
        self.productManager = [[VPProductManager alloc]init];
        self.productManager.delegate = self;
    }
    [self.productManager fetchProducts];
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

- (void)highlightButton:(VPBaseUIButton *)button {

    button.backgroundColor = ORANGE_COLOR;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)unhighlithButton:(VPBaseUIButton *)button {
    
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:ORANGE_COLOR forState:UIControlStateNormal];
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
    
    [self highlightButton:btnFeatured];
    [self unhighlithButton:self.btnRecommended];
    [self unhighlithButton:self.btnAward];
}

- (IBAction)btnRecommended_Pressed:(VPBaseUIButton *)btnRecommended {
    
    [self highlightButton:btnRecommended];
    [self unhighlithButton:self.btnFeatured];
    [self unhighlithButton:self.btnAward];
}

- (IBAction)btnAward_Pressed:(VPBaseUIButton *)btnAward {
    
    [self highlightButton:btnAward];
    [self unhighlithButton:self.btnFeatured];
    [self unhighlithButton:self.btnRecommended];
    
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    VPProductModel *currentProduct = [self.products objectAtIndex:indexPath.row];
    
    VPProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.contentView.superview setClipsToBounds:NO];
    
    cell.name.text  = currentProduct.name;
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

#pragma mark UICollectionViewDelegateFlowLayout Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    return UIEdgeInsetsMake(-45.0,30.0,60.0,30.0);  // top, left, bottom, right
}

#pragma mark - VPUserManagerDelegate Methods

- (void)userManager:(VPUserManager *)userManager didAuthenticate:(NSDictionary *)response {
    [VPUsersModel saveToSession:response];
    if (!self.productManager) {
        self.productManager = [[VPProductManager alloc]init];
        self.productManager.delegate = self;
    }
    [self.productManager fetchProducts];
    
}

- (void)userManager:(VPUserManager *)userManager didFailToAuthenticate:(NSString *)message{
    
}

#pragma mark - VPProductManagerDelegate Methods

- (void)productManager:(VPProductManager *)manager didFetchProducts:(NSArray *)products {
    
    [self stopAnimating];
    self.products = products;
    [self.collectionView reloadData];

    [self stopAnimating];

}

- (void)productManager:(VPProductManager *)manager didFailToFetchProducts:(NSString *)message{
    [self showError:message];
}

#pragma mark - Memory Cleanup Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
