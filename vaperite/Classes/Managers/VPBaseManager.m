//
//  TMBaseManager.m
//  Vaperite
//
// 
//  Copyright (c) 2015 Techverx. All rights reserved.
//

#import "VPBaseManager.h"
#import "AFNetworkReachabilityManager.h"


@interface VPBaseManager() 



@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;
@property (nonatomic, strong) NSString *currentElement;

@end

@implementation VPBaseManager

/*- (id)initWithOrganization:(TMOrganizationModel *)organization {
    self = [super init];
    self.organization = organization;
    return self;
}

- (NSString *)getPath:(NSString *)path {
    return [NSString stringWithFormat:@"organizations/%@/%@/", self.organization.id, path];
}

- (NSString *)getResourcePath:(NSString *)resource forResourceId:(NSString *)resourceId {
    return [NSString stringWithFormat:@"organizations/%@/%@/%@/", self.organization.id, resource, resourceId];
}
*/
- (NSString *)extractMessageFromTask:(NSURLSessionDataTask *)task andError:(NSError *)error {
    
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
    if (response.statusCode >= 400 && response.statusCode < 500) {
        NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        id json = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
        if ([json respondsToSelector:@selector(objectForKey:)]) {
            return [json objectForKeyHandlingNull:@"error"];
        }
        else {
            return @"Unknown Error. Please try again later.";
        }
    }
    else if (response.statusCode >= 500) {
        return @"Internal Server Error.";
    }
    else {
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        if (reachabilityManager.reachable) {
            return @"Unknown Error. Please try again later.";
        }
        else {
            return @"The request timed out.";
        }
    }
}

#pragma mark - NSXMLParser Delegate Methods

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    // Initialize the neighbours data array.
    self.arrNeighboursData = [[NSMutableArray alloc] init];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    // When the parsing has been finished then simply reload the table view.
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    // If the current element name is equal to "geoname" then initialize the temporary dictionary.
    if ([elementName isEqualToString:@"data_item"]) {
        self.dictTempDataStorage = [[NSMutableDictionary alloc] init];
    }
    
    // Keep the current element.
    self.currentElement = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"data_item"]) {
        // If the closing element equals to "geoname" then the all the data of a neighbour country has been parsed and the dictionary should be added to the neighbours data array.
        [self.arrNeighboursData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage]];
    }
    else if ([elementName isEqualToString:@"entity_id"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"entity_id"];
    }
    else if ([elementName isEqualToString:@"type_id"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"type_id"];
    }
    else if ([elementName isEqualToString:@"sku"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"sku"];
    }
    else if ([elementName isEqualToString:@"description"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"description"];
    }
    else if ([elementName isEqualToString:@"short_description"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"short_description"];
    }
    else if ([elementName isEqualToString:@"meta_keyword"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"meta_keyword"];
    }
    else if ([elementName isEqualToString:@"regular_price_with_tax"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"regular_price_with_tax"];
    }
    else if ([elementName isEqualToString:@"regular_price_without_tax"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"regular_price_without_tax"];
    }
    else if ([elementName isEqualToString:@"is_saleable"]){
        // If the country name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"is_saleable"];
    }
    else if ([elementName isEqualToString:@"name"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"name"];
    }
    else if ([elementName isEqualToString:@"meta_title"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"meta_title"];
    }
    else if ([elementName isEqualToString:@"meta_description"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"meta_description"];
    }
    else if ([elementName isEqualToString:@"final_price_with_tax"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"final_price_with_tax"];
    }
    else if ([elementName isEqualToString:@"final_price_without_tax"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"final_price_without_tax"];
    }
    else if ([elementName isEqualToString:@"image_url"]){
        // If the toponym name element was found then store it.
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"image_url"];
    }
    
    // Clear the mutable string.
    [self.foundValue setString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    
    if (![string isEqualToString:@"\n"]) {
        [self.foundValue appendString:string];
    }
    
}




@end
