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

@interface Invite : Model

@property (nonatomic, strong) User *from;
@property (nonatomic, strong) Project *project;
@property (nonatomic) BOOL request;
@property (nonatomic, strong) User *to;

-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;

@end
