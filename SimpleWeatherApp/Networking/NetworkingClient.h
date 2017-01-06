//
//  NetworkingClient.h
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class City;

@interface NetworkingClient : NSObject
+ (instancetype)sharedClient;
- (void)fetchForecastForCity:(City*)city success:(void(^)(NSArray* jsonForecasts))successBlock andFailure:(void(^)(NSError* error))failureBlock;
- (void)fetchWeatherIconWithName:(NSString*)weatherIconName success:(void(^)(UIImage* image))successBlock andFailure:(void(^)(NSError* error))failureBlock;
@end

