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
#import "ProjectHttpClient.h"
#import "CollaboratorsViewController.h"
#import "Project.h"
#import "Album.h"
#import "User.h"
#import "UserHttpClient.h"

@interface AlbumProjectViewController ()
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Project *project;

@property (weak, nonatomic) IBOutlet UILabel *songsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UILabel *tags;

@property (weak, nonatomic) IBOutlet UITableViewCell *editCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *deleteCell;

@end

@implementation AlbumProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.viewMode){
        self.editCell.hidden = YES;
        self.deleteCell.hidden = YES;
    }
    
    // Check whether current user has the right to share ALBUM / PROJECT
    BOOL displayShare = NO;
    User *user = [UserHttpClient getCurrentUser];
    if (self.mode == PROJECT_DETAIL){
        Project *project = (Project *)self.content;
        displayShare = [project isUser:user.objectID];
    }else if(self.mode == ALBUM_DETAIL){
        Album *album = (Album *)self.content;
        displayShare = [album isUser:user.objectID];
    }
    
    if(displayShare){
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                        target:self
                                        action:@selector(shareAction)];
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
}

-(void)shareAction{}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.mode == PROJECT_DETAIL){
        self.album   = nil;
        self.project = (Project *)self.content;
        [self.songsLabel setText:@"Clips"];
        
        self.title = self.project.projectName;
        [self.tags setText:[NSString stringWithFormat:@"Tags: %@",
                            [self.project.tags componentsJoinedByString:@","]]];
        [self.desc setText:self.project.projectDescription];
        
        [self.imageView setImage:[ProjectHttpClient getProjectImage:self.project.objectID]];
    } else if(self.mode == ALBUM_DETAIL) {        // ALBUM_DETAIL
        self.album   = (Album *)self.content;
        self.project = nil;
        [self.songsLabel setText:@"Projects"];
        
        self.title = self.album.name;
        [self.tags setText:[NSString stringWithFormat:@"Tags: %@", [self.album.tags componentsJoinedByString:@","]]];
        [self.desc setText:self.album.albumDescription];
        
        [self.imageView setImage:[MusicHttpClient getAlbumImage:self.album.objectID]];
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // DELETE
    if(indexPath.section == 2 && indexPath.row == 1){
        if (self.mode == PROJECT_DETAIL){
            [ProjectHttpClient deleteProject:self.project.objectID];
            NSLog(@"Project deletion");
        } else if(self.mode == ALBUM_DETAIL){
            [MusicHttpClient deleteAlbum:self.album.objectID];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
    } else if ([segue.identifier isEqualToString:@"collaborators"]){
        if ([segue.destinationViewController isKindOfClass:[CollaboratorsViewController class]]) {
            CollaboratorsViewController *vc = (CollaboratorsViewController *)segue.destinationViewController;
            
            if(self.mode == PROJECT){
                vc.mode = PROJECT_DETAIL;
            } else if (self.mode == ALBUM){
                vc.mode = ALBUM_DETAIL;
            }
            vc.content = self.content;
        }
    }
}
@end
