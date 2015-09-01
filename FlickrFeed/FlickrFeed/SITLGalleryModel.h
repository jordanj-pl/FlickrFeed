//
//  SITLGalleryModel.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

#import "SITLGalleryItemModel.h"

@interface SITLGalleryModel : NSObject

@property (strong, readonly) NSString *collectionId;
@property (strong, readonly) NSString *title;
@property (strong, readonly) NSString *subtitle;
@property (strong, readonly) NSDate *updated;
@property (strong, readonly) NSURL *iconURL;

@property (strong, readonly) NSDictionary *metadata;
@property (strong, readonly) NSArray *items;

-(instancetype)initWithItems:(NSArray*)items andMetadata:(NSDictionary*)metadataDict;

@end
