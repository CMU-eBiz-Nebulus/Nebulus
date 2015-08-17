//
//  Invite.h
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

#import "Model.h"
#import "User.h"
#import "Project.h"
#import "Album.h"

@interface Invite : Model

@property (nonatomic, strong) User *from;
@property (nonatomic, strong) User *to;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *modelId;
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) Album *album;
@property (nonatomic) BOOL request;


-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;

@end
