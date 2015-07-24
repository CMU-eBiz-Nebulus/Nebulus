//
//  User.h
//  Nebulus
//
//  Created by Jike on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//
//user = {
//    "about": <string> | optional(""),
//    "email": <string>,
//    "name": <string> | optional(""),
//    "pictureUpdateTime": <time> | optional(0),
//    "tags": <array of strings>,
//    "username": <string>
//}



#import <UIKit/UIKit.h>
#import "Model.h"

@interface User : Model

@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *about;
@property(nonatomic) NSInteger *pictureUpdateTime;
@property(nonatomic, strong) NSArray *tags;

@end
