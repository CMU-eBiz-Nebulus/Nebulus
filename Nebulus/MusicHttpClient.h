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
#import <UIKit/UIKit.h>

@interface MusicHttpClient : Model

+(NSArray*) creatActivity:(Activity*) activity;

+(NSArray*) getAllFollowingActivities:(NSString*) userId;

+(NSArray*) getUserActivity:(NSString*) userId;

+(Album*) createAlbum:(Album*) album;

+(Album*) updateAlbum:(Album*) album;

+(NSArray*) getAlbumsByUser:(NSString*) userId;

+(UIImage*) getAlbumImage:(NSString*) albumId;

+(BOOL) setAlbumImage:(UIImage*) image AlbumId: (NSString*) albumId;

+(BOOL) deleteAlbum:(NSString*) albumId;


@end
