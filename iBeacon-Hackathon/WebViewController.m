//
//  WebViewController.m
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 1/9/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import "WebViewController.h"
#import "MainHostViewController.h"

#import <OTMWebView/OTMWebViewProgressBar.h>

@interface WebViewController ()
@property (strong, nonatomic) OTMWebViewProgressBar *progressBar;
-(void)barButtonItemAction:(UIBarButtonItem *)item;
@end

@implementation WebViewController




- (void)viewDidLoad {

    [super viewDidLoad];

    [self setTitle:self.beaconName];
    // Do any additional setup after loading the view.

    self.webView.userAgent = @"My User Agent String";
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.scalesPageToFit = YES;



    UINavigationBar *navBar = self.navigationController.navigationBar;

    self.progressBar = [[OTMWebViewProgressBar alloc]init];
    CGFloat progressBarHeight = 3.0;
    self.progressBar.frame = CGRectMake(0.0, 60 , 320, progressBarHeight);
    self.progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

//    [self.progressBar setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.progressBar];


    NSLog(@"self.webView.delegate >> %@", self.urlString);

//    NSLog(@"self.progressbar >> %f %f %f %f", self.progressBar.frame.origin.x, self.progressBar.frame.origin.y, self.progressBar.frame.size.width, self.progressBar.frame.size.height);

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];


    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemAction:)];

    backItem.tag = 0;

    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc]initWithTitle:@"Forward" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemAction:)];
    forwardItem.tag = 1;

    self.toolbarItems = @[backItem, forwardItem];
//    self.navigationController.toolbarHidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;

    MainHostViewController* parentView = (MainHostViewController*)(self.navigationController.parentViewController);
        //[parentView.flatRoundedButton setAlpha:1.0];

    [parentView.flatRoundedButton animateToType:buttonBackType];
    [parentView.headerLabel setText:self.beaconName];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)barButtonItemAction:(UIBarButtonItem *)item {

    if (item.tag == 0) {

        [self.webView goBack];

    } else if (item.tag == 1) {

        [self.webView goForward];
    }
}


-(void)webViewProgressDidStart:(OTMWebView *)webView {

    NSLog(@"webViewProgressDidStart");

}

-(void)webView:(OTMWebView *)progressTracker progressDidChange:(double)progress {


    NSLog(@"progressDidChange");
    [self.progressBar setProgress:progress animated:YES];
}

-(void)webViewProgressDidFinish:(OTMWebView *)webView {


    NSLog(@"webViewProgressDidFinish");
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     [self.progressView setProgress:0.0];

     });
     */
}

-(void)webView:(OTMWebView *)webView documentTitleDidChange:(NSString *)title {

    self.navigationItem.title = title;
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
