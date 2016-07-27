//
//  VPProductCollectionViewCell.h
//  vaperite
//
//  Created by Apple on 29/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseCollectionViewCell.h"
#import "VPProductModel.h"

@interface VPProductCollectionViewCell : VPBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;


@end
