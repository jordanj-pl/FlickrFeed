//
//  SITLGalleryDetailedViewController.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryDetailedViewController.h"

#import "SITLImageStore.h"
#import "SITLGalleryViewController.h"

@interface SITLGalleryDetailedViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIButton *openURLButton;

@property (nonatomic, weak) IBOutlet UIButton *expandTagsButton;
@property (nonatomic, assign) BOOL tagsExpanded;

@property (nonatomic, weak) IBOutlet UIView *tagsArea;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tagsAreaHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tagsAreaTopPadding;

@end

@implementation SITLGalleryDetailedViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SITLImageStore *imgStore = [SITLImageStore sharedStore];
    
    if([imgStore imageForKey:self.item.flickrId]) {
        self.imageView.image = [imgStore imageForKey:self.item.flickrId];
    } else {

        if([self.parentViewController.presentingViewController isKindOfClass:[SITLGalleryViewController class]]) {
            SITLGalleryViewController *gvc = (SITLGalleryViewController*)self.parentViewController.presentingViewController;
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [gvc.fetcher fetchImageForItem:self.item withCompletion:^(UIImage *image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageView.image = [imgStore imageForKey:self.item.flickrId];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    });
                }];
            });
        }
        
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    
    self.titleLabel.text = self.item.title;
    self.authorLabel.text = self.item.author.name;
    self.dateLabel.text = [df stringFromDate:self.item.datePublished];
    
    [self.openURLButton setTitle:[self.item.webURL absoluteString] forState:UIControlStateNormal];
    self.openURLButton.hidden = ![[UIApplication sharedApplication] canOpenURL:self.item.webURL];

    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];

    int categoryIndex = 0;
    for (NSString *categoryName in self.item.categories) {
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tagBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [tagBtn setTitle:[NSString stringWithFormat:@"#%@", categoryName] forState:UIControlStateNormal];
        [tagBtn setFrame:CGRectMake(5.0f, categoryIndex*25.0f + statusBarFrame.size.height, 200.0f, 21.0f)];//TODO add constraints to dynamically adjust button width
        tagBtn.tag = 990000 + categoryIndex;
        [tagBtn addTarget:self action:@selector(tagSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tagsArea addSubview:tagBtn];
        categoryIndex++;
    }
    
    if([self.item.categories count] > 0) {
        self.expandTagsButton.hidden = NO;

        self.tagsAreaHeight.constant = [self.item.categories count] * 25.0f + statusBarFrame.size.height;
    } else {
        self.tagsAreaHeight.constant = 0.0f;
    }
    
    self.tagsAreaTopPadding.constant = [self.item.categories count] * 25.0f * -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tagSelected:(id)sender {
    
    UIButton *btn = sender;

    self.tagsAreaTopPadding.constant = [self.item.categories count] * 25.0f * -1;
    [self.tagsArea setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tagsArea layoutIfNeeded];
        [self.expandTagsButton layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished) {
            self.tagsExpanded = NO;
            self.searchGalleryByTagBlock(self.item.categories[(btn.tag - 990000)]);
        }
    }];
}

-(IBAction)openURL:(id)sender {
    [[UIApplication sharedApplication] openURL:self.item.webURL];
}

-(IBAction)expandTags:(id)sender {

    if(self.tagsExpanded) {
        self.tagsAreaTopPadding.constant = [self.item.categories count] * 25.0f * -1;
        [self.tagsArea setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:1.5f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:0 animations:^{
            [self.tagsArea layoutIfNeeded];
            [self.expandTagsButton layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(finished) {
                self.tagsExpanded = NO;
            }
        }];
    } else {
        self.tagsAreaTopPadding.constant = 0.0f;
        [self.tagsArea setNeedsUpdateConstraints];

        [UIView animateWithDuration:1.5f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:0 animations:^{
            [self.tagsArea layoutIfNeeded];
            [self.expandTagsButton layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(finished) {
                self.tagsExpanded = YES;
            }
        }];
    }
    
}

@end
