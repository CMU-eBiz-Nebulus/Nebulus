//
//  MusicHttpClient.m
//  Nebulus
//
//  Created by Jike on 7/30/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "MusicHttpClient.h"

@implementation MusicHttpClient

+(NSArray*) getUserActivity:(NSString*) userId {

    
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/activity/user=%@", userId ];
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
    
    NSArray *rawActivities = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *activites = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawActivities count]; i++) {
        NSDictionary *act = [rawActivities objectAtIndex:i];
        NSString *type = [act objectForKey:@"type"];
        if ([type isEqualToString:@"albumShare"]) {
            AlbumShare *activity = [[AlbumShare alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"clipShare"]) {
            ClipShare *activity = [[ClipShare alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"projectShare"]) {
            ProjectShare *activity = [[ProjectShare alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"projectClassified"]) {
            ProjectClassified *activity = [[ProjectClassified alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"userClassified"]) {
            UserClassified *activity = [[UserClassified alloc] initWithDict:act];
            [activites addObject:activity];
        } else {
            NSLog(@"Wrong Type");
        }
        
    }

    return activites;
    

}


+(Activity*)creatActivity:(Activity*) activity {
    NSString *urlString = @"http://test.nebulus.io:8080/api/activity";
    NSURL *aUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *postDict;
    NSString *type = activity.type;
    if ([type isEqualToString:@"albumShare"]) {
        postDict = [(AlbumShare*) activity convertToDict];
    } else if ([type isEqualToString:@"clipShare"]) {
        postDict = [(ClipShare*) activity convertToDict];
    } else if ([type isEqualToString:@"projectShare"]) {
        postDict = [(ProjectShare*) activity convertToDict];
    } else if ([type isEqualToString:@"projectClassified"]) {
        postDict = [(ProjectClassified*) activity convertToDict];
    } else if ([type isEqualToString:@"userClassified"]) {
        postDict = [(UserClassified*) activity convertToDict];
    } else {
        NSLog(@"Wrong Type");
    }

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
        Activity *resActivity;
        NSString *type = [json objectForKey:@"type"];
        if ([type isEqualToString:@"albumShare"]) {
            resActivity = [[AlbumShare alloc] initWithDict:json];
        } else if ([type isEqualToString:@"clipShare"]) {
            resActivity = [[ClipShare alloc] initWithDict:json];
        } else if ([type isEqualToString:@"projectShare"]) {
            resActivity = [[ProjectShare alloc] initWithDict:json];
        } else if ([type isEqualToString:@"projectClassified"]) {
            resActivity = [[ProjectClassified alloc] initWithDict:json];
        } else if ([type isEqualToString:@"userClassified"]) {
            resActivity = [[UserClassified alloc] initWithDict:json];
        } else {
            NSLog(@"Wrong Type");
        }
        return resActivity;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}


+(NSArray*) getAllFollowingActivities:(NSString*) userId {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/activity/?followersOf=%@", userId ];
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
    
    NSArray *rawActivities = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *activites = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawActivities count]; i++) {
        NSDictionary *act = rawActivities[i];
        NSString *type = [act objectForKey:@"type"];
        if ([type isEqualToString:@"albumShare"]) {
            AlbumShare *activity = [[AlbumShare alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"clipShare"]) {
            ClipShare *activity = [[ClipShare alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"projectShare"]) {
            ProjectShare *activity = [[ProjectShare alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"projectClassified"]) {
            ProjectClassified *activity = [[ProjectClassified alloc] initWithDict:act];
            [activites addObject:activity];
        } else if ([type isEqualToString:@"userClassified"]) {
            UserClassified *activity = [[UserClassified alloc] initWithDict:act];
            [activites addObject:activity];
        } else {
            NSLog(@"Wrong Type");
        }
        
    }
    return activites;
}

+(Album*) createAlbum:(Album*) album{
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/albums"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dict = [album convertToDict];
    
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
    Album *returnAlbum = [[Album alloc]initWithDict:json];
    return returnAlbum;
}

+(NSArray*) getAlbumsByUser:(NSString*) userId {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/albums/?creator=%@", userId ];
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
        
    NSArray *rawAlbums = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *albums = [[NSMutableArray alloc]init];
        for (int i = 0; i < [rawAlbums count]; i++) {
            NSDictionary* json = rawAlbums[i];
            Album *album = [[Album alloc]initWithDict:json];
            [albums addObject:album];
        }
    return albums;
}

+(Project*) createProject:(Project*) project {
    
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/projects"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dict = [project convertToDict];
    
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
    Project *returnpProject = [[Project alloc]initWithDict:json];
    return returnpProject;

}

+(NSArray*) getProjectsByUser:(NSString*) userId{
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/projects/?user=%@", userId ];
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
    
    NSArray *rawProjects = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *projects = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawProjects count]; i++) {
        NSDictionary* json = rawProjects[i];
        Project *project = [[Project alloc]initWithDict:json];
        [projects addObject:project];
    }
    return projects;
}



@end
