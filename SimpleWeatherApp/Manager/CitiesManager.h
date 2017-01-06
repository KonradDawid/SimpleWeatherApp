//
//  CitiesManager.h
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitiesManager : NSObject
+ (instancetype)sharedManager;
- (NSArray*)getCities;
@end

