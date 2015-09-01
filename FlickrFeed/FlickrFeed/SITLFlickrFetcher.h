//
//  SITLFlickrFetcher.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

#import "SITLGalleryModel.h"

@interface SITLFlickrFetcher : NSObject

-(void)fetchGalleryForDefaultChannelWithCompletion:(void(^)(SITLGalleryModel *gallery, NSError *error))completion;

-(void)fetchImageForItem:(SITLGalleryItemModel*)item withCompletion:(void(^)(UIImage *image))completion;

@end
