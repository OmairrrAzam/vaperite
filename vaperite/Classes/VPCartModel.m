//
//  VPCartModel.m
//  vaperite
//
//  Created by Apple on 09/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPCartModel.h"
#import "VPProductModel.h"

@implementation VPCartModel

+ (VPCartModel *)currentCart {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"cart"];
    
    VPCartModel *cart;
    if (data) {
        cart = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        cart = [[VPCartModel alloc]init];
        cart.products = [[NSMutableArray alloc]init];
    }
    return cart;
}

+ (void)clearCurrentCart {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"cart"];
    [defaults synchronize];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.products  =  [decoder decodeObjectForKey:@"products"];
        self.total     =  [decoder decodeFloatForKey:@"total"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.products forKey:@"products"];
    [encoder encodeFloat:self.total forKey:@"total"];
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:@"cart"];
}

- (BOOL) productPresentInCart:(VPProductModel*)product{
    
    for (VPProductModel* p in self.products) {
        if ([p.id isEqualToString:product.id]) {
            return true;
        }
    }
    return false;
    
}

- (BOOL) updateProductInCart:(VPProductModel*)product{
    
    for (VPProductModel* p in self.products) {
        if ([p.id isEqualToString:product.id]) {
            if (product.cartQty <=0) {
                product.cartQty = 1;
            }
            p.cartQty = product.cartQty;
            [self save];
            return true;
        }
    }
    return false;
}

- (BOOL) addProductInCart:(VPProductModel*)selectedProduct{
    if (selectedProduct.cartQty <= 0) {
        selectedProduct.cartQty = 1;
    }
    [self.products addObject:selectedProduct];
    [self save];

    return true;
}


- (void) updateCalculations{
    
    self.total = 0;
    
    for (VPProductModel* p in self.products) {
        NSString *priceStr = [p.price stringByReplacingOccurrencesOfString:@"$" withString:@""];
        float priceFloat = (float)[priceStr floatValue];
        self.total += priceFloat * p.cartQty;
            
    }

    [self save];
}

- (VPProductModel*) getCartProduct:(NSString*)productId{
    VPProductModel *foundProduct;
    for (VPProductModel* p in self.products) {
        if ([p.id isEqualToString:productId]) {
            foundProduct = p;
            
        }
    }
    return foundProduct;
}


@end
