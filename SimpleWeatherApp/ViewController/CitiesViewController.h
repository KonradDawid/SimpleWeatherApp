//
//  CitiesViewController.h
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CitiesManager;
@class City;
@class CitiesViewController;

@protocol CitiesViewControllerDelegate<NSObject>
-(void)citiesViewController:(CitiesViewController *)citiesViewController didSelectCity:(City *)city;
@end

@interface CitiesViewController : UIViewController
- (instancetype)initWithCitiesManager:(CitiesManager *)citiesManager;
@property (nonatomic, weak) id<CitiesViewControllerDelegate> delegate;
@end
