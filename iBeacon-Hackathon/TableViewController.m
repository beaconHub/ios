//
//  TableViewController.m
//  CellToPageViewTransition
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewController.h"
#import "MainHostViewController.h"
#import "BeaconDetailViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import "IonIcons.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "JCRBlurView.h"
#import "ChameleonFramework/Chameleon.h"
#import "UIColor+RandomColor.h"
#import "BeaconDetailViewController.h"
#import "CSParallaxHeaderViewController.h"

@interface TableViewController ()
{
    NSArray *data;
    UILabel* numberOfBeaconsLabel;
}

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MainHostViewController* parentView = (MainHostViewController*)(self.navigationController.parentViewController);
        //[parentView.flatRoundedButton setAlpha:1.0];

    [parentView.flatRoundedButton animateToType:buttonAddType];
    [parentView.headerLabel setText:@"Discover"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:FlatSkyBlue];
    data = @[@"Red Color", @"Blue Color", @"Orange Color"];

    jsonResponseDictionary = [NSMutableDictionary new];

    datasourceArray = [NSMutableArray new];
    currentPlaceMark = [NSString new];

    if (nil == locationManager){
        locationManager = [[CLLocationManager alloc] init];

    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

        // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters

    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }



        [locationManager startUpdatingLocation];

    [locationManager startUpdatingLocation];
    
    // Clear previous beacons
    for (CLBeaconRegion *region in locationManager.monitoredRegions) {
        [locationManager stopMonitoringForRegion:region];
        [locationManager stopRangingBeaconsInRegion:region];
    }
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

        // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];

    [self.tableView setShowsVerticalScrollIndicator:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return datasourceArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *row0CellIdentifier = @"Row0Cell";
    static NSString *cellIdentifier = @"Cell";

        //check
    UITableViewCell *cell = nil;


        //check

    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:row0CellIdentifier];
    }else
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];




    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:row0CellIdentifier];
//            UILabel* locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320, 20)];
//            [locationLabel setBackgroundColor:[UIColor clearColor]];
//            [locationLabel setTextColor:[UIColor whiteColor]];
//            [locationLabel setTextAlignment:NSTextAlignmentCenter];
//            [locationLabel setTag:1];
//            [locationLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:23.f]];
//            [locationLabel setText:[currentPlaceMark uppercaseString]];
//
//
//
//
//            UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 320, 115)];
//            [numberLabel setBackgroundColor:[UIColor clearColor]];
//            [numberLabel setTextColor:[UIColor whiteColor]];
//            [numberLabel setTextAlignment:NSTextAlignmentCenter];
//            [numberLabel setTag:2];
//            [numberLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:90.f]];
//            [numberLabel setText:[NSString stringWithFormat:@"%d",datasourceArray.count]];

//            UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 15)];
//            [textLabel setBackgroundColor:[UIColor clearColor]];
//            [textLabel setTextColor:[UIColor whiteColor]];
//            [textLabel setTextAlignment:NSTextAlignmentCenter];
//            [textLabel setTag:3];
//            [textLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.f]];
//            [textLabel setText:@"beacon services found"];

                //        UILabel*
//            [cell addSubview:locationLabel];
//            
//            [cell addSubview:numberLabel];
//            [cell addSubview:textLabel];

        }else
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.backgroundColor = FlatSkyBlue;
    if (indexPath.row == 0){

        UILabel* locationLabel = (UILabel*) [cell viewWithTag:1];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [locationLabel setTextColor:[UIColor whiteColor]];
        [locationLabel setTextAlignment:NSTextAlignmentCenter];
        [locationLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:23.f]];
        [locationLabel setNumberOfLines:1];
        [locationLabel setAdjustsFontSizeToFitWidth:YES];
        [locationLabel setMinimumScaleFactor:0.5f];
        [locationLabel setText:[currentPlaceMark uppercaseString]];





        UILabel* numberLabel = (UILabel*) [cell viewWithTag:2];
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextColor:[UIColor whiteColor]];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [numberLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:90.f]];
        [numberLabel setText:[NSString stringWithFormat:@"%d",datasourceArray.count]];

