//
//  WebViewController.m
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 1/9/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import "WebViewController.h"
#import "MainHostViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MainHostViewController* parentView = (MainHostViewController*)(self.navigationController.parentViewController);
        //[parentView.flatRoundedButton setAlpha:1.0];

    [parentView.flatRoundedButton animateToType:buttonBackType];
    [parentView.headerLabel setText:@"webView"];
    
    
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
