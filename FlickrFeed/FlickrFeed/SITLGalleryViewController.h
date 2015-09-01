//
//  SITLGalleryViewController.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

#import "SITLFlickrFetcher.h"

@interface SITLGalleryViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong) SITLFlickrFetcher *fetcher;

@end
