//
//  FollowViewController.m
//  Nebulus
//
//  Created by Gang Wu on 7/27/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "FollowViewController.h"
#import "User.h"
#import "HttpClient.h"
#import "OtherProfileViewController.h"

@interface FollowViewController ()
@property (strong, nonatomic) NSArray *follow_list;
@end

@implementation FollowViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.follow_list = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.followingMode ? @"Following" : @"Followers";
    User *user = [HttpClient getCurrentUser];
    self.follow_list = self.followingMode ? [HttpClient getFollowing:user] : [HttpClient getFollowers:user];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"person"];
    User *user = [self.follow_list objectAtIndex:indexPath.row];
    [cell.textLabel setText: user.username];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"Number of entries : %d", self.contents.count);
    return self.follow_list ? [self.follow_list count] : 0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"otherPerson"]) {
        if ([segue.destinationViewController isKindOfClass:[OtherProfileViewController class]]) {
            OtherProfileViewController *opvc = (OtherProfileViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            opvc.me = [HttpClient getCurrentUser];
            opvc.other = [self.follow_list objectAtIndex:[self.tableView indexPathForCell:cell].row];
            
            NSLog(@"Segue info: %@, %@", opvc.me.username, opvc.other.username);
        }
    }
}

@end
