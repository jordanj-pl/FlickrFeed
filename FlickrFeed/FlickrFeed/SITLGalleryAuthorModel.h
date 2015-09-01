//
//  SITLGalleryAuthorModel.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SITLGalleryAuthorModel : NSObject

@property (strong, readonly) NSString *name;
@property (strong, readonly) NSString *nsid;
@property (strong, readonly) NSURL *icon;
@property (strong, readonly) NSURL *uri;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
