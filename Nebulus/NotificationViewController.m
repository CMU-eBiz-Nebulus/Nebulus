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
    if (self.notifications) NSLog(@"%lu",(unsigned long)self.notifications.count);
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.notifications count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"Type: %@, Msg: %@", notification.type, notification.message]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    return 35.0;
}

@end
