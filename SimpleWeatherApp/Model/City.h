//
//  City.h
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *countryCode;
- (instancetype)initWithName:(NSString*)name countryCode:(NSString*)countryCode;
@end
