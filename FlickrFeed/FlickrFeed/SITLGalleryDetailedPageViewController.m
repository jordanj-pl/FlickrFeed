//
//  SITLGalleryDetailedPageViewController.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryDetailedPageViewController.h"

#import "SITLGalleryDetailedViewController.h"

@interface SITLGalleryDetailedPageViewController ()<UIPageViewControllerDataSource>

@end

@implementation SITLGalleryDetailedPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [dismissBtn setFrame:CGRectMake(20, 30, 100, 30)];//TODO add constraints to make it flexible and align to the right
    [dismissBtn setTitle:@"close" forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: dismissBtn];
    
    [self setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)close {
    self.dismissBlock();
}

#pragma mark - UIPageViewControllerDataSource implementation

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    SITLGalleryDetailedViewController *detailedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryDetailedViewController"];
    
    if( ((SITLGalleryDetailedViewController*)viewController).itemIndex > 0 ) {
        NSInteger index = ((SITLGalleryDetailedViewController*)viewController).itemIndex-1;

        SITLGalleryItemModel *item = self.gallery.items[index];
        detailedViewController.item = item;
        detailedViewController.itemIndex = index;
        
        return detailedViewController;
    } else {
        return nil;
    }
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    SITLGalleryDetailedViewController *detailedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryDetailedViewController"];
    
    if( ((SITLGalleryDetailedViewController*)viewController).itemIndex < ([self.gallery.items count]-1) ) {
        NSInteger index = ((SITLGalleryDetailedViewController*)viewController).itemIndex+1;
        
        SITLGalleryItemModel *item = self.gallery.items[index];
        detailedViewController.item = item;
        detailedViewController.itemIndex = index;
        
        return detailedViewController;
    } else {
        return nil;
    }
}

@end
