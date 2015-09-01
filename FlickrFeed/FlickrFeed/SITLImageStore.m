//
//  SITLImageStore.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLImageStore.h"

@interface SITLImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation SITLImageStore

+(instancetype)sharedStore {
    static SITLImageStore *sharedStore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

-(instancetype)init {
    [NSException raise:@"Singleton" format:@"Use + [SITLImageStore sharedStore]"];
    
    return nil;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)setImage:(UIImage *)image forKey :(NSString *)key {
    self.dictionary[key] = image;
    
    NSString *imagePath = [self imagePathForKey:key];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [data writeToFile:imagePath atomically:YES];
}

-(UIImage*)imageForKey:(NSString *)key {
    
    UIImage *result = self.dictionary[key];
    
    if(!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if(result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find: %@", imagePath);
        }
    }
    
    return result;
}

-(void)deleteImageForKey:(NSString *)key {
    if(!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

-(void)clearCache:(NSNotification*)note {
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dictionary count]);
    
    [self.dictionary removeAllObjects];
}

-(NSString*)imagePathForKey:(NSString*)key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
    
}

@end
