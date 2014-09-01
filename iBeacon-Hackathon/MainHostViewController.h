//
//  MainHostViewController.h
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 30/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VBFDoubleSegment.h>
#import <VBFPopFlatButton.h>
#import <TOMSMorphingLabel/TOMSMorphingLabel.h>
#import "PageViewToCellAnimation.h"



@interface MainHostViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic, assign) id<GestureRecognizerDelegate> gestureRecognizerDelegate;

@property (strong, nonatomic) VBFPopFlatButton *flatRoundedButton;
@property (strong, nonatomic) TOMSMorphingLabel* headerLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
