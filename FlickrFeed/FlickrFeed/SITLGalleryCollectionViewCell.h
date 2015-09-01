//
//  SITLGalleryCollectionViewCell.h
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SITLGalleryCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *author;

@end
