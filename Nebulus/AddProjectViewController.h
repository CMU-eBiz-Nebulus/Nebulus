//
//  AddProjectViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/23/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class Album;

@interface AddProjectViewController : UITableViewController
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Album *album;
@end
