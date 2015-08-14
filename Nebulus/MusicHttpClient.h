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
#import "UserHttpClient.h"

@interface MusicHttpClient : Model

+(NSArray*) creatActivity:(Activity*) activity;

//Get the activities of all following user of the given user
+(NSArray*) getAllFollowingActivities:(NSString*) userId;


//Get the activities of the given user
+(NSArray*) getUserActivity:(NSString*) userId;


+(Album*) createAlbum:(Album*) album;


+(Album*) updateAlbum:(Album*) album;

//Get the albums of the given user
+(NSArray*) getAlbumsByUser:(NSString*) userId;


+(UIImage*) getAlbumImage:(NSString*) albumId;


+(BOOL) setAlbumImage:(UIImage*) image AlbumId: (NSString*) albumId;


+(BOOL) deleteAlbum:(NSString*) albumId;


+(NSArray*) searchAlbum:(NSString*) searchStr;

//Add the user to the editor of given album
+(BOOL) addEditor:(NSString*) userId album:(NSString*) albumId;

@end
