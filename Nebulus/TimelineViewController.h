//
//  TimelineViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface TimelineViewController : UITableViewController
@property (nonatomic) BOOL selfMode;

@property (strong, nonatomic) User *currUser;
@end
