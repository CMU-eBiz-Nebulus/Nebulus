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
#import "CommentViewController.h"

@interface CommentClipPickerViewController()
@property (nonatomic, strong) NSArray *clips;
@end

@implementation CommentClipPickerViewController

-(NSArray *)clips{
    if(!_clips) _clips = @[];
    return _clips;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.title = @"Attach clip";
}

-(void)doneAction{
    CommentViewController *parentVC = (CommentViewController *)self.navigationController.parentViewController;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.clips = [RecordingHttpClient getClips:[UserHttpClient getCurrentUser].objectID];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;//[self.clips count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    Clip *clip = self.clips[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"clipCell"];

    [(UILabel *)[cell viewWithTag:101] setText:clip.name];
    [(UIButton *)[cell viewWithTag:102] setHidden:YES];

    return cell;
}


@end
