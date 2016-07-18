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
@interface VPDashboardVc ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VPUserManagerDelegate, VPProductManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet VPTabsUISegmentedControl *pageTabs;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) VPUserManager *userManager;
@property (strong, nonatomic) VPProductManager *productManager;
@property (strong, nonatomic) NSArray *products;

@end



@implementation VPDashboardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (!self.userManager) {
//        self.userManager = [[VPUserManager alloc]init];
//        self.userManager.delegate = self;
//    }
//   [self.userManager authenticate];
    
    if (!self.productManager) {
        self.productManager = [[VPProductManager alloc]init];
        self.productManager.delegate = self;
    }
    
    [self.productManager fetchProducts];

    
       // [self.collectionView registerClass:[CellClass class] forCellWithReuseIdentifier:@"Cell"];
    //self.collectionView.backgroundColor = [UIColor clearColor];
    
    // Configure layout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //[self.flowLayout setItemSize:CGSizeMake(100, 100)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //self.flowLayout.minimumInteritemSpacing = 0.0f;
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:YES];
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.borderColor = [UIColor colorWithRed:203 green:226 blue:221 alpha:1].CGColor;
    
//    // TAbs styling
//    
   // NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.pageTabs
//                                                                  attribute:NSLayoutAttributeHeight
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:nil
//                                                                  attribute:NSLayoutAttributeNotAnAttribute
//                                                                 multiplier:1
//                                                                   constant:46];
//    [self.pageTabs addConstraint:constraint];
//    //[[UISegmentedControl appearance] setBackgroundColor:[UIColor colorWithRed:98/255.0 green:99/255.0 blue:100/255.0 alpha:1]];
//    
//    
//    self.pageTabs.tintColor = [UIColor  colorWithRed:254/255.0 green:116/255.0 blue:12/255.0 alpha:1];
//    
//    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIColor blackColor], NSForegroundColorAttributeName,
//                                nil];
//    [self.pageTabs setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [self.pageTabs setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
//    
//    [self.pageTabs setWidth:80.0 forSegmentAtIndex:0];
//    [self.pageTabs setWidth:80.0 forSegmentAtIndex:1];
//    [self.pageTabs setWidth:80.0 forSegmentAtIndex:2];
//    
//    self.pageTabs.layer.cornerRadius = 15.0;
//    self.pageTabs.layer.borderColor = [UIColor grayColor].CGColor;
//    self.pageTabs.layer.borderWidth = 1.0f;
//    self.pageTabs.layer.masksToBounds = YES;
    
    
    
    
//    NSArray *items = @[@"Features", @"Recommended", @"Award"];
//    VPTabsUISegmentedControl *tabsControl = [[VPTabsUISegmentedControl alloc] initWithItems:items];
//    
//    
//    tabsControl.frame =  CGRectMake(15, 200, self.mainView.bounds.size.width-25.0, 35);
//    tabsControl.selectedSegmentIndex = 0;
//    //tabsControl.tintColor = [UIColor  colorWithRed:254/255.0 green:116/255.0 blue:12/255.0 alpha:1];
//    //tabsControl.tintColor = [UIColor yellowColor];
//    //[tabscontrol setBackgroundImage:[UIColor clearColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    //[tabsControl setWidth:tabsControl.bounds.size.width/3 forSegmentAtIndex:0];
//    //[tabsControl setWidth:tabsControl.bounds.size.width/3 - 20  forSegmentAtIndex:1];
//    //[tabsControl setWidth:tabsControl.bounds.size.width/3 forSegmentAtIndex:2];
//
//    //[[[tabsControl subviews] objectAtIndex:0] setTintColor:[UIColor redColor]];
//    //[[[tabsControl subviews] objectAtIndex:0] sel];
//    //tabsControl.tintColor = [UIColor  clearColor];
//    tabsControl.backgroundColor = [UIColor clearColor];
//    [self.mainView addSubview:tabsControl];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    VPProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.contentView.superview setClipsToBounds:NO];
    
    // cell data binding
    
    
    VPProductModel *currentProduct          = [self.products objectAtIndex:indexPath.row];
    
    cell.name.text  = currentProduct.name;
    cell.price.text = [NSString stringWithFormat:@"$%@", currentProduct.price];
    NSString *urlString = currentProduct.imgUrl;
    
    BOOL isStaging = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"STAGING"] boolValue];
    
    if (!isStaging) {
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
    
    //cell decoration
    cell.backgroundView                     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    cell.contentView.layer.backgroundColor  = [UIColor whiteColor].CGColor;
    cell.contentView.layer.cornerRadius     = 8.0f;
    cell.productImage.layer.cornerRadius    = 8.0f;
    cell.productImage.clipsToBounds         = YES;
    //cell.contentView.layer.masksToBounds = YES;
    
    return cell;
}

#pragma mark Collection view layout things
// Layout: Set cell size
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

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(-45.0,30.0,60.0,30.0);  // top, left, bottom, right
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tabChanged:(id)sender {
    
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
- (void)productManager:(VPProductManager *)manager didFetchProducts:(NSArray *)products{
    self.products = products;
    [self.collectionView reloadData];
    [self stopAnimating];
}

- (void)productManager:(VPProductManager *)manager didFailToFetchProducts:(NSString *)message{
    [self showError:message];
}

@end
