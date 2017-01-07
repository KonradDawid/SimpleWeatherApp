//
//  ForecastCollectionViewCell.h
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Forecast;

@interface ForecastCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel* hourLabel;
@property (nonatomic, strong) UILabel *weatherDescLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UIImageView* imageView;
@end
