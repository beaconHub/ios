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
    AFHTTPRequestOperationManager *afhttpManager = [AFHTTPRequestOperationManager manager];
    [afhttpManager GET:@"http://beaconhub.herokuapp.com/search/near/22.3657233/114.0464272/15.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);

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
                    //                NSDictionary *res=[results objectAtIndex:i];
                    //                NSDictionary *res2=[res objectForKey:@"post"];
                    //                [self.storesArray addObject:res2];

                }

                //NSLog(@"result.count >> %d", results.count);
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];


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
    static NSString *cellIdentifier = @"Cell";

        //check
    UITableViewCell *cell = nil;
        //check





    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Row0Cell"];
        }else
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    cell.backgroundColor = FlatSkyBlue;
    if (indexPath.row == 0){

        UILabel* locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320, 20)];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [locationLabel setTextColor:[UIColor whiteColor]];
        [locationLabel setTextAlignment:NSTextAlignmentCenter];
        [locationLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:23.f]];
        [locationLabel setText:@"PRINCE EDWARD"];




        UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 320, 115)];
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextColor:[UIColor whiteColor]];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [numberLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:90.f]];
        [numberLabel setText:@"39"];

        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 320, 15)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.f]];
        [textLabel setText:@"beacon services found"];

//        UILabel*
        [cell addSubview:locationLabel];

        [cell addSubview:numberLabel];
        [cell addSubview:textLabel];
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


    UILabel* distanceLabel = (UILabel*) [cell viewWithTag:3];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setTextAlignment:NSTextAlignmentCenter];
    [distanceLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:20.f]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setText:@"25ft"];

//    [cell addSubview:distanceLabel];


        //  [cell addSubview:cellLine];

//    [cell addSubview:appWebIconView];
//    cell.textLabel.text = data[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
//
//    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
//    [headerLabel setBackgroundColor:[UIColor clearColor]];
//    [headerLabel setTextColor:[UIColor whiteColor]];
//    [headerLabel setTextAlignment:NSTextAlignmentCenter];
//    [headerLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.f]];
//    [headerLabel setText:@"Discover"];
//
//    [headerView addSubview:headerLabel];
//
//        //    2014-08-30 23:18:01.582 iBeacon-Hackathon[878:476584] Proxima Nova
//        //    2014-08-30 23:18:01.582 iBeacon-Hackathon[878:476584] ProximaNova-Regular
//        //    2014-08-30 23:18:01.582 iBeacon-Hackathon[878:476584] ProximaNovaT-Thin
//        //    2014-08-30 23:18:01.583 iBeacon-Hackathon[878:476584] ProximaNova-Bold
//        //    2014-08-30 23:18:01.583 iBeacon-Hackathon[878:476584] ProximaNova-Light
//
//    [headerView setBackgroundColor:FlatSkyBlue];
//
//    return headerView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 60.f;
//}


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
    self.sourceView = [self.tableView cellForRowAtIndexPath:indexPath];


    NSLog(@"didSelectRowAtIndexPath >> %d", indexPath.row);

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


    NSString* requestString = [NSString stringWithFormat:@"http://beaconhub.herokuapp.com/search/near/%.6f/%.6f/14.json", location.coordinate.latitude, location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailed >> %@", error);
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
