
#import <Foundation/Foundation.h>


#define AUTH_URL             @"http://ec2-54-208-24-225.compute-1.amazonaws.com"
#define OAUTH_CALLBACK       @"http%3A%2F%2Flocalhost%2Fmagento"
#define CONSUMER_KEY         @"fcaeb82cb3645b69d2c5fbc0d2983991"
#define CONSUMER_SECRET      @"7c305911f666276126a10628ac3746d8"
#define CONSUMER_SIGNATURE   @"7c305911f666276126a10628ac3746d8%26"
#define REQUEST_TOKEN_URL    @"/oauth/initiate"

#define REQUEST_TOKEN_METHOD @"POST"
#define ACCESS_TOKEN_METHOD  @"POST"


#import "NSDictionary+Helper.h"

@interface VPBaseManager : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *arrNeighboursData;
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableString *foundValue;


//- (id)initWithOrganization:(TMOrganizationModel *)organization;
//- (NSString *)getPath:(NSString *)path;
//- (NSString *)getResourcePath:(NSString *)resource forResourceId:(NSString *)resourceId;
- (NSString *)extractMessageFromTask:(NSURLSessionDataTask *)task andError:(NSError *)error;

@end
