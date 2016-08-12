//
//  VPProductsVC.m
//  vaperite
//
//  Created by Apple on 25/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProductsVC.h"
#import "VPProductModel.h"
#import "VPProductDetailsVC.h"
#import "VPProductManager.h"
#import "UIImageView+AFNetworking.h"
#import "VPCartModel.h"
#import "VPFavoriteModel.h"


@interface VPProductsVC ()<UITableViewDataSource, UITableViewDelegate, VPProductManagerDelegate>


@property (strong, nonatomic) VPProductModel *selectedProduct;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) VPProductManager *productManager;
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
@property (weak, nonatomic)   IBOutlet UIView *ivContainer;

- (IBAction)btnAddFav:(id)sender;
- (IBAction)btnAddCart:(id)sender;
- (IBAction)btnBack_Pressed:(id)sender;




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
    
    if (!self.productManager) {
        self.productManager = [[VPProductManager alloc]init];
        self.productManager.delegate = self;
    }
    
    
        //[self.productManager fetchProductsFromCategoryId:self.categoryId];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.productManager fetchProductsFromCategoryId:self.categoryId];
    self.userCart = [VPCartModel currentCart];
    self.userFav  = [VPFavoriteModel currentFav];
    [self startAnimating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.products count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VPProductModel *currentProduct = [self.products objectAtIndex:indexPath.section];
    static NSString *cellIdentifier = @"productViewCell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIView *ivContainer      = (UIView *)[cell.contentView viewWithTag:33];
    UILabel *productName     = (UILabel *)[cell.contentView viewWithTag:30];
    UILabel *productPrice    = (UILabel *)[cell.contentView viewWithTag:31];
    UIImageView *productImgV = (UIImageView*)[cell.contentView viewWithTag:32];
    
    productImgV.layer.cornerRadius = 38.0f;
    productImgV.clipsToBounds      = YES;
    
    
    ivContainer.layer.cornerRadius = 15.0f;
    
    
    productName.text  = currentProduct.name;
    productPrice.text = currentProduct.price;
    
    NSURL *url = [NSURL URLWithString: currentProduct.imgUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak UIImageView *weakImg = productImgV;
    [weakImg setImageWithURLRequest:request
                   placeholderImage:nil
                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                productImgV.image = image;
                                [weakImg setNeedsLayout];
                                
                            } failure:nil];    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedProduct = [self.products objectAtIndex:indexPath.section];
    
    [self performSegueWithIdentifier:@"product_details" sender:self];
}

#pragma mark - Segue Callbacks

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"product_details"]) {

        VPProductDetailsVC *productDetailVC = [segue destinationViewController];
        
        productDetailVC.product = self.selectedProduct;
        
    }
}


#pragma mark - IBActions

- (IBAction)btnAddFav:(id)sender {
    
    CGPoint buttonPosition          = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath          = [self.tableView indexPathForRowAtPoint:buttonPosition];
    VPProductModel *selectedProduct = [self.products objectAtIndex:indexPath.section];
   
    [self addToFavorites:selectedProduct];
    [self.tableView reloadData];
}

- (IBAction)btnAddCart:(id)sender {
    
    CGPoint buttonPosition  = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath  = [self.tableView indexPathForRowAtPoint:buttonPosition];
    VPProductModel *product = [self.products objectAtIndex:indexPath.section];
    [self addToCart:product];
    [self.tableView reloadData];
}

- (IBAction)btnBack_Pressed:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark - VPProductManager Delegate
- (void)productManager:(VPProductManager *)manager didFetchProductsFromCategoryId:(NSArray *)products{
    [self stopAnimating];
    self.products = products;
    
    if ([self.products count] == 0) {
        [self startAnimatingWithCustomMsg:@"No Products Found"];
    }
    
    [self.tableView reloadData];
    
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProductsFromCategoryId:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
}


@end
