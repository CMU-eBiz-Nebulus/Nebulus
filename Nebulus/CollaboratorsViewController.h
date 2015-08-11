//
//  CollaboratorsViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/10/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "Album.h"
#import "AlbumProjectViewController.h"

@interface CollaboratorsViewController : UITableViewController
@property (nonatomic) ContentMode mode;
@property (nonatomic, strong) id content;
@end
