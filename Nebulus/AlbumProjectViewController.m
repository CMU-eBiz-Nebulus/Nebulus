//
//  AlbumProjectViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/7/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "AlbumProjectViewController.h"
#import "ModifyViewController.h"
#import "CreateProjectAlbumViewController.h"
#import "MusicHttpClient.h"

@interface AlbumProjectViewController ()
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Project *project;

@property (weak, nonatomic) IBOutlet UILabel *songsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UILabel *tags;
@end

@implementation AlbumProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

-(void)shareAction{}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.mode == PROJECT_DETAIL){
        self.album   = nil;
        self.project = (Project *)self.content;
        [self.songsLabel setText:@"Clips"];
        self.title = @"Project Name"; //self.project.name;
    } else {        // ALBUM_DETAIL
        self.album   = (Album *)self.content;
        self.project = nil;
        [self.songsLabel setText:@"Projects"];
        
        self.title = self.album.name;
        [self.tags setText:[NSString stringWithFormat:@"Tags: %@",
                                  [self.album.tags componentsJoinedByString:@","]]];
        [self.desc setText:self.album.albumDescription];
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // DELETE
    if(indexPath.section == 2 && indexPath.row == 1){
        MusicHttpClient 
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"editAlbumOrProject"]) {
        if ([segue.destinationViewController isKindOfClass:[ModifyViewController class]]) {
            ModifyViewController *vc = (ModifyViewController *)segue.destinationViewController;
            
            if(self.mode == PROJECT){
                vc.mode = M_PROJECT;
            } else if (self.mode == ALBUM){
                vc.mode = M_ALBUM;
            }
            vc.content = self.content;
            vc.backVC = self;
            vc.image = self.imageView.image;
        }
    }
}
@end
