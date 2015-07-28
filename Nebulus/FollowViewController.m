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

@interface FollowViewController ()
@property (strong, nonatomic) NSArray *follow_list;
@end

@implementation FollowViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.followingMode ? @"Following" : @"Followers";
    User *user = [HttpClient getCurrentUser];
    self.follow_list = self.followingMode ? [HttpClient getFollowing:user] : [HttpClient getFollowers:user];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"person"];
    [cell.textLabel setText:[self.follow_list objectAtIndex:indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"Number of entries : %d", self.contents.count);
    return self.follow_list ? [self.follow_list count] : 0;
}

@end
