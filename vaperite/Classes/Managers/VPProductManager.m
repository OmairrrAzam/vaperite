

#import "VPProductManager.h"
#import "VPSessionManager.h"
#import "VPProductModel.h"

@implementation VPProductManager

- (void)fetchProducts {
    
    VPSessionManager *manager = [VPSessionManager sharedManager];
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    NSString *path = nil;
    path = [NSString stringWithFormat:@"api/rest/products"];
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // NSDictionary *parameters = @{@"format": @"xml"};
    
    [manager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (self.delegate) {
            
                
                self.xmlParser = (NSXMLParser *)responseObject;
            
                self.xmlParser.delegate = self;
                
                // Initialize the mutable string that we'll use during parsing.
                self.foundValue = [[NSMutableString alloc] init];
                
                // Start parsing.
                [self.xmlParser parse];
            
            
//            NSDictionary *dictResponse = (NSDictionary *)responseObject;
//            
//            NSArray *arrAssets = (NSArray *)[dictResponse objectForKey:@"assets"];
//            NSArray *assets = [TMAssetModel loadFromArray:arrAssets];
//            
//            NSDictionary *dictPagination = (NSDictionary *)[dictResponse objectForKey:@"pagination"];
//            TMPaginationModel *pagination = [[TMPaginationModel alloc] initWithDictionary:dictPagination];
//            
//            [self.delegate assetManager:self didFetchAssets:assets pagination:pagination];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       // NSString *message = [self extractMessageFromTask:task andError:error];
        [self.delegate productManager:self didFailToFetchProducts:@"Failed To get products : manual message"];
    }];
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    // When the parsing has been finished then simply reload the table view.
//    for (id object in self.arrNeighboursData) {
//        // do something with object
//        
//    }
    
   NSArray *products =  [VPProductModel loadFromArray:self.arrNeighboursData];
    
    [self.delegate productManager:self didFetchProducts:products];
}
@end
