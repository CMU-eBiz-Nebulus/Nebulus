//
//  HttpClient.m
//  Nebulus
//
//  Created by Jike on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "UserHttpClient.h"


@implementation UserHttpClient
+(User*) login: (NSString*) username password: (NSString*) password; {
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
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://test.nebulus.io:8080/api/users/%@", user.objectID];
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
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/followers?followee=%@", user.objectID ];
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
    
    NSArray *rawFollowers = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *followers = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawFollowers count]; i++) {
        NSDictionary* json = rawFollowers[i];
        NSDictionary *follower = [json objectForKey:@"follower"];
        User *f = [[User alloc] initWithDict:follower];
        [followers addObject:f];
    }
    return followers;
}

//Return a array of user objects of followee
+(NSArray*) getFollowing:(User*) user{
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/followers?follower=%@", user.objectID ];
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
    
    NSArray *rawFollowers = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *followers = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawFollowers count]; i++) {
        NSDictionary* json = rawFollowers[i];
        NSDictionary *follower = [json objectForKey:@"followee"];
        User *f = [[User alloc] initWithDict:follower];
        [followers addObject:f];
    }
    return followers;
}

+(BOOL) follow:(User*) followee follower:(User*) follower{
    NSString *urlString = @"http://test.nebulus.io:8080/api/followers";
    NSURL *aUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *followerDict = [follower convertToDict];
    NSDictionary *followeeDict = [followee convertToDict];
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
    [postDict setValue:followeeDict forKey:@"followee"];
    [postDict setValue:followerDict forKey:@"follower"];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:&error];
    [request setHTTPBody:postdata];
    
    
    
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                          error:&error];
    if(json) {
        return YES;
    } else {
        NSLog(@"%@", error);
        return NO;
    }
}

+(BOOL) unfollow:(User*) followee follower:(User*) follower{
    
    NSString *getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/followers?followee=%@&follower=%@", followee.objectID, follower.objectID];
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
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                 options:NSJSONReadingMutableLeaves
                                                                                   error:&error];
    //If there is no such relationship, return false
    if ([arr count] == 0) {
        NSLog(@"No such a relationship");
        return false;
    }
    NSDictionary *json = arr[0];
    Model *followModel = [[Model alloc]initWithDict:json];
    
    NSString *modelId = followModel.objectID;
    
    NSString * urlStr = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/followers/%@", modelId];
    NSURL *deleteUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *deleteRequest = [NSMutableURLRequest requestWithURL:deleteUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [deleteRequest setHTTPMethod:@"DELETE"];
    
    
    [NSURLConnection sendSynchronousRequest:deleteRequest
                                                 returningResponse:&response
                                                             error:&error];
    if(error) {
        return YES;
    } else {
        NSLog(@"%@", error);
        return NO;
    }
}

//Return all the clips that belongs to the given user id
+(NSArray*) searchUser:(NSString*) searchStr {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/users/?search=%@", searchStr];
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
    
    NSArray *raw = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *users = [[NSMutableArray alloc]init];
    for (int i = 0; i < [raw count]; i++) {
        NSDictionary* json = raw[i];
        User *u = [[User alloc] initWithDict:json];
        [users addObject:u];
    }
    return users;
}

//Return all the clips that belongs to the given user id
+(NSArray*) getClip:(NSString*) userId {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/clips/?user=%@",userId ];
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
    
    NSArray *rawClips = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *clips = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawClips count]; i++) {
        NSDictionary* json = rawClips[i];
        Clip *c = [[Clip alloc] initWithDict:json];
        [clips addObject:c];
    }
    return clips;
}

+(UIImage*) getUserImage:(NSString*) userId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/images/users/%@", userId ];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    UIImage *image = [[UIImage alloc] initWithData:responseData];
    return image;
}




@end
