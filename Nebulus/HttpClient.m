//
//  HttpClient.m
//  Nebulus
//
//  Created by Jike on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "HttpClient.h"


@implementation HttpClient
+(User*) getUser: (NSString*) username password: (NSString*) password; {
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/auth/login/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:username forKey:@"username" ];
    [dict setValue:password forKey:@"password"];
    
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
    
    User *user = [[User alloc] init];
    [self getModel:json Model:user];
    user.objectID = [json objectForKey:@"_id"];
    user.username = [json objectForKey:@"username"];
    user.email = [json objectForKey:@"email"];
    user.about = [json objectForKey:@"about"];
    user.pictureUpdateTime = [json objectForKey:@"pictureUpdateTime"];
    user.tags = [json objectForKey:@"tags"];
    return user;
}

+(void)getModel: (NSDictionary*) json Model: (Model*) model {
    NSDictionary *meta = [json objectForKey: @"_meta"];
    model.created = [meta objectForKey:@"created"];
    model.edited = [meta objectForKey:@"edited"];
    model.objectName = [meta objectForKey:@"name"];
    
    
}


@end
