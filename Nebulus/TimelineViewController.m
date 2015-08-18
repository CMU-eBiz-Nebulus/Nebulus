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
#import "OtherProfileViewController.h"
#import "TimelineDetailViewController.h"
#import "CommentViewController.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) NSArray *activity;
@property (strong, nonatomic) User *currUser;
@end

@implementation TimelineViewController

#pragma mark - property
-(NSArray *)activity{
    return _activity ? _activity : @[];
}

#pragma mark - View Controller
-(void)viewWillAppear:(BOOL)animated{
    self.currUser = [UserHttpClient getCurrentUser];
    self.activity = !self.selfMode ? [MusicHttpClient getAllFollowingActivities:self.currUser.objectID] : @[];//[MusicHttpClient getUserActivity:self.currUser.objectID];
    
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

//- (IBAction)comment:(UIButton *)sender {
//    UIButton *commentButton = sender;
//    CGRect buttonFrame = [commentButton convertRect:commentButton.bounds toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
//    NSLog(@"Clicked at %ld %ld", indexPath.section, indexPath.row);
//    
//    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Comment"
//                                                     message:@"Enter comment here"
//                                                    delegate:self
//                                           cancelButtonTitle:@"Cancel"
//                                           otherButtonTitles: nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert addButtonWithTitle:@"Comment"];
//    [alert show];
//    
//}

- (IBAction)viewDetail:(UIButton *)sender {
    UIButton *button = sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
    
    TimelineDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"timelinedetailviewcontroller"];
    Activity *activity = [self.activity objectAtIndex:indexPath.section];
    vc.activity = activity;
    vc.currUser = self.currUser;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"viewUser"]) {
        if ([segue.destinationViewController isKindOfClass:[OtherProfileViewController class]]) {
            OtherProfileViewController *vc = (OtherProfileViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Activity *activity = [self.activity objectAtIndex:indexPath.section];
            vc.me = self.currUser;
            vc.other = activity.creator;
            vc.invitation_mode = NO;
        }
    }else if ([segue.identifier isEqualToString:@"viewTimelineDetail"]) {
        if ([segue.destinationViewController isKindOfClass:[TimelineDetailViewController class]]) {
            TimelineDetailViewController *vc = (TimelineDetailViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Activity *activity = [self.activity objectAtIndex:indexPath.section];
            vc.currUser = self.currUser;
            vc.activity = activity;
        }
    }else if ([segue.identifier isEqualToString:@"comment"]) {
        if ([segue.destinationViewController isKindOfClass:[CommentViewController class]]) {
            CommentViewController *vc = (CommentViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Activity *activity = [self.activity objectAtIndex:indexPath.section];
            vc.currUser = self.currUser;
            vc.activity = activity;
        }
    }
}


@end
