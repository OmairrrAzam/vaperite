//
//  VPDashboardProductsVC.m
//  vaperite
//
//  Created by Apple on 19/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPDashboardProductsVC.h"
#import "VPProductManager.h"
#import "VPProductModel.h"
#import "VPProductCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface VPDashboardProductsVC ()<UIActionSheetDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VPProductManagerDelegate>
@property (strong, nonatomic) VPProductManager *productManager;
@property (strong, nonatomic) NSArray *products;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation VPDashboardProductsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchProducts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)fetchProducts {
    [self startAnimating];
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
    return UIEdgeInsetsMake(10.0,30.0,60.0,30.0);  // top, left, bottom, right
}


#pragma mark - VPProductManagerDelegate Methods

- (void)productManager:(VPProductManager *)manager didFetchProducts:(NSArray *)products {
    
    [self stopAnimating];
    self.products = products;
    [self.collectionView reloadData];
    
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProducts:(NSString *)message{
    [self showError:message];
}

#pragma mark - IBOutlet Actions

- (IBAction)btnSearch:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Categories" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Category1" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //[self startAnimating];
        [self fetchProducts];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Category2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self fetchProducts];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Category3" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self fetchProducts];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
