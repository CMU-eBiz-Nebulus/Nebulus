//
//  CommentClipPickerViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/18/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "CommentClipPickerViewController.h"
#import "RecordingHttpClient.h"
#import "UserHttpClient.h"
#import "PostCommentViewController.h"
#import "PlayFileViewController.h"

@interface CommentClipPickerViewController()
@property (nonatomic, strong) NSArray *clips;
@property (nonatomic, strong) Clip *selectedClip;
@end

@implementation CommentClipPickerViewController

-(NSArray *)clips{
    if(!_clips) _clips = @[];
    return _clips;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
//                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                   target:self
//                                   action:@selector(doneAction)];
//    self.navigationItem.rightBarButtonItem = doneButton;
    self.title = @"Attach clip";
    
    self.selectedClip = nil;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//-(void)doneAction{
//
//    Clip *clip = [[Clip alloc] init];
//    clip.name = @"test clip";
//    clip.objectID = nil;
//    
//    self.backVC.clip = clip;
//    self.backVC.deleteClip.hidden = NO;
//    self.backVC.clipName.hidden = NO;
//    self.backVC.clipName.text = self.backVC.clip.name;
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.clips = [RecordingHttpClient getClips:[UserHttpClient getCurrentUser].objectID];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.clips count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    Clip *clip = self.clips[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"clipCell"];

    [(UILabel *)[cell viewWithTag:101] setText:clip.name];
    [(UIButton *)[cell viewWithTag:102] setHidden:NO];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.clips.count){
        self.backVC.clip = [self.clips objectAtIndex:indexPath.row];;
        self.backVC.deleteClip.hidden = NO;
        self.backVC.clipName.hidden = NO;
        self.backVC.clipName.text = self.backVC.clip.name;
        
        [self.navigationController popToViewController:self.backVC animated:YES];
    }
}

#pragma mark - play clip
- (IBAction)playClip:(UIButton *)sender {
    UIButton *button = sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
    if(indexPath.row < self.clips.count){
        Clip *clip = [self.clips objectAtIndex:indexPath.row];
        
        NSData *recording = [RecordingHttpClient getRecording:clip.recordingId];
        PlayFileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"playViewController"];
        [recording writeToURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:clip.name]]  atomically:YES];
        vc.fileName = clip.name;
        vc.recordingId = clip.recordingId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)applicationDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}



@end
