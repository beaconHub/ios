//
//  ViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 8/1/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

#import "CSParallaxHeaderViewController.h"
#import "CSCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "MainHostViewController.h"
#import "ChameleonFramework/Chameleon.h"
#import <TOMSMorphingLabel/TOMSMorphingLabel.h>
#import "WebViewController.h"

@interface CSParallaxHeaderViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UINib *headerNib;

@end

@implementation CSParallaxHeaderViewController
{
    NSMutableArray *viewControllers;
    PageViewToCellAnimation *pageViewToCellAnimation;
    NSString *serviceUrl;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        
        self.headerNib = [UINib nibWithNibName:@"CSParallaxHeader" bundle:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MainHostViewController* parentView = (MainHostViewController*)(self.navigationController.parentViewController);
        //[parentView.flatRoundedButton setAlpha:1.0];

    [parentView.flatRoundedButton animateToType:buttonMenuType];
    [parentView.headerLabel setText:@"beaconHub"];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

        // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

        // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark - Navigation Controller Delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
        // Check if we're transitioning from this view controller to PageViewController
    if (fromVC == self && [toVC isKindOfClass:[TableViewController class]]) {
            // As user may swipe the page view, find out the indexPath that animation should return to
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];;



        [((TableViewController *)toVC).tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        pageViewToCellAnimation.sourceView = [((TableViewController *)toVC).tableView cellForRowAtIndexPath:indexPath];
        return pageViewToCellAnimation;
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
        // Check if this is for PageViewToCellAnimationcustom transition
    if ([animationController isKindOfClass:[PageViewToCellAnimation class]]) {
        return ((PageViewToCellAnimation *)animationController).interactiveTransition;
    }
    return nil;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
}

- (void)viewDidLoad
{
//    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 200);
    }
    
    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];

    self.view.backgroundColor = [UIColor clearColor];

    NSDictionary* nameDict = [NSDictionary new];
    NSDictionary* descriptionDict = [NSDictionary new];
    NSDictionary* addressDict = [NSDictionary new];

    if ([self.beaconObj valueForKey:@"name"] != [NSNull null])
        nameDict = @{@"NAME":[self.beaconObj valueForKey:@"name"]};
    else
        nameDict = @{@"NAME":@"N/A"};



    if ([self.beaconObj valueForKey:@"description"] != [NSNull null]) {
        descriptionDict = @{@"DESCRIPTION":[self.beaconObj valueForKey:@"description"]};

    }else
        descriptionDict = @{@"DESCRIPTION":@"N/A"};


    if ([self.beaconObj valueForKey:@"address"] != [NSNull null])
        addressDict = @{@"ADDRESS":[self.beaconObj valueForKey:@"address"]};
    else
        addressDict = @{@"ADDRESS":@"N/A"};

    self.sections = @[
                      nameDict,
                      descriptionDict,
                      addressDict
                      ];
    
    serviceUrl = [self.beaconObj valueForKey:@"link"];


//    NSLog(@"CSParallaxHeaderViewController obj >> %@", self.beaconObj);

    pageViewToCellAnimation = [[PageViewToCellAnimation alloc] initWithNavigationController:self.navigationController];

        // setup a pinch gesture recognizer and make the target the custom transition handler
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:pageViewToCellAnimation action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    [self.view setBackgroundColor:FlatRed];
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count] ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSLog(@"section >> %d", section);
//    if (section == 4) {
//        return 0;
//    }



    return 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *obj = self.sections[indexPath.section];

    CSCell *cell = [CSCell new];

    if (indexPath.row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                  forIndexPath:indexPath];


        cell.textLabel.text = [[obj allValues] firstObject];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"urlCell"
                                                         forIndexPath:indexPath];

        UIButton* btn = (UIButton*) [cell viewWithTag:1];
        [btn addTarget:self action:@selector(urlButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [cell setBackgroundColor:FlatRed];

    }

    return cell;
}

- (void) urlButtonPressed
{
    NSLog(@"<CSParallaxHeaderViewController> urlButtonPressed");
    NSLog(@"link -> %@", serviceUrl);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return CGSizeMake(320, 50);
    }else
        return CGSizeMake(320, 0);
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

//    if (indexPath.section == 4) {
//        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                            withReuseIdentifier:@"urlCell"
//                                                                                   forIndexPath:indexPath];
//
//        return cell;
//    }

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        NSDictionary *obj = self.sections[indexPath.section];

        CSCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"sectionHeader"
                                                                 forIndexPath:indexPath];
        [cell setBackgroundColor:FlatSkyBlue];
        cell.textLabel.text = [[obj allKeys] firstObject];

        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        MKMapView* mapView = (MKMapView*) [cell viewWithTag:1];

        [mapView setDelegate:self];

        NSLog(@"mapview obj lat  >> %@", [self.beaconObj valueForKey:@"lat"]);
        NSLog(@"mapview obj lng  >> %@", [self.beaconObj valueForKey:@"lng"]);

//        MKCoordinateRegionMake(<#CLLocationCoordinate2D centerCoordinate#>, <#MKCoordinateSpan span#>)
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([[self.beaconObj valueForKey:@"lat"] doubleValue], [[self.beaconObj valueForKey:@"lng"] doubleValue]), 800, 800);

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake([[self.beaconObj valueForKey:@"lat"] doubleValue], [[self.beaconObj valueForKey:@"lng"] doubleValue])];




       [mapView setRegion:[mapView regionThatFits:region] animated:YES];
        [mapView addAnnotation:annotation];
        return cell;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        NSLog(@"its footer");

        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"footer"
                                                                                   forIndexPath:indexPath];
        UIButton* btn = (UIButton*) [cell viewWithTag:1];
        [btn addTarget:self action:@selector(urlButtonPressed) forControlEvents:UIControlEventTouchUpInside];

        [cell setBackgroundColor:FlatRed];
        return cell;
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    WebViewController* nextView = (WebViewController*)segue.destinationViewController;

    [nextView setUrlString:[self.beaconObj valueForKey:@"url"]];

    if ([self.beaconObj valueForKey:@"name"] != [NSNull null])
        [nextView setBeaconName:[self.beaconObj valueForKey:@"name"];
    else
         [nextView setBeaconName:@"NULL"];

//    NSLog(@"%@", self.beaconObj);
}



//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
//}
@end
