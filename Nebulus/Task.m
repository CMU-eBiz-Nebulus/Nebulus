//
//  Task.m
//  Nebulus
//
//  Created by Jike on 8/9/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

//task = {
//    "clips": <array of clips>,
//    "creator": <user>,
//    "description": <string>,
//    "docs": <array of docs>,
//    "status": <enum of ["blocked", "ready", "active", "complete"]>,
//    "title": <string>,
//    "users": <array of users>
//}

#import "Task.h"

@implementation Task

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.clips =  [Clip dictToArray:json withObjectName:nil];
        self.creator = [[User alloc] initWithDict: [json objectForKey:@"creator"]];
        self.taskDescription = [json objectForKey:@"description"];
        NSArray *docs = [Doc dictToArray:json withObjectName:nil];
        self.docs = docs;
        self.status = [json objectForKey:@"status"];
        self.title = [json objectForKey:@"title"];
        NSArray *users = [User dictToArray: json withObjectName:nil];
        self.users = users;
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    
    NSMutableArray *rawClips = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.clips count]; i++) {
        [rawClips addObject:[self.clips[i] convertToDict]];
    }
    [dict setObject:rawClips forKey:@"clips"];
    
    [dict setObject:[self.creator convertToDict] forKey:@"creator"];
    [dict setObject:self.taskDescription forKey:@"description"];
    
    NSMutableArray *rawDocs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.docs count]; i++) {
        [rawDocs addObject:[self.docs[i] convertToDict]];
    }
    [dict setObject:rawDocs forKey:@"docs"];
    
    [dict setObject:self.status forKey:@"status"];
    [dict setObject:self.title forKey:@"title"];
    
    NSMutableArray *rawUsers = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.users count]; i++) {
        [rawUsers addObject:[self.users[i] convertToDict]];
    }
    [dict setObject:rawUsers forKey:@"users"];
    return dict;
}

@end
