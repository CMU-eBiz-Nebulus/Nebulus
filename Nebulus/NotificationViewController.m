//
//  NotificationViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/13/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "NotificationViewController.h"
#import "UserHttpClient.h"

@interface NotificationViewController()

@property (nonatomic, strong) NSArray *notifications;

@end

@implementation NotificationViewController

-(NSArray *)notifications{
    if(!_notifications) _notifications = @[];
    return _notifications;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.notifications = [UserHttpClient getUserNotification:[UserHttpClient getCurrentUser].objectID];
    
    NSLog(@"count : %ld", [self.notifications count]);
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.notifications count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
    NSString *msg = [self htmlStr2Str:notification.message];
    
    if([notification.model isEqualToString:@"invites"]){
    }else if([notification.model isEqualToString:@"albums"]){
    }else if([notification.model isEqualToString:@"projects"]){
    }else if([notification.model isEqualToString:@"followers"]){
//    }else if([notification.model isEqualToString:@"activity"]){
//    }else if([notification.model isEqualToString:@"likes"]){
//    }else if([notification.model isEqualToString:@"comments"]){
//    }else if([notification.model isEqualToString:@"conversations"]){
//    }else if([notification.model isEqualToString:@"tasks"]){
//    }else if([notification.model isEqualToString:@"userSettings"]){
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@: %@", notification.model, msg]];
    }
    

    [tableView dequeueReusableCellWithIdentifier:@"noti"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
    if([notification.model isEqualToString:@"invites"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"albums"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"projects"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"followers"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"activity"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"likes"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"comments"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"conversations"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"tasks"]){
        return 25.0;
    }else if([notification.model isEqualToString:@"userSettings"]){
        return 25.0;
    }
    return 0.0;
}

-(NSString *)htmlStr2Str:(NSString *)htmlString{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                            options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType }
                                                                 documentAttributes:nil
                                                                              error:nil];
    return attributedString.string;
}

@end
