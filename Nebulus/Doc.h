//
//  Doc.h
//  Nebulus
//
//  Created by Jike on 8/6/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

//doc = {
//    "creator": <user>,
//    "link": <string> | optional(null),
//    "text": <string> | optional(""),
//    "title": <string>
//}

#import "Model.h"
#import "User.h"


@interface Doc : Model

@property (nonatomic, strong) User *creator;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;

-(id) initWithDict:(NSDictionary *)json;
-(NSDictionary*)convertToDict;
+(NSArray*) dictToArray:(NSDictionary*) dict withObjectName:(NSString*) name;

@end
