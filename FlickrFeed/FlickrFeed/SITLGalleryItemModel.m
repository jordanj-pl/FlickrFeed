//
//  SITLGalleryItemModel.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryItemModel.h"

@implementation SITLGalleryItemModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary andAuthor:(SITLGalleryAuthorModel *)author {
    self = [super init];
    if(self) {
        
        _author = author;
        
        _flickrId = [dictionary objectForKey:@"id"];
        _title = [dictionary objectForKey:@"title"];
        _content = [dictionary objectForKey:@"content"];
        
        _imageURL = [NSURL URLWithString:[dictionary objectForKey:@"temp:link:enclosure"]];
        _webURL = [NSURL URLWithString:[dictionary objectForKey:@"temp:link:alternate"]];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        
        _datePublished = [df dateFromString:[dictionary objectForKey:@"published"]];
        _dateUpdated = [df dateFromString:[dictionary objectForKey:@"updated"]];
        _dateTaken = [df dateFromString:[dictionary objectForKey:@"dc:date.Taken"]];
        
        _categories = [dictionary objectForKey:@"categories"];

    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@ id: %@, title: %@, URL: %@>", [self class], self.flickrId, self.title, [self.webURL absoluteString]];
}

-(void)setThumbnailFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    
    CGRect newRect = CGRectMake(0, 0, 150, 150);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:newRect];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    _thumbnail = smallImage;
    
    UIGraphicsEndImageContext();
}

@end
