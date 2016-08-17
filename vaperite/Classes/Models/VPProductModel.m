//
//  VPProductModel.m
//  vaperite
//
//  Created by Apple on 27/06/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProductModel.h"
#import "NSDictionary+Helper.h"
#import "VPProductOptionsModel.h"

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
    self.inStock           = [dictProduct objectForKeyHandlingNull:@"in_stock"];
        
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
    self.inStock           = [dictProduct objectForKeyHandlingNull:@"in_stock"];
    self.options           = [[NSMutableArray alloc]init];
    
    NSDictionary *attributes         = [dictProduct objectForKey:@"product_attributes"];
    NSDictionary *custom_attributes  = [dictProduct objectForKey:@"product_custom_options"];
    
    if(attributes != (NSDictionary*)[NSNull null]){
        
     
     for (NSString *key in attributes) {
        NSString *optionKey = [attributes objectForKey:key];
        
        if([optionKey isKindOfClass:[NSString class]])
        {
             NSDictionary *optionValue = [attributes objectForKey:optionKey];
            
            VPProductOptionsModel *option = [[VPProductOptionsModel alloc]init];
            option.values = optionValue;
            option.id = key;
            option.title = optionKey;
            option.type = @"default";
            [self.options addObject:option];
            
        }
        
    }
    }
    
    //for custom options
    if(custom_attributes != (NSDictionary*)[NSNull null]){

        for (NSString *key in custom_attributes) {
            NSString *optionKey = [custom_attributes objectForKey:key];
            
            if([optionKey isKindOfClass:[NSString class]])
            {
                NSDictionary *optionValue = [custom_attributes objectForKey:optionKey];
                
                if(optionValue != (NSDictionary*)[NSNull null]){
                VPProductOptionsModel *option = [[VPProductOptionsModel alloc]init];
                option.values = optionValue;
                option.id = key;
                option.title = optionKey;
                option.type = @"custom";
                [self.options addObject:option];
                }
                
            }
            
        }
    }


//    if (attributes != (NSDictionary*)[NSNull null]) {
//        self.doses = [attributes objectForKeyHandlingNull:@"Nicotine Strength"];
//    }
    
    
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
        self.cartStrength      = [decoder decodeIntForKey:@"cart_strength_id"];
        self.cartStrengthValue = [decoder decodeObjectForKey:@"cart_strength_value"];
        self.options  = [decoder decodeObjectForKey:@"options"];
        self.inStock  = [decoder decodeObjectForKey:@"in_stock"];
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
    [encoder encodeObject:self.options forKey:@"options"];
    [encoder encodeObject:self.inStock forKey:@"in_stock"];
}

- (int)validateForCart{
    if ([self.options count] > 0) {
        int count = 0;
        for (VPProductOptionsModel *option in self.options) {
            if (!option.pickedId) {
                return count ;
            }
            count++;
        }
    }
    
    return -1;
}

@end
