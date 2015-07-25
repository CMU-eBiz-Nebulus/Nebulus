//
//  HttpClient.m
//  Nebulus
//
//  Created by Jike on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "HttpClient.h"


@implementation HttpClient
-(User*) getUser: (NSString*) username password: (NSString*) password; {
    
    User *user = [[User alloc] init];
    


    NSURL *aUrl = [NSURL URLWithString:@"http://test.nebulus.io:8080/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         username, @"username",
                         password, @"password",
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    [self parseResponse:data];
    return user;
}

- (void) parseResponse:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;
    
    //parsing the JSON response
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:NSJSONReadingAllowFragments
                     error:&error];
    if (jsonObject != nil && error == nil){
        NSLog(@"Successfully deserialized...");
        
        //check if the country code was valid
        //NSNumber *success = [jsonObject objectForKey:@"success"];
//        if([success boolValue] == YES){
//            
//            //if the second view controller doesn't exists create it
//            if(self.displayViewController == nil){
//                DisplayViewController *displayView = [[DisplayViewController alloc] init];
//                self.displayViewController = displayView;
//            }
//            
//            //set the country object of the second view controller
//            [self.displayViewController setJsonObject:[jsonObject objectForKey:@"countryInfo"]];
//            
//            //tell the navigation controller to push a new view into the stack
//            [self.navigationController pushViewController:self.displayViewController animated:YES];
//        }
//        else {
//            self.myLabel.text = @"Country Code is Invalid...";
//        }
        
    }
    
}

@end
