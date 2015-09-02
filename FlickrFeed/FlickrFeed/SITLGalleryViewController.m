//
//  SITLGalleryViewController.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 31.08.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryViewController.h"
#import "SITLGalleryCollectionViewCell.h"
#import "SITLGalleryDetailedViewController.h"
#import "SITLGalleryDetailedPageViewController.h"

@interface SITLGalleryViewController ()<UISearchBarDelegate>

@property (strong) SITLGalleryModel *currentGallery;

@property (strong) UIView *shakeToReloadBanner;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation SITLGalleryViewController

#pragma mark - view cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

    //Assign nib containing view for primary type of cell
    UINib *galleryItemViewNib = [UINib nibWithNibName:@"GalleryViewCell" bundle:nil];
    [self.collectionView registerNib:galleryItemViewNib forCellWithReuseIdentifier:@"GalleryItemCell"];

    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    self.collectionView.contentInset = UIEdgeInsetsMake(statusBarFrame.size.height, 0, 0, 0);
    
    if(!self.fetcher) {
        self.fetcher = [[SITLFlickrFetcher alloc] init];
    }
    
    //show hint informing user that gallery can be reloaded by shaking the device
    self.shakeToReloadBanner = [[UIView alloc] initWithFrame:CGRectMake(30.0f, 70.0f, self.view.bounds.size.width - 60, 40.0f)];
    self.shakeToReloadBanner.backgroundColor = [UIColor colorWithRed:0.5f green:0.4f blue:0.8f alpha:0.0f];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 5.0f, self.shakeToReloadBanner.frame.size.width-40.0f, 30.0f)];
    label.text = @"Shake to reload";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
    [self.shakeToReloadBanner addSubview:label];
    
    [self reload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    [self.view addSubview:self.shakeToReloadBanner];
    [UIView animateWithDuration:1 animations:^{
        self.shakeToReloadBanner.backgroundColor = [UIColor colorWithRed:0.5f green:0.4f blue:0.8f alpha:1.0f];
    }];
    
    [UIView animateWithDuration:2.0f delay:5.0f options:0 animations:^{
        self.shakeToReloadBanner.backgroundColor = [UIColor colorWithRed:0.5f green:0.4f blue:0.8f alpha:0.0f];
    } completion:^(BOOL finished) {
        if(finished) {
            [self.shakeToReloadBanner removeFromSuperview];
        }
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - motion detection

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {

    //TODO use settings to mark that the banner has been seen by user and do not show it again.
    
    if(motion == UIEventSubtypeMotionShake) {
        [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.shakeToReloadBanner.backgroundColor = [UIColor colorWithRed:120.0f green:120.0f blue:200.0f alpha:0.0f];
        } completion:^(BOOL finished) {
            if(finished) {
                [self.shakeToReloadBanner removeFromSuperview];
            }
        }];

        [self reload];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - network interaction

-(void)reload {
    //TODO replace with user blocking activity indicator in order to prevent action while items are being fetch. Clearly communicate to user that new items are being downloaded, many people do not see the small status bar spinning icon.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fetcher fetchGalleryForDefaultChannelWithCompletion:^(SITLGalleryModel *gallery, NSError *error) {
            NSLog(@"XML: %@,\nERROR: %@", gallery, error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentGallery = gallery;
                
                [self.collectionView reloadData];

                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }];
    });
}

-(void)fetchByTag:(NSString*)tag {
    //TODO replace with user blocking activity indicator in order to prevent action while items are being fetch. Clearly communicate to user that new items are being downloaded, many people do not see the small status bar spinning icon.

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.fetcher fetchGalleryByTag:tag withCompletion:^(SITLGalleryModel *gallery, NSError *error) {
            NSLog(@"XML: %@,\nERROR: %@", gallery, error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentGallery = gallery;
                
                [self.collectionView reloadData];

                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }];
    });
}


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

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchBarCell" forIndexPath:indexPath];
    
    return reuableView;
}

#pragma mark - UICollectionViewDelegate implementation

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SITLGalleryDetailedPageViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryDettailsPageViewController"];

    detailViewController.gallery = self.currentGallery;
    detailViewController.currentIndex = indexPath.row;
    
    detailViewController.dismissBlock = ^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    };
    
    detailViewController.searchGalleryByTagBlock = ^(NSString *tag) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self fetchByTag:tag];
        }];
    };


    
    SITLGalleryDetailedViewController *detailedViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryDetailedViewController"];
    
    SITLGalleryItemModel *selectedItem = self.currentGallery.items[indexPath.row];
    
    detailedViewController.item = selectedItem;
    detailedViewController.itemIndex = indexPath.row;
    
    detailedViewController.searchGalleryByTagBlock = ^(NSString *tag) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self fetchByTag:tag];
        }];
    };

    [detailViewController setViewControllers:@[detailedViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];


    [self presentViewController:detailViewController animated:YES completion:^{
        
    }];
}

#pragma mark - UISearchBarDelegate implementation

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchByTag:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [self reload];
}

@end
