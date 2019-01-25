//
//  ViewController.m
//  MapsDemo
//
//  Created by David Mills on 2018-06-22.
//  Copyright © 2018 David Mills. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MyStrangeAnnotation.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 20;
    self.locationManager.delegate = self;
    // This actually kicks off the authorization status
    // The locationManager:didChangeAuthorizationStatus: method won't be called
    // unless we send this message to the locationManager
    [self.locationManager requestWhenInUseAuthorization];
    
    // Setup MapView
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.mapType = MKMapTypeStandard; //MKMapTypeHybrid;
    
    // MapView annotations act just like UITableView cells
    // We need to register our annotation view class with the MapView
    // so that when we dequeue a cell it knows what type of annotation view
    // to create
    [self.mapView registerClass:[MKMarkerAnnotationView class] forAnnotationViewWithReuseIdentifier:@"myAnnotation"];
    
    // Create a random annotation to show on the map
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.49270362, -122.30124361);
    MyStrangeAnnotation *annotation = [[MyStrangeAnnotation alloc] initWithCoordinate:coord andTitle:@"My random spot"];
    [self.mapView addAnnotation:annotation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This is a getter for the geocoder property.
// We don't actually want to instaniate the geocoder until we actually need it
// This is known as lazy instantiation
- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

#pragma mark - CLLocationManagerDelegate

// This delegate method is called whenever the authorization status changes.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization Status: %d", status);
    // Only if we've been given permission from the user
    // should we actually start updating the location
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Got locations: %@", locations);
    CLLocation *loc = locations[0];
    
    // Center the map on the users current location
    [self.mapView setRegion:MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(0.01, 0.01))];
    
    // Reverse Geocode the location into a Placemark to get address info
    // Since this needs to go to an external service to get this info, we need to
    // pass a completion handler to handle the result of the query.
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks[0];
        MyStrangeAnnotation *annotation = [[MyStrangeAnnotation alloc] initWithCoordinate:loc.coordinate andTitle:mark.name];
        [self.mapView addAnnotation:annotation];
    }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // if the type of the annotation is one of our custom annotations
    if ([annotation isKindOfClass:MyStrangeAnnotation.class]) {
        // Generate an annotation view for that annotation
        MKMarkerAnnotationView *mark = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation" forAnnotation:annotation];
        mark.tintColor = [UIColor greenColor];
        mark.glyphText = annotation.title;
        mark.titleVisibility = MKFeatureVisibilityVisible;
        mark.animatesWhenAdded = YES;
        
        return mark;
    }
    
    // We need to return nil otherwise for it to render the default annotation
    // This is especially useful for the user's current location marker.
    return nil;
}


@end
