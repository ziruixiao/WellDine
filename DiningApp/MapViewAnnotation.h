//
//  MapViewAnnotation.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/28/2012
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//properties
@interface MapViewAnnotation : NSObject <MKAnnotation> 
//methods

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
