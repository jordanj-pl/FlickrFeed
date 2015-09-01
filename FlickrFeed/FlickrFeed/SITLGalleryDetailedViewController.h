//
//  SITLGalleryDetailedViewController.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

#import "SITLGalleryItemModel.h"

@interface SITLGalleryDetailedViewController : UIViewController

@property (nonatomic, copy) void (^dismissBlock)(void);

@property (nonatomic, strong) SITLGalleryItemModel *item;

@end
