//
//  RecordingHttpClient.m
//  Nebulus
//
//  Created by Jike on 8/11/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "RecordingHttpClient.h"

@implementation RecordingHttpClient

+(Clip*) createClip:(Clip*) clip recording:(NSData*) data{
    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/api/clips"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *dict = [clip convertToDict];
    
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
    Clip *returnClip = [[Clip alloc]initWithDict:json];
    [self uploadRecording:data Id:returnClip.recordingId];
    return returnClip;
}

+(BOOL) uploadRecording:(NSData*) data Id: (NSString*) recordingId {
    NSLog(@"%ld",(unsigned long)data.length);
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/recordings/%@", recordingId];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---aS3eS9A8zSo1";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    //recording file
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"; filename=\"%@\"\r\n", @"audio.m4a"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: audio/m4a\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSError *error = [[NSError alloc] init];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSLog(response);
    if (error) return NO;
    return YES;
    
}

//Return all the clips that belongs to the given user id
+(NSArray*) getClips:(NSString*) userId {
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/clips/?creator=%@",userId ];
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

+(NSData*) getRecording:(NSString*) recordingId {
    
    NSString * getUrlString = [[NSString alloc] initWithFormat: @"http://test.nebulus.io:8080/api/recordings/%@/waveform", recordingId];
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
    
    return responseData;

}

+(BOOL) deleteClip:(Clip*) clip {
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/clips/%@", clip.objectID];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"DELETE"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (clip.recordingId) [self deleteRecording:clip.recordingId];
                               if (error) NSLog(@"%@", error.localizedDescription);
                           }];
    
    return YES;


}

+(BOOL) deleteRecording:(NSString *) recordingId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/recodings/%@", recordingId];
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
