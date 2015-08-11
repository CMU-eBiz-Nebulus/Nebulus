//
//  RecordingHttpClient.m
//  Nebulus
//
//  Created by Jike on 8/11/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "RecordingHttpClient.h"

@implementation RecordingHttpClient

+(BOOL) uploadRecording:(NSData*) data Id: (NSString*) recordingId {
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://test.nebulus.io:8080/api/recordings/"];
    NSURL *aUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---aS3eS9A8zSo1";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    //recording ID
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[recordingId dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //recording file
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"audio/mpeg\"; filename=\"%@\"\r\n", @"picture.png"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [request setHTTPBody:body];
    
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSError *error = [[NSError alloc] init];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) return NO;
    return YES;
    
}

@end
