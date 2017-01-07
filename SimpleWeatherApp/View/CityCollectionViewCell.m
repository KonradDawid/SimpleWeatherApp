//
//  CityCollectionViewCell.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "CityCollectionViewCell.h"
#import "City.h"
#import "AppStyle.h"

@interface CityCollectionViewCell ()
@end

@implementation CityCollectionViewCell

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
    _nameLabel = [AppStyle standardLabelWithSize:24];
}

- (void)addSubviews {
    [self.contentView addSubview:_nameLabel];
}

- (void)setupLayout {
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.nameLabel.text = @"";
}

@end

