//
//  ActivityHttpClient.m
//  Nebulus
//
//  Created by Jike on 8/17/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ActivityHttpClient.h"

@implementation ActivityHttpClient

+(Comment*) createComment:(Comment*) cmt {

    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/comments"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dict = [cmt convertToDict];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postdata];
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    Comment *returnpcmt = [[Comment alloc]initWithDict:json];
    return returnpcmt;

}

@end
