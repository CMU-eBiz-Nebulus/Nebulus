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
        self.project = [[Project alloc]initWithDict:[json objectForKey:@"project"]];
        NSNumber *request = [json objectForKey:@"request"];
        self.request = request;
        self.to = [[User alloc] initWithDict:[json objectForKey:@"to"]];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:[self.from convertToDict] forKey:@"from"];
    [dict setObject:[self.project convertToDict] forKey:@"project"];
    NSNumber *request = [[NSNumber alloc]initWithBool: self.request];
    [dict setObject: request forKey:@"request"];
    [dict setObject:[self.to convertToDict] forKey:@"to"];
    return dict;
}

@end
