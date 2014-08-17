//
//  BeconListViewController.m
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 16/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconListViewController.h"
#import "BeaconDetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <AFHTTPRequestOperationManager.h>
#import "IonIcons.h"

@interface BeaconListViewController ()

@end

@implementation BeaconListViewController{
    GMSMapView *mapView_;
    UIButton* listMapButton;
}

- (void)navBarButtonsPressed:(UIButton*)sender
{
   NSLog(@"in navBarButtonsPressed >> %ld", (long)sender.tag);

    if (sender.tag == 1) {
        UIImage *icon = [IonIcons imageWithIcon:icon_map
                                      iconColor:[UIColor whiteColor]
                                       iconSize:25.0f
                                      imageSize:CGSizeMake(50.0f, 50.0f)];
            //  [sender.imageView setImage:icon];
        [sender setImage:icon forState:UIControlStateNormal];
        [sender setTag:2];

//        [self.tableView setHidden:NO];
//        [self.googleMapView setHidden:YES];
        
    }else if(sender.tag == 2){
        UIImage *icon = [IonIcons imageWithIcon:icon_navicon
                                      iconColor:[UIColor whiteColor]
                                       iconSize:25.0f
                                      imageSize:CGSizeMake(50.0f, 50.0f)];

        [sender setImage:icon forState:UIControlStateNormal];
        [sender setTag:1];
//        [self.tableView setHidden:YES];
//        [self.googleMapView setHidden:NO];
    }

    NSLog(@"out navBarButtonsPressed >> %ld", (long)sender.tag);



}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Discover"];



    listMapButton =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];

    UIImage *icon = [IonIcons imageWithIcon:icon_navicon
                                  iconColor:[UIColor whiteColor]
                                   iconSize:25.0f
                                  imageSize:CGSizeMake(50.0f, 50.0f)];

        //[IonIcons label:listMapButton.titleLabel setIcon:icon_navicon size:25.0f color:[UIColor darkGrayColor] sizeToFit:NO];

//    if (icon == nil) {
//        NSLog(@"icon == nil");
//    }
    [listMapButton setImage:icon forState:UIControlStateNormal];
        // [listMapButton setShowsTouchWhenHighlighted:NO];
//    [listMapButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [listMapButton setTag:1];

    [listMapButton setImageEdgeInsets:UIEdgeInsetsMake(2, 10, -2, -10)];
   [listMapButton addTarget:self action:@selector(navBarButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];

    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
//    [locationManager startUpdatingLocation];
    
     [locationManager startMonitoringSignificantLocationChanges];
   UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:listMapButton];
//
//
    NSArray *actionButtonItems = @[buttonItem];
//
    self.navigationItem.rightBarButtonItems = actionButtonItems;




        // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
   // self.view = mapView_;

        // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;




}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailed");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


    ////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;    //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
        }

        // Here we use the provided setImageWithURL: method to load the web image
        // Ensure you use a placeholder image otherwise cells will be initialized with no image
//    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://example.com/image.jpg"]
//                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    cell.textLabel.text = @"My Text";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"didSelectRowAtIndexPath >> %ld", indexPath.row);
    
    
//    Yourstring=[catagorry objectAtIndex:indexPath.row];
//
//        //Pushing next view
//    cntrSecondViewController *cntrinnerService = [[cntrSecondViewController alloc] initWithNibName:@"cntrSecondViewController" bundle:nil];
//    [self.navigationController pushViewController:cntrinnerService animated:YES];

}
@end
