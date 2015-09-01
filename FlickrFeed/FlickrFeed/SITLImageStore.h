//
//  SITLImageStore.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

@interface SITLImageStore : NSObject

+(instancetype)sharedStore;

-(void)setImage:(UIImage*)image forKey:(NSString*)key;
-(UIImage*)imageForKey:(NSString*)key;
-(void)deleteImageForKey:(NSString*)key;

@end
