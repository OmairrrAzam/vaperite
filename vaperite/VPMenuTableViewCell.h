//
//  VPMenuTableViewCell.h
//  vaperite
//
//  Created by Apple on 05/07/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPBaseTableViewCell.h"

@interface VPMenuTableViewCell : VPBaseTableViewCell

@property (weak, nonatomic)  NSDictionary *menuItem;
@property (weak, nonatomic) IBOutlet UIImageView *ivDropDown;
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

-(void)configure;
@end
