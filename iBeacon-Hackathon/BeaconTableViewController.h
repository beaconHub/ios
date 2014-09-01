//
//  BeaconTableViewController.h
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 30/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
#import "CellToPageViewAnimation.h"

@interface BeaconTableViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *sourceView;

@end
