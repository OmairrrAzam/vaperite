//
//  VPRightMenuVC.m
//  vaperite
//
//  Created by Apple on 20/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPRightMenuVC.h"
#import "VPSliderMenuVC.h"
#import "VPCartModel.h"
#import "VPProductModel.h"
#import "UIImageView+AFNetworking.h"

@interface VPRightMenuVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)  NSMutableArray *products;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckout;
@property (strong, nonatomic)  VPCartModel *currentCart;
@property (weak, nonatomic) IBOutlet UIButton *btnMoreShopping;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblCartSubTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblCartItem;


- (IBAction)btnDismiss:(id)sender;
- (IBAction)btnRemoveProduct:(id)sender;
- (IBAction)btnCheckout_pressed:(id)sender;
- (IBAction)btnMoreShopping_pressed:(id)sender;
- (IBAction)btnProductQtyDec:(id)sender;
- (IBAction)btnProductQtyInc:(id)sender;
- (IBAction)btnMoreShopping:(id)sender;


@end

@implementation VPRightMenuVC
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initFromMemory];
    
    self.btnMoreShopping.layer.borderColor = [UIColor grayColor].CGColor;
    self.btnCheckout.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.btnMoreShopping.layer.borderWidth = 1.0;
    self.btnCheckout.layer.borderWidth = 1.0;
    //testProducts  = [[NSMutableArray alloc]initWithObjects:@"first", @"second",@"third", @"fourth", nil ];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.products count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
//    if (indexPath.section == 0){
//        cellIdentifier = @"cartHeader";
//        
//    }else if (indexPath.section == 1){
        cellIdentifier = @"rightMenuProductCell";
//    }else{
//        cellIdentifier = @"rightMenuCell";
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ];
    }
    
    //if (indexPath.section == 1){
        UILabel *productName    = (UILabel *)[cell.contentView viewWithTag:10];
         UILabel *price         = (UILabel *)[cell.contentView viewWithTag:11];
         UILabel *qty           = (UILabel *)[cell.contentView viewWithTag:12];
         UIImageView *ivPicture = (UIImageView *)[cell.contentView viewWithTag:13];
        
        VPProductModel *currentProduct = [self.products objectAtIndex:indexPath.row];

        
        NSURL *url = [NSURL URLWithString: currentProduct.imgUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        __weak UIImageView *weakImg = ivPicture;
        [weakImg setImageWithURLRequest:request
                       placeholderImage:nil
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    ivPicture.image = image;
                                    [weakImg setNeedsLayout];
                                    
                                } failure:nil];
        
        productName.text     = currentProduct.name;
        price.text           = [NSString stringWithFormat:@"Price: %@",currentProduct.price];
        qty.text             = [NSString stringWithFormat:@"%d",   currentProduct.cartQty];
        
    //}
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Private Methods

- (void)initFromMemory{
    self.currentCart = [VPCartModel currentCart];
    self.products    = self.currentCart.products;
    [self.currentCart updateCalculations];
    self.lblCartItem.text     = [NSString stringWithFormat:@"Item(%d) $%.02f",(int)[self.currentCart.products count],self.currentCart.total];
    self.lblCartSubTotal.text = [NSString stringWithFormat:@"Cart sub Total : $%.02f",self.currentCart.total];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0){
//        return 0;
//    }else if(section == 1){
//        return 3;
//    }
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 0;
}

#pragma mark - IBActions

- (IBAction)btnDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnRemoveProduct:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    [self.products removeObjectAtIndex:indexPath.row];
    self.currentCart.products = self.products;
    [self.currentCart save];
    [self startAnimatingWithSuccessMsg:@"Item Removed from cart"];
    [self initFromMemory];
    [self.tableView reloadData];
}

- (IBAction)btnCheckout_pressed:(id)sender {
}

- (IBAction)btnMoreShopping_pressed:(id)sender {
}

- (IBAction)btnProductQtyDec:(id)sender {
    
    CGPoint buttonPosition          = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath          = [self.tableView indexPathForRowAtPoint:buttonPosition];
    VPProductModel *selectedProduct = [self.products objectAtIndex:indexPath.row];
    selectedProduct.cartQty -= 1;
    
    [self.currentCart updateProductInCart:selectedProduct];
    [self initFromMemory];
    [self.tableView reloadData];
}

- (IBAction)btnProductQtyInc:(id)sender {
    CGPoint buttonPosition          = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath          = [self.tableView indexPathForRowAtPoint:buttonPosition];
    VPProductModel *selectedProduct = [self.products objectAtIndex:indexPath.row];
    selectedProduct.cartQty += 1;
    [self.currentCart updateProductInCart:selectedProduct];
    [self initFromMemory];
    [self.tableView reloadData];
}

- (IBAction)btnMoreShopping:(id)sender {
    [self dismissMe];
    [self changeViewThroughSlider:@"Dashboard"];
}


@end
