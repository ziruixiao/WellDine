//
//  MapViewController.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Created by Felix Xiao on 12/28/2012
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
}
@property (strong,nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)loadMapView:(id)sender;
- (void)showVenueDetails:(id)sender;
@end
