//
//  TableViewController.h
//  CellToPageViewTransition
//
//  Created by Jack Shi on 27/06/2014.
//  Copyright (c) 2014 Jack Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "CellToPageViewAnimation.h"
#import <CoreLocation/CoreLocation.h>
#import "UIScrollView+EmptyDataSet.h"

@interface TableViewController : UITableViewController<UINavigationControllerDelegate,CLLocationManagerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    CLLocationManager* locationManager;

    NSMutableDictionary* jsonResponseDictionary;
    NSMutableArray* datasourceArray;
    NSString* currentPlaceMark;

}

@property (nonatomic, strong) UIView *sourceView;

@end
