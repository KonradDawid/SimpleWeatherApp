//
//  City.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithName:(NSString*)name countryCode:(NSString*)countryCode {
    self = [super init];
    if (self) {
        _name = name;
        _countryCode = countryCode;
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat: @"name:%@, countryCode:%@", self.name, self.countryCode];
}

@end
