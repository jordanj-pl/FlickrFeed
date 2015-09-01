//
//  SITLGalleryItemModel.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

#import "SITLGalleryAuthorModel.h"

@interface SITLGalleryItemModel : NSObject

@property (strong, readonly) NSString *flickrId;
@property (strong, readonly) NSString *title;
@property (strong, readonly) NSString *content;
@property (strong, readonly) NSDate *dateTaken;
@property (strong, readonly) NSDate *datePublished;
@property (strong, readonly) NSDate *dateUpdated;
@property (strong, readonly) NSURL *imageURL;
@property (strong, readonly) UIImage *thumbnail;
@property (strong, readonly) NSURL *webURL;

@property (strong, readonly) SITLGalleryAuthorModel *author;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary andAuthor:(SITLGalleryAuthorModel*)author;

-(void)setThumbnailFromImage:(UIImage*)image;

@end
