//
//  Arrangement.h
//  Nebulus
//
//  Created by Jike on 8/9/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//
//arrangements = {
//    "creator": <user>,
//    "name": <string>,
//    "tags": <array of strings>,
//    "views": <array of views>
//}
//
//view = {
//    "_id": <ObjectID>,
//    "clipId": <ObjectID of clip>,
//    "duration": <float>,
//    "gain": <float> | optional(1.0),
//    "pan": <int> | optional(0),
//    "name": <string>,
//    "onset": <float>,
//    "start": <float>,
//    "start": <float>,
//    "yPos": <float>
//}
//

#import "Model.h"
#import "Clip.h"
#import "User.h"

@interface Arrangement : Model

@end
