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
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/albums/"];
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

+(Album*) updateAlbum:(Album*) album{
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/albums/%@", album.objectID];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
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
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/albums/?user=%@", userId ];
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


+(UIImage*) getAlbumImage:(NSString*) albumId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/images/albums/%@", albumId ];
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

+(BOOL) setAlbumImage:(UIImage*) image AlbumId: (NSString*) albumId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/images/albums/%@", albumId ];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---aS3eS9A8zSo1";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", @"picture.png"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSError *error = [[NSError alloc] init];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) return NO;
    return YES;
}



+(BOOL) deleteAlbum:(NSString*) albumId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/albums/%@", albumId];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:60.0];
    [request setHTTPMethod:@"DELETE"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) NSLog(@"%@", error.localizedDescription);
                           }];

    return YES;
}




@end
