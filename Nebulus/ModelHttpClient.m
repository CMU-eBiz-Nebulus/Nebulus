//
//  ModelHttpClient.m
//  Nebulus
//
//  Created by Jike on 8/19/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ModelHttpClient.h"

@implementation ModelHttpClient

+(NSDictionary*) getModel:(NSString*) model ModelId: (NSString*) modelId {
    
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/%@/%@", model, modelId];
    NSURL *aUrl = [NSURL URLWithString:getUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    
    
    NSError *error;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    NSDictionary *raw = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    return raw;
}

@end
