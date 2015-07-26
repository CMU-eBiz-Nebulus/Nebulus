//
//  User.h
//  Nebulus
//
//  Created by Jike on 7/26/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface User : Model

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *about;
@property(nonatomic, strong) NSNumber *pictureUpdateTime;
@property(nonatomic, strong) NSArray *tags;


@end
