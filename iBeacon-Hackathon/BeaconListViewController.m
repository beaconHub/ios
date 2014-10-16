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
#import <CoreBluetooth/CoreBluetooth.h>

@interface BeaconListViewController ()

@end

@implementation BeaconListViewController{
    GMSMapView *mapView_;
    UIButton* listMapButton;
}

- (void)navBarButtonsPressed:(UIButton*)sender
{
    if (sender.tag == 1) {
        UIImage *icon = [IonIcons imageWithIcon:icon_map iconColor:[UIColor whiteColor] iconSize:25.0f imageSize:CGSizeMake(50.0f, 50.0f)];
        [sender setImage:icon forState:UIControlStateNormal];
        [sender setTag:2];
        [self.tableView setHidden:NO];
        [self.mapView setHidden:YES];
    }else if(sender.tag == 2){
        UIImage *icon = [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor whiteColor] iconSize:25.0f imageSize:CGSizeMake(50.0f, 50.0f)];
        [sender setImage:icon forState:UIControlStateNormal];
        [sender setTag:1];
        [self.tableView setHidden:YES];
        [self.mapView setHidden:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Discover"];


    jsonResponseDictionary = [NSMutableDictionary new];

    datasourceArray = [NSMutableArray new];
    listMapButton =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];

    UIImage *icon = [IonIcons imageWithIcon:icon_map
                                  iconColor:[UIColor whiteColor]
                                   iconSize:25.0f
                                  imageSize:CGSizeMake(50.0f, 50.0f)];

    [listMapButton setImage:icon forState:UIControlStateNormal];

    [listMapButton setTag:2];

    [listMapButton setImageEdgeInsets:UIEdgeInsetsMake(2, 10, -2, -10)];
   [listMapButton addTarget:self action:@selector(navBarButtonsPressed:) forControlEvents:UIControlEventTouchUpInside];

    if (nil == locationManager){
        locationManager = [[CLLocationManager alloc] init];

    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;


//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler];
//    [[UIApplication sharedApplication] endBackgroundTask:];
    // Set a movement threshold for new events.
//    locationManager.distanceFilter = 500; // meters

    [self.tableView setHidden:NO];
    [self.mapView setHidden:YES];
    

    
//    if ([self shouldFetchUserLocation]) {
//        NSLog(@"yes");
//        [locationManager startUpdatingLocation];
//    }



    CLBeaconRegion* hackathonRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] major:100 minor:100 identifier:@"sdf"];

    [hackathonRegion setNotifyOnEntry:YES];
    [hackathonRegion setNotifyOnExit:YES];
    [hackathonRegion setNotifyEntryStateOnDisplay:YES];

    [locationManager startMonitoringForRegion:hackathonRegion];
    [locationManager startRangingBeaconsInRegion:hackathonRegion];





   UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:listMapButton];

    NSArray *actionButtonItems = @[buttonItem];

    self.navigationItem.rightBarButtonItems = actionButtonItems;

//
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
//                                                            longitude:151.20
//                                                                 zoom:6];
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.myLocationEnabled = YES;
//   // self.view = mapView_;
//
//        // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = mapView_;





    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

        // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];


}


-(BOOL)shouldFetchUserLocation{

    BOOL shouldFetchLocation= NO;

    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorized:
                shouldFetchLocation= YES;
                break;
            case kCLAuthorizationStatusDenied:
            {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"App level settings has been denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert= nil;
            }
                break;
            case kCLAuthorizationStatusNotDetermined:
            {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The user is yet to provide the permission" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert= nil;
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The app is recstricted from using location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            alert= nil;
            }
                break;

            default:
                break;
        }
    }
    else{
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The location services seems to be disabled from the settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        alert= nil;
    }
    
    return shouldFetchLocation;
}

#pragma mark - locationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{


    if (status == kCLAuthorizationStatusAuthorized) {
        NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
    }else if(status == kCLAuthorizationStatusNotDetermined){
        NSLog(@"kCLAuthorizationStatusNotDetermined");
//        [locationManager startUpdatingLocation];

        [locationManager startMonitoringSignificantLocationChanges];
    }
        // NSLog(@"authorizationstatus >> %@", status);

