//
//  CitiesManager.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "CitiesManager.h"
#import "City.h"

@implementation CitiesManager

+ (instancetype)sharedManager {
    static CitiesManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[CitiesManager alloc] init];;
    });
    return _sharedManager;
}

- (NSArray*)getCities {
    City *london = [[City alloc] initWithName:@"London" countryCode:@"uk"];
    City *barcelona = [[City alloc] initWithName:@"Barcelona" countryCode:@"es"];
    City *warsaw = [[City alloc] initWithName:@"Warsaw" countryCode:@"pl"];
    
    return @[london, barcelona, warsaw];
}

@end
