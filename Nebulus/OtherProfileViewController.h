//
//  OtherProfileViewController.h
//  Nebulus
//
//  Created by Gang Wu on 7/29/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyViewController.h"

@class User;

@interface OtherProfileViewController : UITableViewController
@property (nonatomic, strong) User *me;
@property (nonatomic, strong) User *other;

@property (nonatomic, getter=isInvitationMode) BOOL invitation_mode;

@property (nonatomic) ModifyMode mode;
@property (nonatomic, strong) id content;

@end
