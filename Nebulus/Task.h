//
//  Task.h
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

#import "Model.h"
#import "User.h"
#import "Clip.h"
#import "Doc.h"

@interface Task : Model

@property(nonatomic, strong) NSArray * clips;
@property(nonatomic, strong) User *creator;
@property(nonatomic, strong) NSString *taskDescription;
@property(nonatomic, strong) NSArray *docs;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSArray *users;

-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
@end
