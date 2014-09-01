//
//  MainHostViewController.m
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 30/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import "MainHostViewController.h"
#import "ChameleonFramework/Chameleon.h"
#import "JCRBlurView.h"
#import "CSParallaxHeaderViewController.h"
#import "TableViewController.h"
#import "WebViewController.h"

@interface MainHostViewController ()

@end

@implementation MainHostViewController{
    NSMutableArray *viewControllers;
    PageViewToCellAnimation *pageViewToCellAnimation;
}


//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
- (void)viewDidLoad {
    [super viewDidLoad];

        //加返scan for beacons


//[self setNeedsStatusBarAppearanceUpdate];
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(15, 30, 18, 18)
                                                         buttonType:buttonAddType
                                                        buttonStyle:buttonPlainStyle];
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithRed:128/255.f green:169/255.f blue:217/255.f alpha:1.0];
    self.flatRoundedButton.lineThickness = 2;
    self.flatRoundedButton.linesColor = FlatSkyBlue;
    [self.flatRoundedButton addTarget:self
                               action:@selector(buttonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
//   [self.view addSubview:self.flatRoundedButton];



    JCRBlurView* headerBar = [[JCRBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    headerBar

//    [headerBar setBackgroundColor:FlatSkyBlue];
    [headerBar setTintColor:FlatSkyBlue];

    self.headerLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
    [self.headerLabel setBackgroundColor:[UIColor clearColor]];
    [self.headerLabel setTextColor:FlatSkyBlue];
    [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.headerLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:22.f]];
    [self.headerLabel setText:@"Discover"];

    [headerBar addSubview:self.headerLabel];


    [headerBar addSubview:self.flatRoundedButton];



    [self.view addSubview:headerBar];




    // Do any additional setup after loading the view.

        //128 169 217
}

- (void)buttonPressed:(UIButton*) sender
{
    NSLog(@"buttonPressed");

    NSLog(@"presenting viewcontroller >> %@", [(UINavigationController*)[self.childViewControllers objectAtIndex:0] visibleViewController]);

    if ([[(UINavigationController*)[self.childViewControllers objectAtIndex:0] visibleViewController] isKindOfClass:[CSParallaxHeaderViewController class]]) {
        pageViewToCellAnimation = [[PageViewToCellAnimation alloc] initWithNavigationController:(UINavigationController*)[self.childViewControllers objectAtIndex:0]];
        UINavigationController *nav = (UINavigationController*)[self.childViewControllers objectAtIndex:0];
        [nav popViewControllerAnimated:YES];
        NSLog(@"its now csparallaxheaderviewcontroller >> %@", pageViewToCellAnimation.navigationController);
    }else if([[(UINavigationController*)[self.childViewControllers objectAtIndex:0] visibleViewController] isKindOfClass:[TableViewController class]]){
        NSLog(@"its now tableviewcontroller");

    }else if ([[(UINavigationController*)[self.childViewControllers objectAtIndex:0] visibleViewController] isKindOfClass:[WebViewController class]]){
        UINavigationController *nav = (UINavigationController*)[self.childViewControllers objectAtIndex:0];
        [nav popViewControllerAnimated:YES];
    }


//    NSLog(@"buttonPressed >> %d", self.flatRoundedButton.currentButtonType);

//    if (self.flatRoundedButton.currentButtonType == 4) {
//        [self.flatRoundedButton animateToType:buttonMenuType];
//    }else if(self.flatRoundedButton.currentButtonType == 6){
//        [self.flatRoundedButton animateToType:buttonBackType];
//
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"MainHostViewController prepareForSegue");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
