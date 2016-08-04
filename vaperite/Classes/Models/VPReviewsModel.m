//
//  VPReviewsModel.m
//  vaperite
//
//  Created by Apple on 01/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPReviewsModel.h"

@interface VPReviewsModel ()

@end

@implementation VPReviewsModel

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (NSArray *)loadFromArray:(NSArray *)arrReviews {
    NSMutableArray *reviews = [[NSMutableArray alloc] init];
    for (NSDictionary *dictReview in arrReviews) {
        VPReviewsModel *review = [[VPReviewsModel alloc] initWithDictionary:dictReview];
        [reviews addObject:review];
    }
    return reviews;
}

- (id)initWithDictionary:(NSDictionary *)dictReview {
    self = [super init];
    self.titl =  [dictReview objectForKey:@"title"] ;
    self.desc =  [dictReview objectForKey:@"detail"];
    return self;
}

@end
