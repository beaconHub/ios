//
//  BeaconListViewController.h
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 16/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface BeaconListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager* locationManager;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *googleMapView;



@end
