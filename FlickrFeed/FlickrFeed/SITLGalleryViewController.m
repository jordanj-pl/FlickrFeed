//
//  SITLGalleryViewController.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryViewController.h"
#import "SITLGalleryCollectionViewCell.h"

#import "SITLFlickrFetcher.h"

@interface SITLGalleryViewController ()

@property (strong) SITLFlickrFetcher *fetcher;

@property (strong) SITLGalleryModel *currentGallery;

@end

@implementation SITLGalleryViewController

#pragma mark - view cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

    //Assign nib containing view for primary type of cell
    UINib *galleryItemViewNib = [UINib nibWithNibName:@"GalleryViewCell" bundle:nil];
    [self.collectionView registerNib:galleryItemViewNib forCellWithReuseIdentifier:@"GalleryItemCell"];
    
    if(!self.fetcher) {
        self.fetcher = [[SITLFlickrFetcher alloc] init];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fetcher fetchGalleryForDefaultChannelWithCompletion:^(SITLGalleryModel *gallery, NSError *error) {
            NSLog(@"XML: %@,\nERROR: %@", gallery, error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentGallery = gallery;
                
                [self.collectionView reloadData];
            });
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UICollectionViewDataSource implementation


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.currentGallery.items count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SITLGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryItemCell" forIndexPath:indexPath];

    
    SITLGalleryItemModel *item = [self.currentGallery.items objectAtIndex:indexPath.row];
    
    cell.title.text = item.title;
    cell.author.text = item.author.name;
    
    if(item.thumbnail) {
        cell.image.image = item.thumbnail;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.fetcher fetchImageForItem:item withCompletion:^(UIImage *thumbnail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.image.image = thumbnail;
                });
            }];
        });
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate implementation

@end
