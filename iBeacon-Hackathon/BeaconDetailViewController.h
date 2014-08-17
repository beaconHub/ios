//
//  BeaconDetailViewController.h
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 16/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconDetailViewController : UIViewController{
    CGFloat _imageHeaderHeight;
}
@property (nonatomic, copy) NSString* beaconOwnerName;


@property (strong, nonatomic) NSDictionary* beaconObj;

@end
