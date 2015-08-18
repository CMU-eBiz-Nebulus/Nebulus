//
//  NotificationViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/13/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "NotificationViewController.h"
#import "UserHttpClient.h"
#import "AlbumProjectViewController.h"
#import "ProjectHttpClient.h"
#import "MusicHttpClient.h"
#import "UserHttpClient.h"
#import "OtherProfileViewController.h"

@interface NotificationViewController() <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic) NSUInteger unread;
@property (nonatomic, strong) Notification *invitationToRespond;

@end

@implementation NotificationViewController

-(NSArray *)notifications{
    if(!_notifications) _notifications = @[];
    return _notifications;
}

-(void)fetch_notifications{
    NSMutableArray *tmpNots = [UserHttpClient getUserNotification:[UserHttpClient getCurrentUser].objectID].mutableCopy;
    
    NSMutableArray *dstArray = [[NSMutableArray alloc] init];
    
    self.unread = 0;
    for(Notification *notification in tmpNots.reverseObjectEnumerator){
        if([notification.model isEqualToString:@"invites"]){
            

        }else if([notification.model isEqualToString:@"albums"]){
            Album *album = [MusicHttpClient getAlbum:notification.modelId];
            if(!album || !album.name){
                continue;
            }
        }else if([notification.model isEqualToString:@"projects"]){
            Project *project = [ProjectHttpClient getProject:notification.modelId];
            if(!project || !project.projectName){
                continue;
            }
        }else if([notification.model isEqualToString:@"followers"]){
            User* follower = [UserHttpClient getFollowerByModelId:notification.modelId];
            if(!follower || !follower.username){
                continue;
            }
        }else if([notification.model isEqualToString:@"activity"]){
        }else if([notification.model isEqualToString:@"likes"]){
        }else if([notification.model isEqualToString:@"comments"]){
        }else if([notification.model isEqualToString:@"conversations"]){
        }else if([notification.model isEqualToString:@"tasks"]){
        }else if([notification.model isEqualToString:@"userSettings"]){
        }else{
            
        }
        if(!notification.read) self.unread++;
        [dstArray addObject:notification];
        
        NSLog(notification.read ? @"Notification Read\n" : @"Unread\n");
        
    }

    ////////////////////////////////////////////////////
    Notification *n = [[Notification alloc] init];
    n.model = @"invites";
    n.message = @"Someone invited you to join xx";
    [dstArray addObject:n];
    
    ////////////////////////////////////////////////////
    
    self.notifications = dstArray.copy;
    if(self.unread){
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1]
         setBadgeValue: [NSString stringWithFormat:@"%tu", self.unread]];
    }else{
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1]
         setBadgeValue:nil];
    }
    
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self fetch_notifications];
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"invitesCell"];
        [(UILabel *)[cell viewWithTag:101] setText:[NSString stringWithFormat:@"%@", msg]];
    }else if([notification.model isEqualToString:@"albums"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"albumprojectCell"];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@: %@", notification.model, msg]];
    }else if([notification.model isEqualToString:@"projects"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"albumprojectCell"];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@: %@", notification.model, msg]];
    }else if([notification.model isEqualToString:@"followers"]){
        User* follower = [UserHttpClient getFollowerByModelId:notification.modelId];
        cell = [tableView dequeueReusableCellWithIdentifier:@"followersCell"];
        
        NSString *text = [NSString stringWithFormat:@"%@ %@", follower.username, msg];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];

        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor],
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize]}
                                range: NSMakeRange(0, follower.username.length)];
        
        [cell.textLabel setAttributedText:attributedText];
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
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
//    if([notification.model isEqualToString:@"invites"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"albums"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"projects"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"followers"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"activity"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"likes"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"comments"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"conversations"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"tasks"]){
//        return 35.0;
//    }else if([notification.model isEqualToString:@"userSettings"]){
//        return 35.0;
//    }
    return 40.0;
}

-(NSString *)htmlStr2Str:(NSString *)htmlString{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                            options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType }
                                                                 documentAttributes:nil
                                                                              error:nil];
    return attributedString.string;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"notificationAlbumProject"]) {
        if ([segue.destinationViewController isKindOfClass:[AlbumProjectViewController class]]) {
            AlbumProjectViewController *vc = (AlbumProjectViewController *)segue.destinationViewController;

            UITableViewCell *cell = (UITableViewCell *)sender;
            
            Notification *notification = [self.notifications objectAtIndex:[self.tableView indexPathForCell:cell].row];
            
            if([notification.model isEqualToString:@"albums"]){
                vc.mode = ALBUM_DETAIL;
                vc.content = [MusicHttpClient getAlbum:notification.modelId];
            }else if([notification.model isEqualToString:@"projects"]){
                vc.mode = PROJECT_DETAIL;
                vc.content = [ProjectHttpClient getProject:notification.modelId];
            }
            
            vc.viewMode = NO;
            
            // READ notification
            //if(!notification.read) [UserHttpClient readNotification:notification];
        }
    } else if ([segue.identifier isEqualToString:@"followNotification"]) {
        if ([segue.destinationViewController isKindOfClass:[OtherProfileViewController class]]) {
            OtherProfileViewController *vc = (OtherProfileViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            
            Notification *notification = [self.notifications objectAtIndex:[self.tableView indexPathForCell:cell].row];
            
            vc.me = [UserHttpClient getCurrentUser];
            vc.other = [UserHttpClient getFollowerByModelId:notification.modelId];
            vc.invitation_mode = NO;
            
            // READ notification
            //if(!notification.read) [UserHttpClient readNotification:notification];
        }
    }

}

#pragma mark - Invite response
- (IBAction)respondToInvite:(UIButton *)sender {
    
    UIButton *button = sender;
    CGRect buttonFrame = [button convertRect:button.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrame.origin];
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
    
    if ([notification.model isEqualToString:@"invites"]) {
        self.invitationToRespond = notification;
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Invitation"
                                                         message:notification.message
                                                        delegate:self
                                               cancelButtonTitle:@"Reject"
                                               otherButtonTitles: nil];
        [alert addButtonWithTitle:@"Accept"];
        [alert show];
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        NSLog(@"You have clicked Reject");
    }
    else if(buttonIndex == 1){
        NSLog(@"You have clicked Accept");
    }
}

@end
