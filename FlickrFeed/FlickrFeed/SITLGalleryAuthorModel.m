//
//  SITLGalleryAuthorModel.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryAuthorModel.h"

@implementation SITLGalleryAuthorModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _name = [dictionary objectForKey:@"name"];
        _nsid = [dictionary objectForKey:@"flickr:nsid"];
        _icon = [NSURL URLWithString:[dictionary objectForKey:@"flickr:buddyicon"]];
        _uri = [NSURL URLWithString:[dictionary objectForKey:@"uri"]];
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@:: name: %@, nsid: %@>", [self class], _name, _nsid];
}

@end
