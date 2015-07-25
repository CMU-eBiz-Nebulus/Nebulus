//
//  HttpClient.m
//  Nebulus
//
//  Created by Jike on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "HttpClient.h"


//@implementation HttpClient
//+(User*) getUser: (NSString*) username password: (NSString*) password; {
//    
//    User *user = [[User alloc] init];
//    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:60.0];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *postString = [[NSString alloc] initWithFormat:@"username=%@&password=%@", username, password];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
//                                                                 delegate:self];
//    
////    [NSURLConnection sendAsynchronousRequest:request
////                                       queue:[NSOperationQueue mainQueue]
////                           completionHandler:^(NSURLResponse *response,
////                                               NSData *data, NSError *connectionError)
////     {
////         if (data.length > 0 && connectionError == nil)
////         {
////             NSDictionary *data = [NSJSONSerialization JSONObjectWithData:data
////                                                                      options:0
////                                                                        error:NULL];
////             
////             user.username = [data getObjects:<#(__unsafe_unretained id *)#> andKeys:<#(__unsafe_unretained id *)#>
////         }
////     }];
////             
//    return user;
//}

@end
