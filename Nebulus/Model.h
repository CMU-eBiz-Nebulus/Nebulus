//
//  Model.h
//  Nebulus
//
//  Created by Jike on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//model = {
//    "_id": <ObjectID>,
//    "_meta": {
//        "created": <time>,
//        "edited": <time>,
//        "name": <string>
//    }
//}
//
#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSDictionary *meta;

@end

