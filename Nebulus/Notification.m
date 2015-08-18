//
//  Notification.m
//  Nebulus
//
//  Created by Jike on 8/13/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

//notification = {
//    "message": <string>,
//    "model": <enum(see below)>,
//    "modelId": <ObjectID of "model">,
//    "read": <bool>,
//    "recipient": <user>,
//    "type": <enum of ["main", "message"]> | optional("main")
//}

#import "Notification.h"

@implementation Notification

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.message =  [json objectForKey:@"message"];
        self.model = [json objectForKey:@"model"];
        self.modelId = [json objectForKey:@"modelId"];
        NSNumber *read = [json objectForKey:@"read"];
        //NSLog(@"%@", read);
        self.read = read.boolValue;
        User *recipient = [[User alloc]initWithDict:[json objectForKey:@"recipient"]];
        self.recipient = recipient;
        self.type = [json objectForKey:@"type"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    
    [dict setObject:self.message forKey:@"message"];
    [dict setObject:self.model forKey:@"model"];
    [dict setObject:self.modelId forKey:@"modelId"];
    NSNumber *read = [[NSNumber alloc]initWithBool:self.read];
    [dict setObject:read forKey:@"read"];
    [dict setObject:[self.recipient convertToDict] forKey:@"recipient"];
    [dict setObject:self.type forKey:@"type"];
    return dict;
}


@end
