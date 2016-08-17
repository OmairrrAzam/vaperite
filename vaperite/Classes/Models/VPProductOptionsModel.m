//
//  VPProductOptionsModel.m
//  vaperite
//
//  Created by Apple on 17/08/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "VPProductOptionsModel.h"
#import "NSDictionary+Helper.h"

@implementation VPProductOptionsModel

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    self.values = dict;
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.id        = [decoder decodeObjectForKey:@"id"];
        self.title     = [decoder decodeObjectForKey:@"title"];
        self.values    = [decoder decodeObjectForKey:@"values"];
        self.pickedId  = [decoder decodeObjectForKey:@"picked_id"];
        self.pickedValue  = [decoder decodeObjectForKey:@"picked_value"];
         self.type  = [decoder decodeObjectForKey:@"type"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.id     forKey:@"id"];
    [encoder encodeObject:self.title  forKey:@"title"];
    [encoder encodeObject:self.values forKey:@"values"];
    [encoder encodeObject:self.pickedId forKey:@"picked_id"];
    [encoder encodeObject:self.pickedValue forKey:@"picked_value"];
    [encoder encodeObject:self.type forKey:@"type"];
    
}

@end