//        if (numberOfBeaconsLabel == nil) {
//            numberOfBeaconsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 320, 115)];
//            [numberOfBeaconsLabel setBackgroundColor:[UIColor clearColor]];
//            [numberOfBeaconsLabel setTextColor:[UIColor whiteColor]];
//            [numberOfBeaconsLabel setTextAlignment:NSTextAlignmentCenter];
//            [numberOfBeaconsLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:90.f]];
//            
//            [cell addSubview:numberOfBeaconsLabel];
//        }
//        [numberOfBeaconsLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)datasourceArray.count]];


        UILabel* textLabel = (UILabel*) [cell viewWithTag:3];
//        [textLabel setFrame:CGRectMake(0, 190, 320, 15)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.f]];
        [textLabel setText:@"beacon services found"];




//        [cell addSubview:textLabel];
//        [cell setBackgroundColor:[UIColor redColor]];


        return cell;

    }

    id obj = [datasourceArray objectAtIndex:indexPath.row - 1];



//    cell.backgroundColor = [UIColor blueColor];

    // Configure the cell...



    UILabel* textLabel = (UILabel*) [cell viewWithTag:1];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:20.f]];
    [textLabel setText:[obj valueForKey:@"name"]];
//    [cell addSubview:textLabel];

    UIImageView* appWebIconView = (UIImageView*) [cell viewWithTag:2];



        //link
        //icon_ios7_world_outline


        //改 －
    UIImage *icon = [IonIcons imageWithIcon:icon_iphone iconColor:[UIColor whiteColor] iconSize:40.0f imageSize:CGSizeMake(50.0f, 50.0f)];
    [appWebIconView setBackgroundColor:[UIColor clearColor]];
    [appWebIconView setImage:icon];
        //改

    JCRBlurView* cellLine = (JCRBlurView*) [cell viewWithTag:4];
    [cellLine setAlpha:0.2f];

    CLLocationDistance meters = [locationManager.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:[[obj valueForKey:@"lat"] doubleValue] longitude:[[obj valueForKey:@"lng"] doubleValue]]];

    NSLog(@"meters >> %f", ceil(meters));
    UILabel* distanceLabel = (UILabel*) [cell viewWithTag:3];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setTextAlignment:NSTextAlignmentCenter];
    [distanceLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:20.f]];
    [distanceLabel setTextColor:[UIColor whiteColor]];

    if (ceil(meters) < 1000.f) {
        [distanceLabel setText:[NSString stringWithFormat:@"%dm",(int)(ceil(meters))]];
    }else if (meters >= 1000.f)
        [distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",(ceil(meters)/1000.f)]];


//    [distanceLabel setText:@"25ft"];


    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 220.f;
    }
    return 60.0f;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    JCRBlurView* footView = [[JCRBlurView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 42.f)];
//    [footView setBlurTintColor:[UIColor clearColor]];
//    return footView;
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 42.f;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{



    if (indexPath.row !=0) {

//    NSLog(@"didSelectRowAtIndexPath >> %d", indexPath.row);

        self.sourceView = [self.tableView cellForRowAtIndexPath:indexPath];

    id obj = [datasourceArray objectAtIndex:indexPath.row - 1];
//    PageViewController *pageViewController = [[PageViewController alloc] init];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    CSParallaxHeaderViewController *pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSParallaxHeaderViewController"];

    [pageViewController setBeaconObj:obj];
//    pageViewController.data = data;
    pageViewController.currentPage = indexPath.row;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:pageViewController animated:YES];

    }

}




#pragma mark - Navigation Controller Delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    // Check if we're transitioning from this view controller to StepPageViewController
    if (fromVC == self && [toVC isKindOfClass:[CSParallaxHeaderViewController class]]) {
        CellToPageViewAnimation *cellToPageViewAnimation = [[CellToPageViewAnimation alloc] init];
        cellToPageViewAnimation.sourceView = self.sourceView;
        return cellToPageViewAnimation;
    }
    return nil;
}

