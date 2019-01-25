//
//  MyStrangeAnnotation.m
//  MapsDemo
//
//  Created by David Mills on 2018-06-22.
//  Copyright © 2018 David Mills. All rights reserved.
//

#import "MyStrangeAnnotation.h"


@implementation MyStrangeAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title {
    if (self = [super init]) {
        _coordinate = coordinate;
        _title = title;
    }
    return self;
}

@end
