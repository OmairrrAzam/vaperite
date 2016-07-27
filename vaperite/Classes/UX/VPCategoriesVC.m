//
//  VPCategoriesVC.m
//  vaperite
//
//  Created by Apple on 25/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPCategoriesVC.h"

@interface VPCategoriesVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation VPCategoriesVC
NSMutableArray *categoriesArray;
NSMutableArray *categoriesImgArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    categoriesArray = [NSMutableArray arrayWithObjects:@"THE G.O.A.T E-Liquid",
                                                       @"PREMIUM LIQUID",
                                                       @"HIPSTER VAPE CO",@"COIL REPLACEMENTS",nil];
    
    categoriesImgArray = [NSMutableArray arrayWithObjects:@"the-g.o.a",
                       @"premium-liquid",
                       @"hipster-vape-co",@"coil-replacements",nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [categoriesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier ];
    }
    
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:20];
    lblName.text = [NSString stringWithFormat:@"%@", [categoriesArray objectAtIndex:indexPath.section ]];
    
    UIImage *bgImage = [UIImage imageNamed:[categoriesImgArray objectAtIndex:indexPath.section]];
    UIImageView *bgCategory = (UIImageView *)[cell.contentView viewWithTag:21];
    bgCategory.image = bgImage;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"categoryProductView" sender:self];
}



@end
