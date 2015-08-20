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
#import "PostCommentViewController.h"

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
-(void)viewDidLoad{
    [super viewDidLoad];
    
    if(self.selfMode)
        self.navigationItem.rightBarButtonItem = nil;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated{
    self.currUser = [UserHttpClient getCurrentUser];
    self.activity = self.selfMode ? [MusicHttpClient getUserActivity:self.currUser.objectID]
    : [MusicHttpClient getAllFollowingActivities:self.currUser.objectID];
    
    [self.tableView reloadData];
    
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
        
        UIImage *image = [UserHttpClient getUserImage:activity.creator.objectID];
        if(image) [(UIImageView *)[cell viewWithTag:101] setImage: image];
        [(UILabel *)[cell viewWithTag:102] setText:activity.creator.username];
        
        UILabel *userName = (UILabel *) [cell viewWithTag:102];
        [userName setTextColor:[UIColor colorWithRed:11.0/255.0 green:23.0/255.0 blue:70.0/255.0 alpha:1.0]];
        [userName setFont:[UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize]];
        
        [(UILabel *)[cell viewWithTag:103] setText:[activity.tags componentsJoinedByString:@", "]];
        [(UILabel *)[cell viewWithTag:104] setText:activity.title];
        
        if(![activity.type isEqualToString:@"clipShare"]){
            [(UIButton *)[cell viewWithTag:200] setHidden:YES];
        }else{
            [(UIButton *)[cell viewWithTag:200] setHidden:NO];
        }
    } else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        UITextView *textView = (UITextView *)[cell viewWithTag:101];
        [textView setText:activity.text];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"buttomCell"];
    }
    
    return cell;
}

#pragma mark - Height

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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3.0;
}

#pragma mark - Button action

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
        if ([segue.destinationViewController isKindOfClass:[PostCommentViewController class]]) {
            PostCommentViewController *vc = (PostCommentViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Activity *activity = [self.activity objectAtIndex:indexPath.section];
            vc.currUser = self.currUser;
            vc.activity = activity;
            vc.commentMode = YES;
        }
    }else if ([segue.identifier isEqualToString:@"textPost"]) {
        if ([segue.destinationViewController isKindOfClass:[PostCommentViewController class]]) {
            PostCommentViewController *vc = (PostCommentViewController *)segue.destinationViewController;

            vc.currUser = self.currUser;
            vc.activity = nil;
            vc.commentMode = NO;
        }
    }
}

- (IBAction)doRefresh:(UIRefreshControl *)sender {
    self.activity = self.selfMode ? [MusicHttpClient getUserActivity:self.currUser.objectID]
    : [MusicHttpClient getAllFollowingActivities:self.currUser.objectID];
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    NSLog(@"Fetched %ld activities", [self.activity count]);
}

#pragma mark - open clip player
- (IBAction)openClip:(UIButton *)sender {
    UIButton *button = sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
    
    NSLog(@"Should open clip %ld", indexPath.section);
}

@end
