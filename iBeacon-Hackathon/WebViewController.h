//
//  WebViewController.h
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 1/9/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OTMWebView/OTMWebView.h>
@interface WebViewController : UIViewController <OTMWebViewDelegate>
@property (strong, nonatomic) IBOutlet OTMWebView *webView;

@property (nonatomic, copy) NSString* urlString;

@end
