//
//  SITLGalleryDetailedViewController.m
//  FlickrFeed
//
//  Created by Jordan Jasinski on 01.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "SITLGalleryDetailedViewController.h"

#import "SITLImageStore.h"

@interface SITLGalleryDetailedViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIButton *openURLButton;

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
    
    self.imageView.image = [imgStore imageForKey:self.item.flickrId];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    
    self.titleLabel.text = self.item.title;
    self.authorLabel.text = self.item.author.name;
    self.dateLabel.text = [df stringFromDate:self.item.datePublished];
    
    [self.openURLButton setTitle:[self.item.webURL absoluteString] forState:UIControlStateNormal];
    self.openURLButton.hidden = ![[UIApplication sharedApplication] canOpenURL:self.item.webURL];
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

-(IBAction)openURL:(id)sender {
    [[UIApplication sharedApplication] openURL:self.item.webURL];
}

@end
