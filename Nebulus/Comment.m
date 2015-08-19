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

-(NSNumber *)pictureUpdateTime{
    if(!_pictureUpdateTime)_pictureUpdateTime=@0;
    return _pictureUpdateTime;
}

-(NSString *)text{
    if(!_text)_text=@"";
    return _text;
}

-(NSString *)model{
    if(!_model)_model =  @"activity";
    return _model;
}

-(NSString *)modelId{
    if(!_modelId) _modelId = [NSNull null];
    return _modelId;
}


-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        if ([json objectForKey:@"clip"] != [NSNull null]) {
            self.clip =  [[Clip alloc] initWithDict: [json objectForKey:@"clip"]];
        }
        //NSLog(@"123");
        self.creator = [[User alloc] initWithDict: [json objectForKey:@"sender"]];
        // NSLog(@"321");
        self.model = [json objectForKey:@"model"];
        self.modelId = [json objectForKey:@"modelId"];
        self.pictureUpdateTime = [json objectForKey:@"pictureUpdateTime"];
        self.text = [json objectForKey:@"text"];
    }
    //NSLog(@"%@\n%@\n%@\n%@", self.creator.username, self.model, self.modelId, self.text);
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    if (self.clip) {
        [dict setObject:[self.clip convertToDict] forKey:@"clip"];
    } else {
        [dict setObject:[NSNull null] forKey:@"clip"];
    }
    [dict setObject:[self.creator convertToDict] forKey:@"sender"];
    [dict setObject:self.model forKey:@"model"];
    [dict setObject:self.modelId forKey:@"modelId"];
    [dict setObject:self.text forKey:@"text"];
    [dict setObject:self.pictureUpdateTime forKey:@"pictureUpdateTime"];
    return dict;
}

@end
