//
//  SITLGalleryModel.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryModel.h"

@implementation SITLGalleryModel

-(instancetype)initWithItems:(NSArray *)items andMetadata:(NSDictionary *)metadataDict {
    self = [super init];
    if(self) {
        _items = items;
        _metadata = metadataDict;
        
        _collectionId = [metadataDict objectForKey:@"id"];
        _title = [metadataDict objectForKey:@"title"];
        _subtitle = [metadataDict objectForKey:@"subtitle"];
        _iconURL = [NSURL URLWithString:[metadataDict objectForKey:@"icon"]];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        
        _updated = [df dateFromString:[metadataDict objectForKey:@"updated"]];
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@: number of items: %lu>", [self class], (unsigned long)[self.items count]];
}

@end
