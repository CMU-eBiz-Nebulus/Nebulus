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

@interface OtherProfileViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *tags;

@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;
@end

@implementation OtherProfileViewController
- (IBAction)buttonClicked:(UIBarButtonItem *)sender {
    
    if(!self.isInvitationMode){
        if([self.actionButton.title isEqualToString:@"Follow"]){
            [UserHttpClient follow:self.other follower:self.me];
        } else if ([self.actionButton.title isEqualToString:@"Unfollow"]){
            [UserHttpClient unfollow:self.other follower:self.me];
        }
        [self updateUI];
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)updateUI{
    [self.username setText: self.other.username];
    
    NSArray *follower_list = [UserHttpClient getFollowers:self.other];
    NSArray *following_list = [UserHttpClient getFollowing:self.other];
    
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
    

    
    if([self.me.objectID isEqualToString:self.other.objectID]){
        [self.actionButton setEnabled:NO];
        [self.actionButton setTitle:@""];
    }else {
        
        if(self.isInvitationMode){
            BOOL isEditor = NO;

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
        }
        [self.actionButton setEnabled:YES];
    }
    
}

@end
