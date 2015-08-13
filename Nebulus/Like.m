//
//  Like.m
//  Nebulus
//
//  Created by Jike on 8/9/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "Like.h"

@implementation Like

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.user = [[User alloc] initWithDict:[json objectForKey:@"user"]];
        self.model = [json objectForKey:@"model"];
        self.modelId = [json objectForKey:@"modelId"];
    }
    return self;
    
}
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:[self.user convertToDict] forKey:@"user"];
    [dict setObject:self.model forKey:@"model"];
    [dict setObject:self.modelId forKey:@"modelId"];
    return dict;
}

+(NSArray*) dictToArray:(NSDictionary*) dict withObjectName:(NSString*) name {
    return nil;
}

@end
