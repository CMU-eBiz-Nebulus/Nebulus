//
//  CommentClipPickerViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/18/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostCommentViewController;

@interface CommentClipPickerViewController : UITableViewController
@property (nonatomic, strong) PostCommentViewController *backVC;
@end
