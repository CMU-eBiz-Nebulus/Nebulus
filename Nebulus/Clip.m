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

-(NSNumber *)duration{
    if(!_duration) _duration = [[NSNumber alloc]initWithInt:0];
    return _duration;
}

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.creator = [[User alloc]initWithDict:[json objectForKey:@"creator"]];
        self.duration = [json objectForKey:@"groupName"];
        self.name = [json objectForKey:@"name"];
        self.recordingId = [json objectForKey:@"recordingId"];
        self.tags = [json objectForKey:@"tags"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:[self.creator convertToDict] forKey:@"creator"];
    [dict setObject:self.duration forKey:@"duration"];
    [dict setObject:self.name forKey:@"name"];
    if (self.recordingId) {
        [dict setObject:self.recordingId forKey:@"recordingId"];
    } else [dict setObject:@"" forKey:@"recordingId"];
    if (self.tags) {
        [dict setObject:self.tags forKey:@"tags"];
    } else [dict setObject:@[] forKey:@"tags"];
    return dict;
}

+(NSArray*) dictToArray:(NSDictionary*) dict withObjectName:(NSString*) name {
    if (!name) name = @"clips";
    NSArray *raw = [dict objectForKey:name];
    NSMutableArray *clips = [[NSMutableArray alloc] init];
    for (int i = 0; i < [raw count]; i++) {
        [clips addObject:[[Clip alloc] initWithDict:raw[i]]];
    }

    return clips;
}

@end
