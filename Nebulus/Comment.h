//
//  Comment.h
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

#import "Model.h"
#import "Clip.h"
#import "User.h"

@interface Comment : Model

@property(nonatomic, strong) Clip * clip;
@property(nonatomic, strong) NSString *model;
@property(nonatomic, strong) NSString *modelId;
@property(nonatomic, strong) User *sender;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSNumber *pictureUpdateTime;

-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;

@end
