//
//  VPFavouriesModel.m
//  vaperite
//
//  Created by Apple on 09/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPFavoriteModel.h"
#import "VPProductModel.h"

@implementation VPFavoriteModel

+ (VPFavoriteModel *)currentFav {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"favorites"];
    
    VPFavoriteModel *fav;
    if (data) {
        fav = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        fav = [[VPFavoriteModel alloc]init];
        fav.products = [[NSMutableArray alloc]init];
    }
    return fav;
}

+ (void)clearCurrentFav {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"favorites"];
    [defaults synchronize];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
        self.products  =  [decoder decodeObjectForKey:@"products"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.products forKey:@"products"];
}


- (void)save {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    [defaults setObject:data forKey:@"favorites"];
}

- (BOOL) productPresentInFav:(VPProductModel*)product{
    
    for (VPProductModel* p in self.products) {
        if (p.id == product.id) {
            return true;
        }
    }
    return false;
    
}



@end
