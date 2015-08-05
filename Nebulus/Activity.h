//
//  Activity.h
//  Nebulus
//
//  Created by Jike on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "Model.h"
#import "User.h"

@interface Activity : Model
-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) User *creator;

@end
