//
//  Forecast.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        NSNumber *hour = dictionary[@"dt"];
        
        NSDictionary *mainDict = dictionary[@"main"];
        NSNumber* temp = mainDict[@"temp"];
        
        NSArray *weather = dictionary[@"weather"];
        NSDictionary *weatherDict = weather.firstObject;
        
        NSString *weatherDesc = weatherDict[@"description"];
        NSString *weatherIcon = weatherDict[@"icon"];
        
        _hour = [NSDate dateWithTimeIntervalSince1970:[hour doubleValue]];
        _weatherDesc = weatherDesc;
        _temperature = temp;
        _weatherIconName = weatherIcon;
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat: @"hour:%@, weatherDesc:%@, temperature:%@, thumbnail:%@", self.hour, self.weatherDesc, self.temperature, self.weatherIconName];
}

@end
