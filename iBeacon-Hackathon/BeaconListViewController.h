//
//  BeaconListViewController.h
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 16/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIScrollView+EmptyDataSet.h"
@interface BeaconListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    CLLocationManager* locationManager;

    NSMutableDictionary* jsonResponseDictionary;
    NSMutableArray* datasourceArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;




@end
