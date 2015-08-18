//
//  RecordingHttpClient.h
//  Nebulus
//
//  Created by Jike on 8/11/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Clip.h"

@interface RecordingHttpClient : NSObject


//Create and upload the clip to the server. the creator of the clip should be speciafied and the recording id should be null. A clip with recording id will be returned if uploaded successful.
+(Clip*) createClip:(Clip*) clip recording:(NSData*) data;


//Return all the clips that belongs to the given user id
+(NSArray*) getClips:(NSString*) userId;

//Get the recording data by the given recording id
+(NSData*) getRecording:(NSString*) recordingId;

+(BOOL) deleteClip:(Clip*) clip;



@end
