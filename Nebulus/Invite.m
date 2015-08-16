//
//  Invite.m
//  Nebulus
//
//  Created by Jike on 8/14/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//invite = {
//    "from": <user>,
//    "project": <project>,
//    "request": <bool>,
//    "to": <user>
//}

#import "Invite.h"

@implementation Invite


-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.from = [[User alloc] initWithDict:[json objectForKey:@"from"]];
        NSNumber *request = [json objectForKey:@"request"];
        self.request = request;
        self.to = [[User alloc] initWithDict:[json objectForKey:@"to"]];
        self.model = [json objectForKey:@"model"];
        self.modelId = [json objectForKey:@"modelId"];
        if ([self.model isEqualToString:@"project"]) {
            self.project = [ProjectHttpClient getProject:self.modelId];
        } else if ([self.model isEqualToString:@"album"]) {
            self.album = [MusicHttpClient getAlbum:self.modelId];
        } else {
            NSLog(@"Wrong Type : %@", self.model);
        }
        
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:[self.from convertToDict] forKey:@"from"];
    NSNumber *request = [[NSNumber alloc]initWithBool: self.request];
    [dict setObject: request forKey:@"request"];
    [dict setObject:[self.to convertToDict] forKey:@"to"];
    [dict setObject:self.modelId forKey:@"modelId"];
    [dict setObject: self.model forKey:@"model"];
    return dict;
}

@end
