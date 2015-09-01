//
//  SITLFlickrFetcher.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLFlickrFetcher.h"

#import "SITLImageStore.h"

@interface SITLFlickrFetcher () <NSXMLParserDelegate>

@property (strong) NSMutableDictionary *metadataDict;

@property (strong) NSMutableDictionary *currentItemDictionary;
@property (strong) NSDictionary *currentNodeAttributesDictionary;
@property (strong) NSMutableString *currentText;
@property (strong) NSMutableDictionary *currentAuthorDictionary;
@property (strong) SITLGalleryAuthorModel *currentAuthor;
@property (strong) NSMutableArray *items;

@end

@implementation SITLFlickrFetcher

-(instancetype)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

-(void)fetchGalleryForDefaultChannelWithCompletion:(void (^)(SITLGalleryModel *, NSError *))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/feeds/photos_public.gne"];
    
    [self fetchGalleryForURL:url withCompletion:^(SITLGalleryModel *gallery, NSError *error) {
        if(completion) {
            completion(gallery, error);
        }
    }];
}

-(void)fetchGalleryForURL:(NSURL*)url withCompletion:(void (^)(SITLGalleryModel *, NSError *))completion {
    
    self.metadataDict = [NSMutableDictionary dictionary];
    self.items = [NSMutableArray array];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    if(completion) {
        if(success) {
            completion([[SITLGalleryModel alloc] initWithItems:[NSArray arrayWithArray:self.items] andMetadata:[NSDictionary dictionaryWithDictionary:self.metadataDict]], nil);
        } else {
            completion(nil, nil);
        }
    }
    
}

-(void)fetchImageForItem:(SITLGalleryItemModel *)item withCompletion:(void (^)(UIImage *))completion {

    NSURLRequest *request = [NSURLRequest requestWithURL:item.imageURL];
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
    
    if(data) {
        UIImage *image = [UIImage imageWithData:data];
        
        [item setThumbnailFromImage:image];
        
        SITLImageStore *imgStore = [SITLImageStore sharedStore];
        [imgStore setImage:image forKey:item.flickrId];
        
        if(completion) {
            completion(item.thumbnail);
        }
    }

}

#pragma mark - XMLParserDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    self.currentText = [[NSMutableString alloc] init];
    self.currentNodeAttributesDictionary = attributeDict;

    if([elementName isEqualToString:@"entry"]) {
        self.currentItemDictionary = [NSMutableDictionary dictionary];
    } else if(self.currentItemDictionary != nil) {
        if([elementName isEqualToString:@"author"]) {
            self.currentAuthorDictionary = [NSMutableDictionary dictionary];
        }
        NSLog(@"START: %@", elementName);
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog(@"END: %@", elementName);
    
    if([elementName isEqualToString:@"entry"]) {
        
        SITLGalleryItemModel *itemModel = [[SITLGalleryItemModel alloc] initWithDictionary:[NSDictionary dictionaryWithDictionary:self.currentItemDictionary] andAuthor:self.currentAuthor];
        
        self.currentItemDictionary = nil;
        self.currentAuthor = nil;
        
        NSLog(@"MODEL: %@\n%@", itemModel, itemModel.author);
        
        [self.items addObject:itemModel];
    } else if([elementName isEqualToString:@"author"]) {
        SITLGalleryAuthorModel *authorModel = [[SITLGalleryAuthorModel alloc] initWithDictionary:[NSDictionary dictionaryWithDictionary:self.currentAuthorDictionary]];
        
        self.currentAuthorDictionary = nil;
        
        NSLog(@"AUTHOR: %@", authorModel);
        self.currentAuthor = authorModel;
        
    } else if(self.currentItemDictionary) {
        
        if(self.currentAuthorDictionary) {
            if(self.currentText) {
                [self.currentAuthorDictionary setObject:self.currentText forKey:elementName];
            }
        } else {
            if([elementName isEqualToString:@"link"] && self.currentNodeAttributesDictionary) {
                if([[self.currentNodeAttributesDictionary objectForKey:@"rel"] isEqualToString:@"alternate"]) {
                    [self.currentItemDictionary setObject:[self.currentNodeAttributesDictionary objectForKey:@"href"] forKey:@"temp:link:alternate"];
                } else if([[self.currentNodeAttributesDictionary objectForKey:@"rel"] isEqualToString:@"enclosure"]) {
                    [self.currentItemDictionary setObject:[self.currentNodeAttributesDictionary objectForKey:@"href"] forKey:@"temp:link:enclosure"];
                }
            } else if(self.currentText) {
                [self.currentItemDictionary setObject:self.currentText forKey:elementName];
            }
        }

    } else {
        if(self.currentText) {
            [self.metadataDict setObject:self.currentText forKey:elementName];
        }
    }
    
    self.currentText = nil;
    self.currentNodeAttributesDictionary = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.currentText appendString:string];
}

@end