#pragma mark - scrollView


//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    MainHostViewController* parentView = (MainHostViewController*)(self.parentViewController.parentViewController);
//
//    [parentView.flatRoundedButton setAlpha:1.0];
//
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    MainHostViewController* parentView = (MainHostViewController*)(self.parentViewController.parentViewController);
//
//    [parentView.flatRoundedButton setAlpha:0.2];
//
//}

-(BOOL)shouldFetchUserLocation{

    BOOL shouldFetchLocation= NO;

    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
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

#pragma mark - locationManager delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{


    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
    }else if(status == kCLAuthorizationStatusNotDetermined){
        NSLog(@"kCLAuthorizationStatusNotDetermined");
            //      [locationManager startUpdatingLocation];
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
    NSString *stateString = nil;
    switch (state) {
        case CLRegionStateInside:
            stateString = @"inside";
            break;
        case CLRegionStateOutside:
            stateString = @"outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"unknown";
            break;
    }
    
    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSString *alertBody = [NSString stringWithFormat:@"Notification determined (%@): %@-%@", stateString, [beaconRegion major], [beaconRegion minor]];
    NSLog(@"%@", alertBody);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"didEnterRegion");

    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
    NSString *monitorBeaconId = [NSString stringWithFormat:@"%@-%@-%@", [beaconRegion.proximityUUID UUIDString], [beaconRegion major], [beaconRegion minor]];
    [[NSUserDefaults standardUserDefaults] setObject:monitorBeaconId forKey:@"monitorBeaconId"];
    NSString *alertBody = [NSString stringWithFormat:@"Notification triggered: %@-%@", [beaconRegion major], [beaconRegion minor]];
    
    UILocalNotification *aNotification = [[UILocalNotification alloc] init];
    aNotification.timeZone = [NSTimeZone defaultTimeZone];
    aNotification.alertBody = alertBody;
    aNotification.alertAction = @"Details";
    aNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    if ([self shouldSendNotification:beaconRegion]) {
        [[UIApplication sharedApplication] scheduleLocalNotification:aNotification];
    }

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

        datasourceArray = [NSMutableArray new];
        AFHTTPRequestOperationManager *afhttpManager = [AFHTTPRequestOperationManager manager];
//        [NSString stringWithFormat:@"http://beaconhub.herokuapp.com/search/near/%f/%f.json", location.coordinate.latitude, location.coordinate.longitude];
        [afhttpManager GET:[NSString stringWithFormat:@"http://beaconhub.herokuapp.com/search/near/%f/%f.json", location.coordinate.latitude, location.coordinate.longitude] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

            if (responseObject != nil) {

                NSString *responseString = [operation responseString];
                NSData *data1= [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                NSArray* results = [NSJSONSerialization JSONObjectWithData:data1
                                                                   options:0
                                                                     error:&error];
                for (id obj in results)
                {

                    [datasourceArray addObject: obj];

                    CLBeaconRegion* hackathonRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:[obj objectForKey:@"uuid"]] major:[[obj objectForKey:@"major"] integerValue] minor:[[obj objectForKey:@"minor"] integerValue] identifier:[NSString stringWithFormat:@"beacon-%@-%@-%@", [obj objectForKey:@"uuid"], [obj objectForKey:@"major"], [obj objectForKey:@"minor"]]];
                    
                    [hackathonRegion setNotifyOnEntry:YES];
                    [hackathonRegion setNotifyOnExit:YES];
                    [hackathonRegion setNotifyEntryStateOnDisplay:YES];
                    
                    NSString *beaconId = [NSString stringWithFormat:@"%@-%@-%@", [obj objectForKey:@"uuid"], [obj objectForKey:@"major"], [obj objectForKey:@"minor"]];
                    
                    [locationManager startMonitoringForRegion:hackathonRegion];
                    [locationManager startRangingBeaconsInRegion:hackathonRegion];
                
                }

                    //NSLog(@"result.count >> %d", results.count);
                [self.tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    }

    CLGeocoder *locationGeocoded = [[CLGeocoder alloc] init];
    [locationGeocoded reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];

        NSLog(@"currentPlaceMArk >> %@", placemark.name);
        if (placemark == nil) {
            currentPlaceMark = @"UNKNOWN";
        }else{
            currentPlaceMark = placemark.name;
        }
        [self.tableView reloadData];
    }];


