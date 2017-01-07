//
//  ForecastCollectionViewCell.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "ForecastCollectionViewCell.h"
#import "Forecast.h"
#import "AppStyle.h"

@interface ForecastCollectionViewCell ()
@end

@implementation ForecastCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
        [self addSubviews];
        [self setupLayout];
    }
    return self;
}

- (void)setupView {
    
    _hourLabel = [AppStyle standardLabel];
    _temperatureLabel = [AppStyle standardLabel];
    _weatherDescLabel = [AppStyle standardLabel];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)addSubviews {
    [self.contentView addSubview:_hourLabel];
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_temperatureLabel];
    [self.contentView addSubview:_weatherDescLabel];
}

- (void)setupLayout {
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_hourLabel, _imageView, _temperatureLabel, _weatherDescLabel);
    
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_hourLabel]" options:0 metrics:nil views:viewsDictionary]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hourLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-15]];
    [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView(==30)]-0-[_weatherDescLabel]" options:0 metrics:nil views:viewsDictionary]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_weatherDescLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_temperatureLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_temperatureLabel]-10-|" options:0 metrics:nil views:viewsDictionary]];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.hourLabel.text = @"";
    self.imageView.image = nil;
    self.temperatureLabel.text = @"";
    self.weatherDescLabel.text = @"";
}


@end

