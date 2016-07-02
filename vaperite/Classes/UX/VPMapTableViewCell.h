//
//  VPMapTableViewCell.h
//  vaperite
//
//  Created by Apple on 02/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseTableViewCell.h"

@interface VPMapTableViewCell : VPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgMap;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNo;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@end
