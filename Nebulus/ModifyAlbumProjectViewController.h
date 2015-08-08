//
//  ModifyAlbumProjectViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/7/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateProjectAlbumViewController.h"

@interface ModifyAlbumProjectViewController : UIViewController
@property (nonatomic) CreateMode mode;
@property (nonatomic, strong) UIViewController *backVC;
@property (nonatomic, strong) id content;
@property (nonatomic, strong) UIImage *image;
@end
