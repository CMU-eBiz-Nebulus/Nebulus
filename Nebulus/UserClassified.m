//
//  UserClassified.m
//  Nebulus
//
//  Created by Jike on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "UserClassified.h"

@implementation UserClassified

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        
        NSDictionary *data = [json objectForKey: @"data"];
        
        Clip *clip = [[Clip alloc] initWithDict:[data objectForKey:@"clip"]];
        self.clip = clip;
        
        NSArray *tags = [data objectForKey:@"tags"];
        self.tags = tags;
        
        NSString *text = [data objectForKey:@"text"];
        self.text = text;
        
        NSString *title = [data objectForKey:@"title"];
        self.title = title;
        
        NSNumber *fullfilled = [data objectForKey:@"fullfilled"];
        self.fullfilled = fullfilled;
        
    }
    return self;
}

-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:self.title forKey:@"title"];
    
    [data setObject:self.text forKey:@"text"];
    
    [data setObject:self.tags forKey:@"tags"];
    
    NSNumber *fullfilled = [NSNumber numberWithBool:self.fullfilled];
    [data setObject:fullfilled forKey:@"fullfilled"];
    
    NSDictionary *clip = [self.clip convertToDict];
    [data setObject:clip forKey:@"clip"];
    
    [dict setObject: data forKey:@"data"];
    
    return dict;
}

@end
