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

+(NSArray*) getCommentofActivity:(NSString*) activityId {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/comments/?modelId=%@", activityId ];
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
    
    NSArray *rawComments = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawComments count]; i++) {
        NSDictionary* json = rawComments[i];
        Comment *cmt = [[Comment alloc]initWithDict:json];
        [comments addObject:cmt];
    }
    return rawComments;
}

@end
