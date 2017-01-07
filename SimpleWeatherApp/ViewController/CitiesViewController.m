//
//  CitiesViewController.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "CitiesViewController.h"
#import "CitiesManager.h"
#import "City.h"
#import "CityCollectionViewCell.h"
#import "AppStyle.h"


@interface CitiesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) CitiesManager *citiesManager;
@property (nonatomic, strong) UICollectionView *citiesCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *citiesFlowLayout;
@property (nonatomic, strong) UILabel *guideLabel;
@end

@implementation CitiesViewController

// specific and internal to a single class
static NSString* const cityCellIdentifier = @"cityCellIdentifier";
static CGFloat const cellHeight = 100.0f;

- (instancetype)initWithCitiesManager:(CitiesManager *)citiesManager {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _citiesManager = citiesManager;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithCitiesManager:nil];
}

- (void)selectCity:(City*)city {
    if ([self.delegate respondsToSelector:@selector(citiesViewController:didSelectCity:)]) {
        [self.delegate citiesViewController:self didSelectCity:city];
    }
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubviews];
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    City *firstCity = [self.citiesManager getCities].firstObject;
    if (firstCity != nil) {
        [self selectCity:firstCity];
    }
}

- (void)addSubviews {
    [self.view addSubview:self.guideLabel];
    [self.view addSubview:self.citiesCollectionView];
}

- (void)setupLayout {
    
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(_citiesCollectionView, _guideLabel);
    NSDictionary *metricsDictionary = @{@"cellHeight" : @(cellHeight)};
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.guideLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_guideLabel]-[_citiesCollectionView(==cellHeight)]"options:0 metrics:metricsDictionary views:viewsDictionary]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_citiesCollectionView]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.citiesCollectionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.citiesCollectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.citiesManager getCities].count;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CityCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cityCellIdentifier forIndexPath: indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CityCollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city = [self.citiesManager getCities][indexPath.section];
    cell.nameLabel.text = city.name?:@"";
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGRect visibleRect = CGRectMake(self.citiesCollectionView.contentOffset.x, self.citiesCollectionView.contentOffset.y, self.citiesCollectionView.bounds.size.width, self.citiesCollectionView.bounds.size.height);
    CGPoint visibleCenterPoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.citiesCollectionView indexPathForItemAtPoint:visibleCenterPoint];
    City *city = self.citiesManager.getCities[visibleIndexPath.section];
    [self selectCity:city];
}

#pragma mark - Lazy loaded properties

- (UICollectionView *)citiesCollectionView {
    if (!_citiesCollectionView) {
        _citiesCollectionView = [[UICollectionView alloc]initWithFrame: CGRectZero collectionViewLayout: self.citiesFlowLayout];
        _citiesCollectionView.dataSource = self;
        _citiesCollectionView.delegate = self;
        _citiesCollectionView.pagingEnabled = YES;
        _citiesCollectionView.backgroundColor = [UIColor clearColor];
        _citiesCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_citiesCollectionView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier: cityCellIdentifier];
    }
    return _citiesCollectionView;
}

- (UICollectionViewFlowLayout *)citiesFlowLayout {
    if (!_citiesFlowLayout) {
        _citiesFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _citiesFlowLayout.minimumInteritemSpacing = 0.0f;
        _citiesFlowLayout.minimumInteritemSpacing = 0.0f;
        _citiesFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width, cellHeight);
        _citiesFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _citiesFlowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return _citiesFlowLayout;
}

- (UILabel *)guideLabel {
    if (!_guideLabel) {
        _guideLabel = [AppStyle standardLabel];
        _guideLabel.text = @"Scroll up and down to select city....";
    }
    return _guideLabel;
}

@end
