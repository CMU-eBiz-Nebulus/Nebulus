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
#import "ActivityHttpClient.h"

@interface AlbumProjectViewController ()
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Project *project;

@property (weak, nonatomic) IBOutlet UILabel *songsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UILabel *tags;

@property (weak, nonatomic) IBOutlet UITableViewCell *editCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *deleteCell;

@property (nonatomic, strong) User* currUser;
@property (strong, nonatomic) UIViewController *fullscreenVC;

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
    self.currUser = user;
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
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)shareAction{

//    Activity *post = [[Activity alloc] init];
//    
//    post.creator = self.currUser;
//    if (self.mode == PROJECT_DETAIL){
//        Project *project = (Project *)self.content;
//        post.tags = project.tags;
//        post.title = @"Shared a project";
//        post.type = @"projectShare";
//        post.text = [NSString stringWithFormat:@"%@ shared %@", self.currUser.username, project.projectName];
//    }else if(self.mode == ALBUM_DETAIL){
//        Album *album = (Album *)self.content;
//        post.tags = album.tags;
//        post.title = @"Shared a album";
//        post.type = @"albumShare";
//        post.text = [NSString stringWithFormat:@"%@ shared %@", self.currUser.username, album.name];
//    }
//    
//    post = [ActivityHttpClient createActivity:post];
    
}

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
            vc.viewMode = self.viewMode;
        }
    }
}

#pragma mark - full screen photo
- (IBAction)fullscreenImage:(UIButton *)sender {
    if(self.imageView.image){
        self.fullscreenVC = [[UIViewController alloc] init];
        
        self.fullscreenVC.view.backgroundColor = [UIColor blackColor];
        self.fullscreenVC.view.userInteractionEnabled = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.fullscreenVC.view.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        [imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [imageView.layer setBorderWidth: 0.5];
        [imageView.layer setCornerRadius:5];
        
        imageView.image = self.imageView.image;
        
        [self.fullscreenVC.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(closeVC)];
        [self.fullscreenVC.view addGestureRecognizer:tap];
        [self presentViewController:self.fullscreenVC animated:YES completion:nil];
    }
}

-(void)closeVC{
    [self.fullscreenVC dismissViewControllerAnimated:YES completion:^(){}];
}


#pragma mark - table cell height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}
@end
