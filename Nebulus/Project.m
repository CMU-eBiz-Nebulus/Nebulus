//
//  Project.m
//  Nebulus
//
//  Created by Jike on 7/28/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

//@property(nonatomic, strong) NSString *currentVersion;
//@property(nonatomic, strong) User *creator;
//@property(nonatomic, strong) NSArray *editors;
//@property(nonatomic, strong) NSDictionary *raw;
//
//@property(nonatomic, strong) NSString *description;
//@property(nonatomic, strong) NSString *groupName;
//@property(nonatomic, strong) NSString *projectName;
//@property(nonatomic, strong) NSArray *tags;
#import "Project.h"

@implementation Project

#pragma mark - Property

-(NSString *)groupName{
    if(!_groupName) _groupName = @"";
    return _groupName;
}

-(NSString *)currentVersion{
    if(!_currentVersion) _currentVersion = @"55b526356df6bd8840fd739d";
    return _currentVersion;
}

-(NSArray *)editors{
    if(!_editors) _editors = @[];
    return _editors;
}

#pragma mark - JSON methods

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.raw = json.mutableCopy;
        self.currentVersion = [json objectForKey:@"currentVersion"];
        NSDictionary *users = [json objectForKey:@"users"];
        self.creator = [[User alloc] initWithDict:[users objectForKey:@"creator"]];
        NSArray *rawEditors = [users objectForKey:@"editors"];
        NSMutableArray *editors = [[NSMutableArray alloc] init];
        for (int i = 0; i < [rawEditors count]; i++) {
            User *editor = [[User alloc] initWithDict:rawEditors[i]];
            [editors addObject:editor];
        }
        self.editors = editors;
        
        NSDictionary *meta = [json objectForKey:@"meta"];
        self.projectDescription = [meta objectForKey:@"description"];
        self.groupName = [meta objectForKey:@"groupName"];
        self.projectName = [meta objectForKey:@"name"];
        self.tags = [meta objectForKey:@"tags"];

    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    if (!self.raw) {
        self.raw = [[NSMutableDictionary alloc] init];
    }
    [self.raw setObject:self.currentVersion forKey:@"currentVersion"];
    NSMutableDictionary *users = [[NSMutableDictionary alloc]init];
    NSMutableArray *editors = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.editors count]; i++) {
        [editors addObject:[editors[i] convertToDict]];
    }
    [users setValue: [self.creator convertToDict] forKey:@"creator"];
    [users setValue: editors forKey:@"editors"];
    [self.raw setObject:users forKey:@"users"];

    if (![self.raw objectForKey:@"meta"]) {
        [self.raw setObject:[[NSMutableDictionary alloc] init] forKey:@"meta"];
    }
    NSMutableDictionary *meta = [self.raw objectForKey:@"meta"];

    [meta setObject:self.projectDescription forKey:@"description"];
    [meta setObject:self.projectName forKey:@"name"];
    [meta setObject:self.groupName forKey:@"groupName"];
    [meta setObject:self.tags forKey:@"tags"];

    return self.raw;
}

-(bool) isUser:(NSString*) userId {
    if ([self.creator.objectID isEqualToString: userId]) return YES;
    for (User *editor in self.editors) {
        if ([editor.objectID isEqualToString: userId]) return YES;
    }
    return NO;
}

@end
