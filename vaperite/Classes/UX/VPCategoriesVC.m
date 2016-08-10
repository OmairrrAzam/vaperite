//
//  VPCategoriesVC.m
//  vaperite
//
//  Created by Apple on 25/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPCategoriesVC.h"
#import "VPCategoryManager.h"
#import "VPCategoryModel.h"
#import "VPProductsVC.h"
#import "VPCategoryModel.h"

@interface VPCategoriesVC ()<UITableViewDelegate, UITableViewDataSource, VPCategoryManagerDelegate>
@property (strong, nonatomic) VPCategoryManager *categoryManager;
@property (strong, nonatomic) VPCategoryModel *selectedCategory;
@property (strong, nonatomic) NSArray *allSubCategories;
@property (strong, nonatomic)IBOutlet UITableView *tableview;
@end

@implementation VPCategoriesVC
NSMutableArray *categoriesArray;
NSMutableArray *categoriesImgArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startAnimating];
    categoriesArray = [NSMutableArray arrayWithObjects:@"THE G.O.A.T E-Liquid",
                                                       @"PREMIUM LIQUID",
                                                       @"HIPSTER VAPE CO",@"COIL REPLACEMENTS",nil];
    
    categoriesImgArray = [NSMutableArray arrayWithObjects:@"the-g.o.a",
                       @"premium-liquid",
                       @"hipster-vape-co",@"coil-replacements",nil];
    
    if (!self.categoryManager) {
        self.categoryManager = [[VPCategoryManager alloc]init];
        self.categoryManager.delegate = self;
    }
    
    [self.categoryManager loadCategoriesByParentId:self.parentId sessionId:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allSubCategories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VPCategoryModel *selectedCategory = [self.allSubCategories objectAtIndex:indexPath.section];
    static NSString *cellIdentifier = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ];
    }
    
    
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:20];
    lblName.text = [NSString stringWithFormat:@"%@", selectedCategory.name];
    
    UIImage *bgImage = [UIImage imageNamed:[categoriesImgArray objectAtIndex:0]];
    UIImageView *bgCategory = (UIImageView *)[cell.contentView viewWithTag:21];
    bgCategory.image = bgImage;

    return cell;
}

#pragma mark - VPCategoryDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedCategory = [self.allSubCategories objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:@"categoryProductView" sender:self];
}

- (void)categoryManager:(VPCategoryManager *)categoryManager didLoadCategoriesFromParentId:(NSArray *)categories{
    self.allSubCategories = categories;
    [self stopAnimating];
    [self.tableview reloadData];
    
}

- (void)categoryManager:(VPCategoryManager *)categoryManager didFailToLoadCategoriesFromParentId:(NSString *)message{
    [self startAnimatingWithErrorMsg:message];
    
}

#pragma mark - Segue Callbacks

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"categoryProductView"]) {
        VPProductsVC *productsVC = [segue destinationViewController];
        productsVC.categoryId    =  self.selectedCategory.id;
    }
}


@end
