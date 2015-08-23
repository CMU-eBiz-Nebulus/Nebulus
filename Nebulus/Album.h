//
//  Album.h
//  Nebulus
//
//  Created by Jike on 7/28/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//



#import "Model.h"
#import "User.h"
#import "Project.h"

@interface Album : Model
-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
-(bool) isUser:(NSString*) userId;

@property(nonatomic, strong) NSString *albumDescription;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *pictureUpdateTime;
@property(nonatomic, strong) NSArray *projects;
@property(nonatomic, strong) User *creator;
@property(nonatomic, strong) NSArray *editors;
@property(nonatomic, strong) NSArray *tags;



@end
