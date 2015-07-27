//
//  Model.m
//  Nebulus
//
//  Created by Jike on 7/26/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "Model.h"

@implementation Model

/*
 Initialize the Model class with a given didctionary, typically used for convert the received json
 to a Model object
 */
-(id)initWithDict:(NSDictionary*) json {
    self = [super init];
    self.objectID = [json objectForKey:@"_id"];
    NSDictionary *meta = [json objectForKey:@"meta"];
    self.objectName = [meta objectForKey:@"name"];
    self.created = [meta objectForKey:@"created"];
    self.edited = [meta objectForKey:@"edited"];
    return self;
}
/*
 Convert this Model class to a dictionary object, used to prepared for RESTful API
 */
-(NSDictionary*)convertToDict {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *meta = [[NSMutableDictionary alloc] init];
    [meta setValue:self.created forKey:@"create"];
    [meta setValue:self.edited forKey:@"edited"];
    [meta setValue:self.objectName forKey:@"name"];
    [dict setValue:meta forKey:@"_meta"];
    [dict setValue:self.objectID forKey:@"_id"];
    return dict;
}

@end
