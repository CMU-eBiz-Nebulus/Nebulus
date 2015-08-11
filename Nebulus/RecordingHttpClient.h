//
//  RecordingHttpClient.h
//  Nebulus
//
//  Created by Jike on 8/11/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordingHttpClient : NSObject

+(BOOL) uploadRecording:(NSData*) data Id: (NSString*) recordingId;

@end
