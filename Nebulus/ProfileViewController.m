//
//  ProfileViewController.m
//  Nebulus
//
//  Created by Gang Wu on 7/21/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileDetailViewController.h"
#import "HttpClient.h"
#import "FollowViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UIButton *postsButton;
@property (weak, nonatomic) IBOutlet UIButton *followedButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@end

@implementation ProfileViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.headPhoto setImage:[UIImage imageNamed:@"pic2"]];
    [self.headPhoto sizeToFit];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.userNameLabel setText:[defaults objectForKey:@"username"]];
}

-(void)viewWillAppear:(BOOL)animated{
    User *user = [HttpClient getCurrentUser];
    NSArray *follower_list = [HttpClient getFollowers:user];
    NSArray *following_list = [HttpClient getFollowing:user];
    
    [self.followedButton setTitle:[NSString stringWithFormat:@"Following: %lu", (unsigned long)[following_list count]]
                         forState:UIControlStateNormal];
    
    [self.followingButton setTitle:[NSString stringWithFormat:@"Followers: %lu", (unsigned long)[follower_list count]]
                         forState:UIControlStateNormal];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[UITableViewCell class]]){
        [((UITableViewCell *)sender) setSelected:NO];
    }
    if ([segue.identifier isEqualToString:@"Clips"]) {
        if ([segue.destinationViewController isKindOfClass:[ProfileDetailViewController class]]) {
            ProfileDetailViewController *pdvc = (ProfileDetailViewController *)segue.destinationViewController;
            pdvc.mode = CLIPS;
            pdvc.title = segue.identifier;
        }
    } else if ([segue.identifier isEqualToString:@"Projects"]) {
        if ([segue.destinationViewController isKindOfClass:[ProfileDetailViewController class]]) {
            ProfileDetailViewController *pdvc = (ProfileDetailViewController *)segue.destinationViewController;
            pdvc.mode = PROJECTS;
            pdvc.title = segue.identifier;
        }
    } else if ([segue.identifier isEqualToString:@"Albums"]) {
        if ([segue.destinationViewController isKindOfClass:[ProfileDetailViewController class]]) {
            ProfileDetailViewController *pdvc = (ProfileDetailViewController *)segue.destinationViewController;
            pdvc.mode = ALBUMS;
            pdvc.title = segue.identifier;
        }
    } else if ([segue.identifier isEqualToString:@"followedSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[FollowViewController class]]) {
            FollowViewController *tvc = (FollowViewController *)segue.destinationViewController;
            tvc.followingMode = YES;
        }
    } else if ([segue.identifier isEqualToString:@"followingSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[FollowViewController class]]) {
            FollowViewController *tvc = (FollowViewController *)segue.destinationViewController;
            tvc.followingMode = NO;
        }
    } else if ([segue.identifier isEqualToString:@"logout"]){
        [HttpClient logout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
