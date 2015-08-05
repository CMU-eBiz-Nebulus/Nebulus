//
//  ProjectClassified.h
//  Nebulus
//
//  Created by Jike on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "Activity.h"
#import "Clip.h"
#import "Project.h"

@interface ProjectClassified : Activity
-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
@property (strong, nonatomic) Clip *clip;
@property (strong, nonatomic) Project *project;
@property (nonatomic) BOOL fullfilled;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *title;

@end
