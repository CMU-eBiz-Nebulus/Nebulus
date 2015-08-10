//
//  Like.h
//  Nebulus
//
//  Created by Jike on 8/9/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//


//like = {
//    "model": <enum(see below)>,
//    "modelId": <ObjectID of "model">,
//    "user": <user>
//}

#import "Model.h"
#import "User.h"

@interface Like : Model
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *modelId;

-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
+(NSArray*) dictToArray:(NSDictionary*) dict withObjectName:(NSString*) name;

@end
