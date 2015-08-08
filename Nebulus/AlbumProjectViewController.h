//
//  AlbumProjectViewController.h
//  Nebulus
//
//  Created by Gang Wu on 8/7/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Project.h"

typedef NS_ENUM(NSInteger, ContentMode) {
    PROJECT_DETAIL,
    ALBUM_DETAIL
};

@interface AlbumProjectViewController : UITableViewController
@property (nonatomic) ContentMode mode;
@property (nonatomic, strong) id content;
@end
