//
//  OtherProfileViewController.h
//  Nebulus
//
//  Created by Gang Wu on 7/29/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface OtherProfileViewController : UITableViewController
@property (nonatomic, strong) User *me;
@property (nonatomic, strong) User *other;
@end
