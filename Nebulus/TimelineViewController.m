//
//  TimelineViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "TimelineViewController.h"
#import "MusicHttpClient.h"
#import "UserHttpClient.h"


@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) NSArray *activity;
@end

@implementation TimelineViewController

#pragma mark - property
-(NSArray *)activity{
    return _activity ? _activity : @[];
}

#pragma mark - View Controller
-(void)viewWillAppear:(BOOL)animated{
    User *currUser = [UserHttpClient getCurrentUser];
    self.activity = [MusicHttpClient getAllFollowingActivities:currUser.objectID];
    
    NSLog(@"Fetched %ld activities", [self.activity count]);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.activity count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Activity *activity = self.activity[section];
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    Activity *activity = self.activity[indexPath.section];
    
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        [(UIImageView *)[cell viewWithTag:101] setImage: [UserHttpClient getUserImage:activity.creator.objectID]];
        [(UILabel *)[cell viewWithTag:102] setText:activity.creator.username];
        [(UILabel *)[cell viewWithTag:103] setText:[activity.tags componentsJoinedByString:@", "]];
        [(UILabel *)[cell viewWithTag:104] setText:activity.title];
    } else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        UITextView *textView = (UITextView *)[cell viewWithTag:101];
        [textView setText:activity.text];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"buttomCell"];
    }
    
    return cell;
}

#define HEIGHT_TOP_CELL     80.0
#define HEIGHT_BOTTOM_CELL  35.0
#define HEIGHT_TEXT_CELL    35.0
#define HEIGHT_PLAY_CELL    45.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return HEIGHT_TOP_CELL;
    } else if(indexPath.row == 1){
        return HEIGHT_TEXT_CELL;
    } else {
        return HEIGHT_BOTTOM_CELL;
    }
    return 0.0;
}

- (IBAction)like:(UIButton *)sender {
    UIButton *likeButton = sender;
    CGRect buttonFrame = [likeButton convertRect:likeButton.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
    NSLog(@"Clicked at %ld %ld", indexPath.section, indexPath.row);
}



@end
