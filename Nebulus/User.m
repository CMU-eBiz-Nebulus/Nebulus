//
//  User.m
//  Nebulus
//
//  Created by Jike on 7/26/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//user = {
//    "about": <string> | optional(""),
//    "email": <string>,
//    "name": <string> | optional(""),
//    "pictureUpdateTime": <time> | optional(0),
//    "tags": <array of strings>,
//    "username": <string>
//}

#import "User.h"

@implementation User

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.about = [json objectForKey:@"about"];
        self.email = [json objectForKey:@"email"];
        self.pictureUpdateTime = [json objectForKey:@"pictureUpdateTime"];
        self.name = [json objectForKey:@"name"];
        self.tags = [json objectForKey:@"tags"];
        self.username = [json objectForKey:@"username"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:self.about forKey:@"about"];
    [dict setObject:self.email forKey:@"email"];
    [dict setObject:self.pictureUpdateTime forKey:@"pictureUpdateTime"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:self.tags forKey:@"tags"];
    [dict setObject:self.username forKey:@"username"];
    return dict;
}

@end
