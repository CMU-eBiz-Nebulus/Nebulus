//
//  SearchViewController.h
//  Nebulus
//
//  Created by Gang Wu on 7/29/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyViewController.h"

@interface SearchViewController : UIViewController

@property (nonatomic) BOOL searchForInvitation;

@property (nonatomic) ModifyMode mode;
@property (nonatomic, strong) id content;

@end
