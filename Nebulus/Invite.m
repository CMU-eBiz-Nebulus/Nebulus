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
        self.projectName = [json objectForKey:@"projectName"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:[self.from convertToDict] forKey:@"from"];
    NSNumber *request = [[NSNumber alloc]initWithBool: self.request];
    [dict setObject: request forKey:@"request"];
    [dict setObject:[self.to convertToDict] forKey:@"to"];
    [dict setObject: self.modelId forKey:@"modelId"];
    if ([self.model isEqualToString:@"project"]) self.model = @"projects";
    if ([self.model isEqualToString:@"album"]) self.model = @"albums";
                                                               
    [dict setObject: self.model forKey:@"model"];
    if (!self.projectName) self.projectName = self.model;
    [dict setObject:self.projectName forKey:@"projectName"];
    
    return dict;
}

@end
