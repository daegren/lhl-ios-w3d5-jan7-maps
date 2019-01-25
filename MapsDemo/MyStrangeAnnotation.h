//
//  MyStrangeAnnotation.h
//  MapsDemo
//
//  Created by David Mills on 2018-06-22.
//  Copyright © 2018 David Mills. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyStrangeAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate andTitle:(NSString *)title;

@end
