//
//  ActivityHttpClient.h
//  Nebulus
//
//  Created by Jike on 8/17/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "Comment.h"
#import "User.h"
#import "Invite.h"
#import "MusicHttpClient.h"
#import "ProjectHttpClient.h"

@interface ActivityHttpClient : NSObject

+(Comment*) createComment:(Comment*) cmt;

+(NSArray*) getCommentofActivity:(NSString*) activityId;

+(Invite*) getInvite:(NSString*) inviteId;
@end
