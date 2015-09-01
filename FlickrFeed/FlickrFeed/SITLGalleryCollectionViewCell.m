//
//  SITLGalleryCollectionViewCell.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryCollectionViewCell.h"

@implementation SITLGalleryCollectionViewCell

-(void)prepareForReuse {
    self.author.text = @"";
    self.title.text = @"";
    self.image.image = nil;
}

@end
