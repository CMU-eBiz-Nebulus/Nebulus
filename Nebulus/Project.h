//
//  Project.h
//  Nebulus
//
//  Created by Jike on 7/28/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//project = {
//    "arrangements": <array of (ObjectIDs of arrangements)>,
//    "bounces": <array of (ObjectIDs of clips)>,
//    "clips": <array of (ObjectID of clips)>,
//    "currentVersion": <ObjectID of clips> | optional(null),
//    "docs": <array of (ObjectIDs of docs)>,
//    "meta": <meta>,
//    "tasks": <array of (ObjectIDs of tasks)>,
//    "users": {
//        "creator": <user>,
//        "editors": <array of users>
//    }
//}
//
//meta = {
//    "description": <string> | optional(""),
//    "key": <string> | optional(""),
//    "groupName": <string> | optional(""),
//    "meter": {
//        "beat": <int> | optional(4),
//        "sub": <int> | optional(4)
//    },
//    "name": <string> | optional("New Project"),
//    "pictureUpdateTime": <time> | optional(0),
//    "tags": <array of string>,
//    "tempo": <int> | optional(120)
//}

#import "Model.h"
#import "User.h"

@interface Project : Model

//@property(nonatomic, strong) NSArray *arrangements;
//@property(nonatomic, strong) NSArray *bounces;
//@property(nonatomic, strong) NSArray *clips;
@property(nonatomic, strong) NSString *currentVersion;
//@property(nonatomic, strong) NSArray *docs;
@property(nonatomic, strong) User *creator;
@property(nonatomic, strong) NSArray *editors;
@property(nonatomic, strong) NSMutableDictionary *raw;

@property(nonatomic, strong) NSString *projectDescription;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, strong) NSString *projectName;
@property(nonatomic, strong) NSArray *tags;




-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;



@end
