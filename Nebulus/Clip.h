//
//  Clip.h
//  Nebulus
//
//  Created by Jike on 7/28/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//clip = {
//    "creator": <user>,
//    "duration": <float>,
//    "name": <string>,
//    "recordingId": <ObjectID of recording>,
//    "tags": <array of strings>
//}
#import "Model.h"
#import "User.h"

@interface Clip : Model
@property (nonatomic, strong) User *creator;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *recordingId;
@property (nonatomic, strong) NSArray *tags;
-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
+(NSArray*) dictToArray:(NSDictionary*) dict withObjectName:(NSString*) name;
@end
