//
//  AppStyle.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "AppStyle.h"

@implementation AppStyle

+ (UIFont *)primaryFont {
    return [self primaryFontWithSize:15];
}

+ (UIFont*)primaryFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIColor*)primaryTextColor {
    return [UIColor darkGrayColor];
}

+ (UILabel*)standardLabelWithSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [self primaryFontWithSize:size];
    label.textColor = [self primaryTextColor];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

+ (UILabel*)standardLabel {
    return [self standardLabelWithSize:15];
}

@end
