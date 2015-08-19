//
//  CommentViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/17/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@class Clip;

@interface PostCommentViewController : UIViewController
@property (nonatomic, strong) Activity *activity;
@property (nonatomic, strong) User *currUser;

@property (nonatomic) BOOL commentMode;         // post or comment

@property (nonatomic, strong) Clip *clip;       // Used to pass clip object
@property (weak, nonatomic) IBOutlet UILabel *clipName;
@property (weak, nonatomic) IBOutlet UIButton *deleteClip;
@end
