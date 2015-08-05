//
//  ClipShare.h
//  Nebulus
//
//  Created by Jike on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "Activity.h"
#import "Clip.h"

@interface ClipShare : Activity

@property (strong, nonatomic) Clip *clip;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *title;

-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;

@end
