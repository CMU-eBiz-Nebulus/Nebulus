//
//  ProjectHttpClient.m
//  Nebulus
//
//  Created by Jike on 8/12/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ProjectHttpClient.h"

@implementation ProjectHttpClient

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

+(BOOL) updateProject:(Project*) project {
    NSString *urlStr = [[NSString alloc]initWithFormat:@"http://test.nebulus.io:8080/api/projects/%@", project.objectID];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
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

+(UIImage*) getProjectImage:(NSString*) projectId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/images/projects/%@", projectId ];
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

+(BOOL) setProjectImage:(UIImage*) image projectId: (NSString*) projectId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/images/projects/%@", projectId ];
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


+(BOOL) deleteProject:(NSString*) projectId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/projects/%@", projectId];
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

+(BOOL) addEditor:(NSString*) userId project:(NSString*) projectId {
    User *user = [UserHttpClient getUser:userId];
    Project * project = [self getProject:projectId];
    NSMutableArray *editors = project.editors.mutableCopy;
    [editors addObject:user];
    project.editors = editors;
    [self updateProject:project];
    return YES;
}

+(Project*) getProject:(NSString*) projectId {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/projects/%@", projectId];
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
    Project *project = [[Project alloc]initWithDict:raw];
    return project;
}

+(Invite*) invite: (User*) to from:(User*) from Model: (NSString*) model ModelId: (NSString*) modelId  {
    Invite *invite = [[Invite alloc] init];
    invite.model = model;
    invite.modelId = modelId;
    invite.from = from;
    invite.to = to;
    invite.request = NO;
    NSLog(@"%@ %@ %@", invite.project.projectName, invite.to.username, invite.from.username);
    NSString *urlStr = [[NSString alloc]initWithFormat:@"http://test.nebulus.io:8080/api/invites"];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dict = [invite convertToDict];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postdata];
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
//    if ([self.model isEqualToString:@"project"]) {
//        self.project = [ProjectHttpClient getProject:self.modelId];
//    } else if ([self.model isEqualToString:@"album"]) {
//        self.album = [MusicHttpClient getAlbum:self.modelId];
//    } else {
//        NSLog(@"Wrong Type : %@", self.model);
//    }
    
//    if (responseData) {
//        NSLog(@"invite");
//        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    
//        if (responseString) NSLog(responseData);
//    }
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
    int errorCode = httpResponse.statusCode;
    NSString *fileMIMEType = [httpResponse debugDescription];
    NSLog(fileMIMEType);
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    Invite *returnInvite = [[Invite alloc]initWithDict:json];
    
    return returnInvite;
}

+(BOOL) responseToInvite: (NSString*) inviteId accept: (BOOL) accept {
    NSString *reply;
    if (accept) reply = @"accept";
    else reply = @"reject";
    NSString * urlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/invites/%@/%@", inviteId, reply];
    NSURL *aUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSError *error;
    NSURLResponse *response = nil;
   [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    return YES;
}



@end
