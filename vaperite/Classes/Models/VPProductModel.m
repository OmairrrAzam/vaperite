//
//  VPProductModel.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProductModel.h"
#import "NSDictionary+Helper.h"

@implementation VPProductModel

+ (NSArray *)loadFromArray:(NSArray *)arrProducts {
    NSMutableArray *products = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictProduct in arrProducts) {
        VPProductModel *product = [[VPProductModel alloc] initWithDictionary:dictProduct];
        [products addObject:product];
    }
    
    return products;
}

- (id)initWithDictionary:(NSDictionary *)dictProduct {
    self = [super init];

    self.id                = [dictProduct objectForKeyHandlingNull:@"id"];
    self.sku               = [dictProduct objectForKeyHandlingNull:@"sku"];
    self.imgUrl            = [dictProduct objectForKey:@"thumb"];
    self.set               = [dictProduct objectForKeyHandlingNull:@"set"];
    self.type              = [dictProduct objectForKeyHandlingNull:@"type"];
    self.categoryIds       = [dictProduct objectForKeyHandlingNull:@"categories"];
    self.name              = [dictProduct objectForKeyHandlingNull:@"name"];
    self.price             = [dictProduct objectForKeyHandlingNull:@"pirce"];
    self.desc              = [dictProduct objectForKeyHandlingNull:@"description"];
    self.shortDescription  = [dictProduct objectForKeyHandlingNull:@"short_description"];
    self.rating            = [dictProduct objectForKeyHandlingNull:@"rating"];
    self.stockQty          = [dictProduct objectForKeyHandlingNull:@"qty"];
    return self;
}

- (id)initWithDetailsDictionary:(NSDictionary *)dictProduct {
    self = [super init];
    
    self.id                = [dictProduct objectForKeyHandlingNull:@"product_id"];
    self.imgUrl            = [dictProduct objectForKey:@"image_url"];
    self.name              = [dictProduct objectForKeyHandlingNull:@"name"];
    self.price             = [dictProduct objectForKeyHandlingNull:@"price"];
    self.desc              = [dictProduct objectForKeyHandlingNull:@"description"];
    self.rating            = [dictProduct objectForKeyHandlingNull:@"rating"];
    
    NSDictionary *attributes  = [dictProduct objectForKey:@"product_attributes"];
    
    if (attributes != (NSDictionary*)[NSNull null]) {
        self.doses = [attributes objectForKeyHandlingNull:@"Nicotine Strength"];
    }
    
    
   // NSString *temp = [self.doses object];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.id      = [decoder decodeObjectForKey:@"id"];
        self.imgUrl  = [decoder decodeObjectForKey:@"imgUrl"];
        self.name    = [decoder decodeObjectForKey:@"name"];
        self.price   = [decoder decodeObjectForKey:@"price"];
        self.desc    = [decoder decodeObjectForKey:@"desc"];
        self.rating  = [decoder decodeObjectForKey:@"rating"];
        self.cartQty = [decoder decodeIntForKey:@"qty"];
        self.cartStrength = [decoder decodeIntForKey:@"cart_strength_id"];
        self.cartStrengthValue = [decoder decodeObjectForKey:@"cart_strength_value"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.rating forKey:@"rating"];
    [encoder encodeInt:self.cartQty forKey:@"qty"];
    [encoder encodeInt:self.cartStrength   forKey:@"cart_strength_id"];
    [encoder encodeObject:self.cartStrengthValue forKey:@"cart_strength_value"];
}

//- (NSDictionary *)toDictionary {
//    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//   
//    [dictionary setObject:self.id forKey:@"company_name"];
//    [dictionary setObject:self.firstName forKey:@"first_name"];
//        return outerDictionary;
//}


@end
