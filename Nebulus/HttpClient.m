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
    [dict setValue:username forKey:@"username"];
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
    if ([json count] == 0) return nil;
    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    NSString *cookie = [headers objectForKey:@"Set-Cookie"];
    User *user = [[User alloc] initWithDict:json];
    user.cookie = cookie;
    return user;
}

+(void) logout {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];;
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"cookie"];
    
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/auth/logout/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                                  queue:[NSOperationQueue mainQueue]
                                      completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                          if (error) NSLog(@"%@", error.localizedDescription);
                                      }];

}

+(BOOL) registerUser:(NSString*) username password: (NSString*) password email: (NSString*) email {
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/auth/register"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:username forKey:@"username"];
    [dict setValue:password forKey:@"password"];
    [dict setValue:email forKey:@"email"];
    
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
    if ([json count] > 0) {
        return YES;
    } else {
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }

}

//Update a user's profile by given user object, return the updated user object if successful
+(User*) updateUserInfo:(User*) user{
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://test.nebulus.io:8080/api/user/%@", user.objectID];
    NSURL *aUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dict = [user convertToDict];
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
    User *receivedUser = [[User alloc] initWithDict:json];
    return receivedUser;
}


//Returns the user object of the currently logged in user
+(User*) getCurrentUser {
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/auth/session"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    User *currentUser = [[User alloc] initWithDict:json];
    return currentUser;
}

//Return a array of user objects of followers
+(NSArray*) getFollowers:(User*) user{
    NSMutableArray *followers = [[NSMutableArray alloc]init];


    return followers;
}

//Return a array of user objects of following users
+(NSArray*) getFollowing:(User*) user{
    NSMutableArray *following = [[NSMutableArray alloc]init];
    
    
    return following;
}





@end
