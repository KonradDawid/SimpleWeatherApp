//
//  Forecast.h
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject
@property (nonatomic, strong) NSDate *hour;
@property (nonatomic, copy) NSString *weatherDesc;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, copy) NSString *weatherIconName;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

