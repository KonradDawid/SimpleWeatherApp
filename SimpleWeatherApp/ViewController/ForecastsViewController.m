//
//  ForecastsViewController.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "ForecastsViewController.h"
#import "ForecastCollectionViewCell.h"
#import "NetworkingClient.h"
#import "Forecast.h"

@interface ForecastsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *forecastsFlowLayout;
@property (nonatomic, strong) UICollectionView *forecastsCollectionView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSMutableDictionary *weatherIconCache;
@end

@implementation ForecastsViewController

// specific and internal to a single class
static NSString* const forecastCellIdentifier = @"forecastCellIdentifier";
static CGFloat const cellHeight = 150.0f;

- (instancetype)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        _weatherIconCache = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setForecasts:(NSArray *)forecasts {
    _forecasts = forecasts;
    [self.forecastsCollectionView reloadData];
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubviews];
    [self setupLayout];
}

- (void)addSubviews {
    [self.view addSubview:self.forecastsCollectionView];
}

- (void)setupLayout {
    
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(_forecastsCollectionView);
    NSDictionary *metricsDictionary = @{@"cellHeight" : @(cellHeight)};
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_forecastsCollectionView(==cellHeight)]" options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastsCollectionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastsCollectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_forecastsCollectionView]|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return self.forecasts.count;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ForecastCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:forecastCellIdentifier forIndexPath: indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ForecastCollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Forecast *forecast = self.forecasts[indexPath.section];
    cell.hourLabel.text = [self.dateFormatter stringFromDate:forecast.hour];
    cell.temperatureLabel.text = [NSString stringWithFormat:@"%@%@", [self.numberFormatter stringFromNumber:forecast.temperature], @"°C"];
    cell.weatherDescLabel.text = forecast.weatherDesc?:@"";
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Forecast *forecast = self.forecasts[indexPath.section];
    ForecastCollectionViewCell *forecastCell = (ForecastCollectionViewCell*)cell;
    forecastCell.tag = indexPath.section;
    
    UIImage *cachedWeatherIcon = self.weatherIconCache[forecast.weatherIconName];
    if (cachedWeatherIcon != nil) {
        //NSLog(@"cache hit");
        forecastCell.imageView.image = cachedWeatherIcon;
    } else {
        //NSLog(@"cache miss");
        [[NetworkingClient sharedClient] fetchWeatherIconWithName:forecast.weatherIconName success:^(UIImage *image) {
            
            // save to cache even if we not display it now
            self.weatherIconCache[forecast.weatherIconName] = image;
            
            // preventing setting image for old forecast after cell was reused
            if (forecastCell.tag == indexPath.section) {
                forecastCell.imageView.image = image;
            } else {
                NSLog(@"fetching image finished after cell was reused");
            }
            
        } andFailure:^(NSError *error) {
            NSLog(@"Coud not fetch waether icon %@", [error localizedDescription]);
        }];
    }
}

#pragma mark - Lazy loaded properties

- (UICollectionView *)forecastsCollectionView {
    if (!_forecastsCollectionView) {
        _forecastsCollectionView = [[UICollectionView alloc]initWithFrame: CGRectZero collectionViewLayout: self.forecastsFlowLayout];
        _forecastsCollectionView.dataSource = self;
        _forecastsCollectionView.delegate = self;
        _forecastsCollectionView.backgroundColor = [UIColor clearColor];
        _forecastsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_forecastsCollectionView registerClass:[ForecastCollectionViewCell class] forCellWithReuseIdentifier: forecastCellIdentifier];
    }
    return _forecastsCollectionView;
}

- (UICollectionViewFlowLayout *)forecastsFlowLayout {
    if (!_forecastsFlowLayout) {
        _forecastsFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _forecastsFlowLayout.minimumInteritemSpacing = 0.0f;
        _forecastsFlowLayout.minimumInteritemSpacing = 0.0f;
        _forecastsFlowLayout.itemSize = CGSizeMake(cellHeight, cellHeight);
        _forecastsFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _forecastsFlowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return _forecastsFlowLayout;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat = @"HH:mm";
    }
    return _dateFormatter;
}

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.maximumFractionDigits = 0;
        _numberFormatter.roundingMode = NSNumberFormatterRoundUp;
    }
    return _numberFormatter;
}

@end

