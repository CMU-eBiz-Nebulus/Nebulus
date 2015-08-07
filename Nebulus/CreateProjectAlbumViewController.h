//
//  CreateAlbum.h
//  Nebulus
//
//  Created by ballade on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CreateMode) {
    PROJECT,
    ALBUM
};

@interface CreateProjectAlbumViewController : UIViewController 
@property (nonatomic) CreateMode mode;
@property (nonatomic, strong) UIViewController *backVC;
@end
