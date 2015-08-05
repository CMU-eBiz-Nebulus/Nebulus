//
//  ProjectShare.m
//  Nebulus
//
//  Created by Jike on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ProjectShare.h"

@implementation ProjectShare

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        
        NSDictionary *data = [json objectForKey: @"data"];
        
        Project *project = [[Project alloc] initWithDict:[data objectForKey:@"project"]];
        self.project = project;
        
        NSArray *tags = [data objectForKey:@"tags"];
        self.tags = tags;
        
        NSString *text = [data objectForKey:@"text"];
        self.text = text;
        
        
        NSString *title = [data objectForKey:@"title"];
        self.title = title;
    }
    return self;
}

-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:self.title forKey:@"title"];
    
    [data setObject:self.text forKey:@"text"];
    
    [data setObject:self.tags forKey:@"tags"];
    
    NSDictionary *project = [self.project convertToDict];
    [data setObject:project forKey:@"project"];
    
    [dict setObject: data forKey:@"data"];
    
    return dict;
}

@end
