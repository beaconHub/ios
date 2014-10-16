//
//  BeaconDetailViewController.m
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 16/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//


#define IMAGE_VIEW_TAG 100
#define IMAGE_SCROLL_VIEW_TAG 101
#define CONTENT_IMAGE_VIEW_TAG 102

#import "BeaconDetailViewController.h"
#import "MHYahooParallaxView.h"
#import "MHTsekotCell.h"

@interface BeaconDetailViewController ()<MHYahooParallaxViewDatasource,MHYahooParallaxViewDelegate,UITableViewDelegate,UITableViewDataSource>

@end
@implementation BeaconDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    _imageHeaderHeight = self.view.frame.size.height * 0.70f;

    MHYahooParallaxView * parallaxView = [[MHYahooParallaxView alloc]initWithFrame:CGRectMake(0.0f,0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [parallaxView registerClass:[MHTsekotCell class] forCellWithReuseIdentifier:[MHTsekotCell reuseIdentifier]];
    parallaxView.delegate = self;
    parallaxView.datasource = self;
    [self.view addSubview:parallaxView];

//    NSLog(@"beaonObj >> %@", self.beaconObj);

        // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - ParallaxView Datasource and Delegate
- (UICollectionViewCell*) parallaxView:(MHYahooParallaxView *)parallaxView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHTsekotCell * tsekotCell = (MHTsekotCell*)[parallaxView dequeueReusableCellWithReuseIdentifier:[MHTsekotCell reuseIdentifier] forIndexPath:indexPath];
    tsekotCell.delegate = self;
    tsekotCell.datasource = self;
    tsekotCell.tsekotTableView.tag = indexPath.row;
    
    tsekotCell.tsekotTableView.contentOffset = CGPointMake(0.0f, 0.0f);
    
    [tsekotCell setBackgroundColor:[UIColor redColor]];
    [tsekotCell.tsekotTableView reloadData];

    return tsekotCell;
}


- (NSInteger) numberOfRowsInParallaxView:(MHYahooParallaxView *)parallaxView {
    return 1;
}

- (void)parallaxViewDidScrollHorizontally:(MHYahooParallaxView *)parallaxView leftIndex:(NSInteger)leftIndex leftImageLeftMargin:(CGFloat)leftImageLeftMargin leftImageWidth:(CGFloat)leftImageWidth rightIndex:(NSInteger)rightIndex rightImageLeftMargin:(CGFloat)rightImageLeftMargin rightImageWidth:(CGFloat)rightImageWidth {

        // leftIndex and Right Index should must be greater than or equal to zero
    
//    NSLog(@"parallaxViewDidScrollHorizontally >> %d", rightIndex);

    if(leftIndex >= 0){
        MHTsekotCell * leftCell = (MHTsekotCell*)[parallaxView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:leftIndex inSection:0]];
        UITableViewCell * tvCell = [leftCell.tsekotTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

        UIImageView *iv = (UIImageView*)[tvCell viewWithTag:100];
        
        CGRect frame = iv.frame;
        frame.origin.x = leftImageLeftMargin;
        frame.size.width = leftImageWidth;
        iv.frame = frame;
        [iv setBackgroundColor:[UIColor lightGrayColor]];
    }
    if(rightIndex >= 0){
        MHTsekotCell * rigthCell = (MHTsekotCell*)[parallaxView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:rightIndex inSection:0]];
        UITableViewCell * tvCell = [rigthCell.tsekotTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

        UIImageView *iv = (UIImageView*)[tvCell viewWithTag:100];
        CGRect frame = iv.frame;
        frame.origin.x = rightImageLeftMargin;
        frame.size.width = rightImageWidth;
        iv.frame = frame;
        [iv setBackgroundColor:[UIColor lightGrayColor]];

    }
}

#pragma mark - TableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return _imageHeaderHeight;
    }
    return 568.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if(indexPath.row == 0){
        static NSString * headerId = @"headerCell";
        cell = [tableView dequeueReusableCellWithIdentifier:headerId];
        if(!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:headerId];
            cell.backgroundColor = [UIColor clearColor];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, cell.contentView.frame.size.width,_imageHeaderHeight)];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.tag = IMAGE_VIEW_TAG;
            imageView.clipsToBounds = YES;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            UIScrollView * svImage = [[UIScrollView alloc]initWithFrame:imageView.frame];
            svImage.delegate = self;
            svImage.userInteractionEnabled = NO;

            [svImage addSubview:imageView];

            svImage.tag = IMAGE_SCROLL_VIEW_TAG;
            svImage.backgroundColor = [UIColor blackColor];
            svImage.zoomScale = 1.0f;
            svImage.minimumZoomScale = 1.0f;
            svImage.maximumZoomScale = 2.0f;
            [cell.contentView addSubview:svImage];
            UIImageView * headerInfo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header_bg"]];

            [cell.contentView addSubview:headerInfo];

            UIView* view01 = [[UIView alloc] initWithFrame:CGRectMake(0, _imageHeaderHeight - 120.0f, 115, 50)];
            [view01 setBackgroundColor:[UIColor whiteColor]];
            
            UIImageView* companyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beaconHub_largelogo.png"]];
            [companyImageView setFrame:CGRectMake(0, 0, view01.frame.size.width, view01.frame.size.height)];
            [companyImageView setContentMode:UIViewContentModeScaleAspectFit];
            
            [view01 addSubview:companyImageView];
            [cell.contentView addSubview:view01];
            
            
         //   [cell.contentView bringSubviewToFront:view01];
            
            UIView* view02 = [[UIView alloc] initWithFrame:CGRectMake(110, _imageHeaderHeight - 70.f, 210, 35)];
            [view02 setBackgroundColor:[UIColor whiteColor]];


            UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, _imageHeaderHeight - 60.f, 150, 35)];
            [nameLabel setText:[self.beaconObj objectForKey:@"name"]];
            [nameLabel setTextAlignment:NSTextAlignmentRight];
            [cell.contentView addSubview:nameLabel];

            //[cell.contentView addSubview:view02];
            
            UIView* view03 = [[UIView alloc] initWithFrame:CGRectMake(110, _imageHeaderHeight - 25.f, 210, 20)];
            [view03 setBackgroundColor:[UIColor whiteColor]];
            //[cell.contentView addSubview:view03];
            

            CGRect headerFrame = headerInfo.frame;
            headerFrame.size.height = 149.0f;
            headerFrame.origin.y = _imageHeaderHeight - 149.0f;
            headerInfo.frame = headerFrame;

        }

        UIImageView *imageView = (UIImageView*)[cell viewWithTag:IMAGE_VIEW_TAG];
       // [imageView setBackgroundColor:[UIColor greenColor]];
        imageView.image = [UIImage imageNamed:@"harryng.jpg"];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
    } else {
        static NSString * detailId = @"detailCell";
        cell = [tableView dequeueReusableCellWithIdentifier:detailId];
        if(!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:detailId];
//            [cell setBackgroundColor:[UIColor redColor]];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 568.0f)];
            imageView.tag = CONTENT_IMAGE_VIEW_TAG;
            [cell.contentView addSubview:imageView];

            UILabel* tab1Label = [[UILabel alloc] initWithFrame:CGRectMake(38, 10.0f, 100, 30)];
            [tab1Label setText:@"Info"];
            [tab1Label setBackgroundColor:[UIColor clearColor]];
            [tab1Label setTextColor:[UIColor darkGrayColor]];
            [cell.contentView addSubview:tab1Label];

        }
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:CONTENT_IMAGE_VIEW_TAG];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"content-%li",(tableView.tag%3) + 1]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
    }

    return cell;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.tag == IMAGE_SCROLL_VIEW_TAG) return;
    UITableView * tv = (UITableView*) scrollView;
    UITableViewCell * cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UIScrollView * svImage = (UIScrollView*)[cell viewWithTag:IMAGE_SCROLL_VIEW_TAG];
    CGRect frame = svImage.frame;
    frame.size.height =  MAX((_imageHeaderHeight-tv.contentOffset.y),0);
    frame.origin.y = tv.contentOffset.y;
    svImage.frame = frame;
    svImage.zoomScale = 1 + (abs(MIN(tv.contentOffset.y,0))/320.0f);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:IMAGE_VIEW_TAG];
}

@end
