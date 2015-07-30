//
//  MusicHttpClient.m
//  Nebulus
//
//  Created by Jike on 7/30/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "MusicHttpClient.h"

@implementation MusicHttpClient

+(NSArray*) searchUser:(NSString*) searchStr {
    NSString *consumerKey = @"4mCltr6EkIFMMKXSmI9ZAA";
    NSString *ConsumerSecret = @"uGn5WulOb_I5Pr240iIAHhcwBBw";
    NSString *token	= @"Bkk5g_dMo18B5e0kepfC7rqdtQC1Vmtw";
    NSString *tokenSecret = @"UkG5Ep-JEQwTm958KPD2-oP6HqM";
    
    NSString *getUrlString = [[NSString alloc] initWithFormat: @"http://api.yelp.com/v2/phone_search?phone=+%@", searchStr];
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
//    NSMutableArray *users = [[NSMutableArray alloc]init];
//    for (int i = 0; i < [raw count]; i++) {
//        NSDictionary* json = raw[i];
//        User *u = [[User alloc] initWithDict:json];
//        [users addObject:u];
//    }
    return nil;
}

@end