//    NSString* requestString = [NSString stringWithFormat:@"http://beaconhub.herokuapp.com/search/near/%.6f/%.6f/14.json", location.coordinate.latitude, location.coordinate.longitude];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailed >> %@", error);
}

- (BOOL)shouldSendNotification:(CLBeaconRegion *)region
{
    NSDictionary *lastDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastBeaconId"];
    NSString *lastBeaconId = [lastDict objectForKey:@"beaconId"];
    NSDate *lastDate = [lastDict objectForKey:@"updated_at"];
    NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
    NSString *currentBeaconId = [NSString stringWithFormat:@"%@-%@-%@", [region.proximityUUID UUIDString], [region major], [region minor]];
    
    NSDate *currentDate = [[NSDate alloc] init];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
    NSDictionary *dict = @{@"beaconId": currentBeaconId, @"updated_at": currentDate};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"lastBeaconId"];
    
    if ([currentBeaconId isEqualToString:lastBeaconId] && currentTime - lastTime <= 3600) {
        return NO;
    } else {
        return YES;
    };
}

    ////

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;    //count of section
//}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return datasourceArray.count;    //count number of row from counting array hear cataGorry is An Array
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *MyIdentifier = @"Cell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//
//    if (cell == nil)
//        {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:MyIdentifier];
//        }
//
//        //    id bufferObj = [datasourceArray objectAtIndex:indexPath.row];
//        //
//        //    UILabel* beaconNameLabel = (UILabel*) [cell viewWithTag:11];
//        //    UILabel* beaconOwnerLabel = (UILabel*) [cell viewWithTag:12];
//        //    UILabel* uuidLabel = (UILabel*) [cell viewWithTag:13];
//        //
//        //    [beaconNameLabel setText:[bufferObj objectForKey:@"name"]];
//        //    [beaconOwnerLabel setText:[bufferObj objectForKey:@"address"]];
//        //    [uuidLabel setText:[bufferObj objectForKey:@"uuid"]];
//
//
//        //    NSLog(@"bufferObj >> %@", bufferObj);
//
//        //    address = "Langham Place, Mongkok, Hong Kong";
//        //    description = "";
//        //    id = 7;
//        //    lat = "22.31824";
//        //    link = "http://www.langhamplace.com.hk/";
//        //    lng = "114.16796";
//        //    major = 1;
//        //    minor = 1;
//        //    name = "Langham Place";
//        //    url = "http://beaconhub.herokuapp.com/beacons/7.json";
//        //    uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
//
//        // Here we use the provided setImageWithURL: method to load the web image
//        // Ensure you use a placeholder image otherwise cells will be initialized with no image
//        //    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://example.com/image.jpg"]
//        //                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
//        //    cell.textLabel.text = @"My Text";
//    return cell;
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//        //    NSLog(@"didSelectRowAtIndexPath >> %ld", indexPath.row);
//
//
//        //    Yourstring=[catagorry objectAtIndex:indexPath.row];
//        //
//        //        //Pushing next view
//        //    cntrSecondViewController *cntrinnerService = [[cntrSecondViewController alloc] initWithNibName:@"cntrSecondViewController" bundle:nil];
//        //    [self.navigationController pushViewController:cntrinnerService animated:YES];
//
//}

#pragma mark - StoryBoard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    BeaconDetailViewController *nextView = segue.destinationViewController;
//
//    id bufferObj = [datasourceArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
//
//
//    [nextView setBeaconObj:bufferObj];





    NSLog(@"prepareforSegue");
        // nextView


}

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
