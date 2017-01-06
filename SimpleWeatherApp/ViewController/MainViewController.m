//
//  MainViewController.m
//  SimpleWeatherApp
//
//  Created by Konrad on 05.01.2017.
//  Copyright © 2017 Konrad. All rights reserved.
//

#import "MainViewController.h"
#import "CitiesViewController.h"
#import "ForecastsViewController.h"
#import "Forecast.h"
#import "NetworkingClient.h"
#import "CitiesManager.h"
#import "City.h"


@interface MainViewController () <CitiesViewControllerDelegate>
@property (nonatomic, strong) CitiesViewController *citiesViewController;
@property (nonatomic, strong) ForecastsViewController *forecastsViewController;
@end

@implementation MainViewController

- (instancetype)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        _citiesViewController = [[CitiesViewController alloc] initWithCitiesManager:[CitiesManager sharedManager]];
        _forecastsViewController = [[ForecastsViewController alloc] initWithNibName:nil bundle:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildViewControllers];
    [self addChildViewControllers];
    [self setupLayout];
}

- (void)setupChildViewControllers {
    self.citiesViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.forecastsViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.citiesViewController.delegate = self;
}

- (void)addChildViewControllers {
    [self addChildViewController:self.citiesViewController];
    [self addChildViewController:self.forecastsViewController];
    
    [self.view addSubview:self.citiesViewController.view];
    [self.view addSubview:self.forecastsViewController.view];
    
    [self.citiesViewController didMoveToParentViewController:self];
    [self.forecastsViewController didMoveToParentViewController:self];
}

- (void)fetchForecastForCity:(City*)city {
    [[NetworkingClient sharedClient] fetchForecastForCity: city success:^(NSArray *forecasts) {
        self.forecastsViewController.forecasts = forecasts;
    } andFailure:^(NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong..." preferredStyle:UIAlertControllerStyleAlert];
        [alertViewController addAction:okAction];
        [self presentViewController:alertViewController animated:YES completion:nil];
    }];
}

- (void)setupLayout {
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary* viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     self.citiesViewController.view, @"_citiesVCView",
                                     self.forecastsViewController.view, @"_forecastsVCView",
                                     nil];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_citiesVCView]" options:0 metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_forecastsVCView]-|" options:0 metrics:nil views:viewsDictionary]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.citiesViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forecastsViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_citiesVCView]|" options:0 metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_forecastsVCView]|" options:0 metrics:nil views:viewsDictionary]];
}

#pragma mark - CitiesViewController Delegate

- (void)citiesViewController:(CitiesViewController *)citiesViewController didSelectCity:(City *)city {
    [self fetchForecastForCity:city];
}

@end
