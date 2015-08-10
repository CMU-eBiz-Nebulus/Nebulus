//
//  Doc.m
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

#import "Doc.h"

@implementation Doc

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.creator = [[User alloc] initWithDict:[json objectForKey:@"creator"]];
        self.link = [json objectForKey:@"link"];
        self.text = [json objectForKey:@"text"];
        self.title = [json objectForKey:@"title"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:[self.creator convertToDict] forKey:@"creator"];
    [dict setObject:self.link forKey:@"link"];
    [dict setObject:self.text forKey:@"text"];
    [dict setObject:self.title forKey:@"title"];
    return dict;
}

+(NSArray*) dictToArray:(NSDictionary*) dict withObjectName:(NSString*) name {
    if (!name) name = @"docs";
    NSArray *rawDocs = [dict objectForKey:name];
    NSMutableArray *docs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [rawDocs count]; i++) {
        [docs addObject:[[Doc alloc] initWithDict:rawDocs[i]]];
    }
    return docs;
}

@end
