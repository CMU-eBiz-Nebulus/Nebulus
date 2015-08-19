//
//  OtherProfileViewController.m
//  Nebulus
//
//  Created by Gang Wu on 7/29/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "User.h"
#import "UserHttpClient.h"
#import "Project.h"
#import "Album.h"
#import "ProjectHttpClient.h"
#import "MusicHttpClient.h"
#import "ProfileDetailViewController.h"

@interface OtherProfileViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *tags;

@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;

@property (strong, nonatomic) UIViewController *fullscreenVC;
@end

@implementation OtherProfileViewController
- (IBAction)buttonClicked:(UIBarButtonItem *)sender {
    
    if(!self.isInvitationMode){
        if([self.actionButton.title isEqualToString:@"Follow"]){
            [UserHttpClient follow:self.other follower:self.me];
        } else if ([self.actionButton.title isEqualToString:@"Unfollow"]){
            [UserHttpClient unfollow:self.other follower:self.me];
        }
        
    } else {
        //TODO: invite this guy
        if(self.mode == M_PROJECT){
            Project *project = (Project *)self.content;
            Invite *invite = [ProjectHttpClient invite:self.other from:self.me Model:@"project" ModelId:project.objectID];
            
            if(invite)
                NSLog(@"Invite: %@", invite.objectID);
        }else if (self.mode == M_ALBUM){
            Album *album = (Album *)self.content;
            Invite *invite = [ProjectHttpClient invite:self.other from:self.me Model:@"album" ModelId:album.objectID];
            
            if(invite)
                NSLog(@"Invite: %@", invite.objectID);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self updateUI];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)updateUI{
    [self.username setText: self.other.username];
    
    NSArray *follower_list = [UserHttpClient getFollowers:self.other];
    NSArray *following_list = [UserHttpClient getFollowing:self.other];
    NSArray *post_list = [MusicHttpClient getUserActivity:self.other.objectID];
    
    NSString *descripton = [[NSString stringWithFormat:@"Tags: %@",
                             [self.other.tags componentsJoinedByString:@", "]]
                            stringByAppendingString:[NSString stringWithFormat:@"\n\n%@", self.other.about]];
    
    [self.tags setText:descripton];
    [self.followingBtn setTitle:[NSString stringWithFormat:@"Following: %lu", (unsigned long)[following_list count]]
                       forState:UIControlStateNormal];
    [self.followerBtn setTitle:[NSString stringWithFormat:@"Followers: %lu", (unsigned long)[follower_list count]]
                      forState:UIControlStateNormal];
    
    [self.headPhoto setImage: [UserHttpClient getUserImage:self.other.objectID]];
    //[self.headPhoto sizeToFit];
    
    [self.postBtn setTitle:[NSString stringWithFormat:@"Posts: %lu", (unsigned long)[post_list count]]
                      forState:UIControlStateNormal];
    

    
    if([self.me.objectID isEqualToString:self.other.objectID]){
        [self.actionButton setEnabled:NO];
        [self.actionButton setTitle:@""];
    }else {
        
        if(self.isInvitationMode){
            BOOL isEditor = YES;
            User *user = self.other;
            if (self.mode == M_PROJECT){
                Project *project = (Project *)self.content;
                isEditor = [project isUser:user.objectID];
            }else if(self.mode == M_ALBUM){
                Album *album = (Album *)self.content;
                isEditor = [album isUser:user.objectID];
            }

            if(isEditor){
                [self.actionButton setTitle:@""];
                [self.actionButton setEnabled:NO];
            } else{
                [self.actionButton setTitle:@"Invite"];
                [self.actionButton setEnabled:YES];
            }
        }else{
            BOOL isFollowed = NO;
            for (User *user in follower_list){
                if([user.objectID isEqualToString:self.me.objectID]){
                    isFollowed = YES;
                    break;
                }
            }
            [self.actionButton setTitle:isFollowed ? @"Unfollow" : @"Follow"];
            [self.actionButton setEnabled:YES];
        }
    }
    
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showOtherAlbum"]) {
        if ([segue.destinationViewController isKindOfClass:[ProfileDetailViewController class]]) {
            ProfileDetailViewController *pdvc = (ProfileDetailViewController *)segue.destinationViewController;
            pdvc.mode = ALBUMS;
            pdvc.title = @"Albums";
            pdvc.user = self.other;
        }
    }else if ([segue.identifier isEqualToString:@"showOtherProject"]) {
        if ([segue.destinationViewController isKindOfClass:[ProfileDetailViewController class]]) {
            ProfileDetailViewController *pdvc = (ProfileDetailViewController *)segue.destinationViewController;
            pdvc.mode = PROJECTS;
            pdvc.title = @"Projects";
            pdvc.user = self.other;
        }
    }
}

- (IBAction)fullscreenImage:(UIButton *)sender {
    if(self.headPhoto.image){
        self.fullscreenVC = [[UIViewController alloc] init];
        
        self.fullscreenVC.view.backgroundColor = [UIColor blackColor];
        self.fullscreenVC.view.userInteractionEnabled = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.fullscreenVC.view.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        [imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [imageView.layer setBorderWidth: 0.5];
        [imageView.layer setCornerRadius:5];
        
        imageView.image = self.headPhoto.image;
        
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

@end
