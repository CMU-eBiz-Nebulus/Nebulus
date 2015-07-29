//
//  Clip.m
//  Nebulus
//
//  Created by Jike on 7/28/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//clip = {
//    "creator": <user>,
//    "duration": <float>,
//    "name": <string>,
//    "recordingId": <ObjectID of recording>,
//    "tags": <array of strings>
//}
#import "Clip.h"

@implementation Clip

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.creator = [json objectForKey:@"creator"];
        self.duration = [json objectForKey:@"groupName"];
        self.name = [json objectForKey:@"name"];
        self.recordingId = [json objectForKey:@"recordingId"];
        self.tags = [json objectForKey:@"tags"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:self.creator forKey:@"creator"];
    [dict setObject:self.duration forKey:@"duration"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:self.recordingId forKey:@"recordingId"];
    [dict setObject:self.tags forKey:@"tags"];
    return dict;
}

@end
