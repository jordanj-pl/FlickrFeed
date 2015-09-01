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

@property (nonatomic, strong) SITLGalleryItemModel *item;
@property (nonatomic, assign) NSInteger itemIndex;

@end
