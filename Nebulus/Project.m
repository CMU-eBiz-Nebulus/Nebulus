//
//  Project.m
//  Nebulus
//
//  Created by Jike on 7/28/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "Project.h"

@implementation Project

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.raw = json;
        self.arrangements = [json objectForKey:@"arrangements"];
        self.bounces= [json objectForKey:@"bounces"];
        //self.clips = [json objectForKey:@"clips"];
        //self.currentVersion = [json objectForKey:@"clips"];
        self.docs = [json objectForKey:@"docs"];
        NSDictionary *meta = [json objectForKey:@"meta"];
        
        NSDictionary *users = [json objectForKey:@"users"];
        self.creator = [users objectForKey:@"creator"];
        self.editors = [users objectForKey:@"editors"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:self.arrangements forKey:@"arrangements"];
    [dict setObject:self.bounces forKey:@"bounces"];
    //[dict setObject:self.clips forKey:@"clips"];
    
    //[dict setObject:self.currentVersion forKey:@"currentVersion"];
    [dict setObject:self.docs forKey:@"docs"];
   NSMutableDictionary *meta = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *users = [[NSMutableDictionary alloc]init];
    [users setValue:self.creator forKey:@"creator"];
    [users setValue:self.editors forKey:@"editors"];
    [dict setValue:users forKey:@"users"];
    return dict;
}

@end
