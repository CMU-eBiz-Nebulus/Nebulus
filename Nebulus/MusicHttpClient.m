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
        [activites addObject:[[Activity alloc]initWithDict:act]];
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
    postDict = [activity convertToDict];
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
        Activity *resActivity = [[Activity alloc]initWithDict:json];
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
        [activites addObject:[[Activity alloc] initWithDict:act]];
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

//Return all the clips that belongs to the given user id
+(NSArray*) searchAlbum:(NSString*) searchStr {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/albums/?name=%@", searchStr];
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
    NSMutableArray *albums = [[NSMutableArray alloc]init];
    for (int i = 0; i < [raw count]; i++) {
        NSDictionary* json = raw[i];
        Album *u = [[Album alloc] initWithDict:json];
        [albums addObject:u];
    }
    return albums;
}

+(BOOL) addEditor:(NSString*) userId album:(NSString*) albumId {
    User *user = [UserHttpClient getUser:userId];
    Album * album = [self getAlbum:albumId];
    NSMutableArray *editors = album.editors.mutableCopy;
    [editors addObject:user];
    album.editors = editors;
    [self updateAlbum:album];
    return YES;
}

+(Album*) getAlbum:(NSString*) albumId {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/albums/%@", albumId];
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
    Album *album = [[Album alloc]initWithDict:raw];
    return album;
}



@end
