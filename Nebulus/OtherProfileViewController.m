//
//  OtherProfileViewController.m
//  Nebulus
//
//  Created by Gang Wu on 7/29/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "User.h"
#import "HttpClient.h"

@interface OtherProfileViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *followButton;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *tags;

@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;
@end

@implementation OtherProfileViewController
- (IBAction)followButtonClicked:(UIBarButtonItem *)sender {
    
    [self updateUI];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)updateUI{
    [self.username setText: self.other.username];
    
    NSArray *follower_list = [HttpClient getFollowers:self.other];
    NSArray *following_list = [HttpClient getFollowing:self.other];
    
    NSString *descripton = [[NSString stringWithFormat:@"Tags: %@",
                             [self.other.tags componentsJoinedByString:@", "]]
                            stringByAppendingString:[NSString stringWithFormat:@"\n\n%@", self.other.about]];
    
    [self.tags setText:descripton];
    [self.followingBtn setTitle:[NSString stringWithFormat:@"Following: %lu", (unsigned long)[following_list count]]
                       forState:UIControlStateNormal];
    [self.followerBtn setTitle:[NSString stringWithFormat:@"Followers: %lu", (unsigned long)[follower_list count]]
                      forState:UIControlStateNormal];
    
    BOOL isFollowed = NO;
    for (User *user in follower_list){
        if([user.objectID isEqualToString:self.me.objectID]){
            isFollowed = YES;
            break;
        }
    }
    [self.followButton setTitle:isFollowed ? @"Unfollow" : @"Follow"];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
