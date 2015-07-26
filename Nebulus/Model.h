//
//  Model.h
//  Nebulus
//
//  Created by Jike on 7/26/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *objectName;
@property (nonatomic, strong) NSNumber *created;
@property (nonatomic, strong) NSNumber *edited;

@end
