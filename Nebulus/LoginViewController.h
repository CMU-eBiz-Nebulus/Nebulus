//
//  LoginViewController.h
//  Nebulus
//
//  Created by Jike on 7/20/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property NSString *username;
@property NSString *email;
@property NSArray *userTags;

//"about": <string> | optional(""),
//"email": <string>,
//"name": <string> | optional(""),
//"pictureUpdateTime": <time> | optional(0),
//"tags": <array of strings>,
//"username": <string>

@end
