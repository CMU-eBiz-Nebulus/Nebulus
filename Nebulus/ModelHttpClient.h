//
//  ModelHttpClient.h
//  Nebulus
//
//  Created by Jike on 8/19/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ModelHttpClient : NSObject
+(NSDictionary*) getModel:(NSString*) model ModelId: (NSString*) modelId;

@end
