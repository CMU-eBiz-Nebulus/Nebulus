//
//  Comment.m
//  Nebulus
//
//  Created by Jike on 8/9/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

//comment = {
//    "clip": <clip> | optional(null),
//    "model": <enum(see below)>,
//    "modelId": <ObjectID of "model">,
//    "pictureUpdateTime": <time> | optional(0),
//    "sender": <user>,
//    "text": <string>
//}

#import "Comment.h"

@implementation Comment

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.clip =  [[Clip alloc] initWithDict: [json objectForKey:@"clip"]];
        self.sender = [[User alloc] initWithDict: [json objectForKey:@"sender"]];
        self.model = [json objectForKey:@"model"];
        self.modelId = [json objectForKey:@"modelId"];
        self.pictureUpdateTime = [json objectForKey:@"pictureUpdateTime"];
        self.text = [json objectForKey:@"text"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:[self.clip convertToDict] forKey:@"clip"];
    [dict setObject:[self.sender convertToDict] forKey:@"sender"];
    [dict setObject:self.model forKey:@"model"];
    [dict setObject:self.modelId forKey:@"modelId"];
    [dict setObject:self.text forKey:@"text"];
    [dict setObject:self.pictureUpdateTime forKey:@"pictureUpdateTime"];
    return dict;
}

@end
