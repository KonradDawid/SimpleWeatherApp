//
//  CityCollectionViewCell.h
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class City;

@interface CityCollectionViewCell : UICollectionViewCell
- (void)configureWithCity: (City*)city;
@end
