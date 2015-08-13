//
//  ProjectHttpClient.h
//  Nebulus
//
//  Created by Jike on 8/12/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Model.h"
#import "User.h"
#import "Project.h"


@interface ProjectHttpClient : NSObject

+(Project*) createProject:(Project*) project;

+(NSArray*) getProjectsByUser:(NSString*) userId;

+(UIImage*) getProjectImage:(NSString*) projectId;

+(BOOL) setProjectImage:(UIImage*) image projectId: (NSString*) projectId;

+(BOOL) deleteProject:(NSString*) projectId;

@end