//    if(!CLLocationManager.locationServicesEnabled){
//        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
//    }else{
//
//
//        NSLog(@" its enabled");
//        [locationManager startUpdatingLocation];
//
//    }
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{


    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
    aNotification.timeZone = [NSTimeZone defaultTimeZone];
    aNotification.alertBody = @"Notification triggered";
    aNotification.alertAction = @"Details";
    [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"didEnterRegion");

    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
    aNotification.timeZone = [NSTimeZone defaultTimeZone];
    aNotification.alertBody = @"Notification triggered";
    aNotification.alertAction = @"Details";
    [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];


}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"didExitRegion");
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
        NSLog(@"didStartMonitoringForRegion >> region.name >> %@ ", region.identifier);
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"locationManager didupdatelocation");
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

    datasourceArray = [NSMutableArray new];
    
    NSString* requestString = [NSString stringWithFormat:@"http://beaconhub.herokuapp.com/search/near/%.6f/%.6f/14.json", location.coordinate.latitude, location.coordinate.longitude];

    AFHTTPRequestOperationManager *afhttpManager = [AFHTTPRequestOperationManager manager];
    [afhttpManager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);

        if (responseObject != nil) {

            NSString *responseString = [operation responseString];
            NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSArray* results = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:&error];
            for (id obj in results)
                {

                [datasourceArray addObject: obj];
                    //                NSDictionary *res=[results objectAtIndex:i];
                    //                NSDictionary *res2=[res objectForKey:@"post"];
                    //                [self.storesArray addObject:res2];

                }

//            NSLog(@"result.count >> %d", results.count);
                //                锸锸锸锸锸锸锸锸金 [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

   }

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailed >> %@", error);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


    ////

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return datasourceArray.count;    //count number of row from counting array hear cataGorry is An Array
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

//    id bufferObj = [datasourceArray objectAtIndex:indexPath.row];
//
//    UILabel* beaconNameLabel = (UILabel*) [cell viewWithTag:11];
//    UILabel* beaconOwnerLabel = (UILabel*) [cell viewWithTag:12];
//    UILabel* uuidLabel = (UILabel*) [cell viewWithTag:13];
//
//    [beaconNameLabel setText:[bufferObj objectForKey:@"name"]];
//    [beaconOwnerLabel setText:[bufferObj objectForKey:@"address"]];
//    [uuidLabel setText:[bufferObj objectForKey:@"uuid"]];


//    NSLog(@"bufferObj >> %@", bufferObj);

//    address = "Langham Place, Mongkok, Hong Kong";
//    description = "";
//    id = 7;
//    lat = "22.31824";
//    link = "http://www.langhamplace.com.hk/";
//    lng = "114.16796";
//    major = 1;
//    minor = 1;
//    name = "Langham Place";
//    url = "http://beaconhub.herokuapp.com/beacons/7.json";
//    uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";

        // Here we use the provided setImageWithURL: method to load the web image
        // Ensure you use a placeholder image otherwise cells will be initialized with no image
//    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://example.com/image.jpg"]
//                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    cell.textLabel.text = @"My Text";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    NSLog(@"didSelectRowAtIndexPath >> %ld", indexPath.row);

    
//    Yourstring=[catagorry objectAtIndex:indexPath.row];
//
//        //Pushing next view
//    cntrSecondViewController *cntrinnerService = [[cntrSecondViewController alloc] initWithNibName:@"cntrSecondViewController" bundle:nil];
//    [self.navigationController pushViewController:cntrinnerService animated:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        BeaconDetailViewController *nextView = segue.destinationViewController;

    id bufferObj = [datasourceArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];


    [nextView setBeaconObj:bufferObj];




        // nextView


}

#pragma mark - DZNEmptyDataSetDelegate methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {

    NSString *text = @"No Beacon Services Found";

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {

    NSString *text = @"Please make sure bluetooth is turned on and in range. Click continue to scan again.";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};

    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {

    return [UIColor whiteColor];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {


     UIImage *icon = [IonIcons imageWithIcon:icon_bluetooth iconColor:[UIColor darkGrayColor] iconSize:44.0f imageSize:CGSizeMake(60.0f, 60.0f)];
    return icon;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {

    return YES;
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {

    return YES;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {

    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {

}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {

}


@end
