//
//  MusicHttpClient.h
//  Nebulus
//
//  Created by Jike on 7/30/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "Model.h"
#import "User.h"
#import "Activity.h"
#import "AlbumShare.h"
#import "ClipShare.h"
#import "ProjectShare.h"
#import "ProjectClassified.h"
#import "UserClassified.h"

@interface MusicHttpClient : Model

+(NSArray*) creatActivity:(Activity*) activity;

+(NSArray*) getAllFollowingActivities:(User*) user;

+(NSArray*) getUserActivity:(User*) user;

@end
