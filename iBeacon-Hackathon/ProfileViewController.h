//
//  ProfileViewController.h
//  Ripple
//
//  Created by Meng To on 20/12/13.
//  Copyright (c) 2013 Meng To. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
- (IBAction)facebookDidPress:(id)sender;
- (IBAction)twitterDidPress:(id)sender;
- (IBAction)profileDidPress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end
