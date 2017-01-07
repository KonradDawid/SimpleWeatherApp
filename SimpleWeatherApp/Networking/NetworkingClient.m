//
//  NetworkingClient.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingClient.h"
#import "Constants.h"
#import "Forecast.h"
#import "City.h"


@interface NetworkingClient ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation NetworkingClient

typedef NS_ENUM(NSInteger, ResourceType) {
    ResourceTypeJson,
    ResourceTypeImage
};

+ (instancetype)sharedClient {
    static NetworkingClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkingClient alloc] init];;
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

-(void)doGet:(NSURL*)url resourceType:(ResourceType)resourceType success:(void(^)(NSURLResponse* response, NSData* data))successBlock andFailure:(void(^)(NSURLResponse* response, NSError* error))failureBlock {
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    
    NSString *acceptHeaderValue = (resourceType == ResourceTypeImage) ? @"image/*": @"application/json";
    [request addValue:acceptHeaderValue forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask* dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error){
            if(failureBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(response, error);
                });
            }
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                if(failureBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failureBlock(response, [NSError errorWithDomain:kErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"Api responded with wrong status code"}]);
                    });
                }
                return;
            }
        }
        
        if (successBlock) {
            // parsing of json and object creation on main thread but imho in such a small application it is acceptable
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(response, data);
            });
        }
    }];
    
    [dataTask resume];
}

- (void)fetchWeatherIconWithName:(NSString*)weatherIconName success:(void(^)(UIImage* image))successBlock andFailure:(void(^)(NSError* error))failureBlock {
    
    NSURL *url = [self urlForWeatherIconName:weatherIconName];
    
    [self doGet:url resourceType:ResourceTypeImage success:^(NSURLResponse *response, NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (image == nil) {
            if (failureBlock) {
                failureBlock([NSError errorWithDomain:kErrorDomain code:3 userInfo:@{NSLocalizedDescriptionKey: @"Could not create image"}]);
            }
        } else {
            // one can insert dispatch_after snippet here to test how images fetching works
            if (successBlock) {
                successBlock(image);
            }
        }
        
    } andFailure:^(NSURLResponse *response, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)fetchForecastForCity:(City*)city success:(void(^)(NSArray* forecasts))successBlock andFailure:(void(^)(NSError* error))failureBlock {
    
    NSURL *url = [self urlForCity:city];
    
    [self doGet:url resourceType:ResourceTypeJson success:^(NSURLResponse *response, NSData *data) {
        NSError *parsingError = nil;
        NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
        if (parsingError) {
            if (failureBlock) {
                failureBlock([NSError errorWithDomain:kErrorDomain code:2 userInfo:@{NSLocalizedDescriptionKey: @"Could not parse json"}]);
            }
            return;
        }
        
        NSArray *forecastsJsonArray = jsonDictionary[@"list"];
        NSMutableArray *forecasts = [[NSMutableArray alloc] init];
        for (NSDictionary *forecastJson in forecastsJsonArray) {
            Forecast *forecast = [[Forecast alloc] initWithDictionary:forecastJson];
            [forecasts addObject:forecast];
        }
        
        if (successBlock) {
            successBlock(forecasts);
        }
        
    } andFailure:^(NSURLResponse *response, NSError *error) {
        failureBlock(error);
    }];
}

#pragma mark - Helper methods

- (NSURL*)urlForCity:(City*)city {
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"http";
    components.host = kApiHost;
    components.path = kForecastPath;
    
    NSString *nameAndCountryCode = [NSString stringWithFormat:@"%@,%@", city.name, city.countryCode];
    NSURLQueryItem *cityName = [NSURLQueryItem queryItemWithName:@"q" value: nameAndCountryCode];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"appid" value: kApiKey];
    NSURLQueryItem *metricUnits = [NSURLQueryItem queryItemWithName:@"units" value:@"metric"];
    
    components.queryItems = @[cityName, apiKey, metricUnits];
    return components.URL;
}

- (NSURL*)urlForWeatherIconName:(NSString*)weatherIconName {
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"http";
    components.host = kApiHost;
    components.path = [NSString stringWithFormat:@"%@/%@.png", kWeatherIconPath, weatherIconName];
    
    return components.URL;
}

@end
