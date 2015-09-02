//
//  SITLGalleryDetailedPageViewController.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

#import "SITLGalleryModel.h"

@interface SITLGalleryDetailedPageViewController : UIPageViewController

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, copy) void (^searchGalleryByTagBlock)(NSString *tag);

@property (weak) SITLGalleryModel *gallery;
@property (assign) NSInteger currentIndex;

@end
