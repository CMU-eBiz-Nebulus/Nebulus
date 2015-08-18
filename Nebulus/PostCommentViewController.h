//
//  CommentViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/17/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface PostCommentViewController : UIViewController
@property (nonatomic, strong) Activity *activity;
@property (nonatomic, strong) User* currUser;

@property (nonatomic) BOOL commentMode;
@end
