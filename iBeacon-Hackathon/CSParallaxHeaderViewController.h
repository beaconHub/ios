//
//  ViewController.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 8/1/14.
//  Copyright (c) 2014 James Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewToCellAnimation.h"
#import "TableViewController.h"
#import <MapKit/MapKit.h>

@interface CSParallaxHeaderViewController : UICollectionViewController<UINavigationControllerDelegate, MKMapViewDelegate>
@property (nonatomic, assign) id<GestureRecognizerDelegate> gestureRecognizerDelegate;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) id beaconObj;
@end
