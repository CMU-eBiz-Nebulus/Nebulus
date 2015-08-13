//
//  Notification.h
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
#import "Model.h"
#import "User.h"

@interface Notification : Model
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSString *modelId;
@property (nonatomic) BOOL read;
@property (strong, nonatomic) User *recipient;
@property (strong, nonatomic) NSString *type;


-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
@end
