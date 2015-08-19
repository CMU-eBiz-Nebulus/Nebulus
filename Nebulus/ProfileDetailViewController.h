//
//  ProfileDetailViewController.h
//  Nebulus
//
//  Created by Gang Wu on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProfileDetailMode) {
    ALBUMS,
    PROJECTS,
    CLIPS
};

@class User;

@interface ProfileDetailViewController : UITableViewController
@property (nonatomic, strong) User *user;
@property (nonatomic) ProfileDetailMode mode;
@end
