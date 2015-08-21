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
#import "ActivityHttpClient.h"

@interface NotificationViewController() <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic) NSUInteger unread;
@property (nonatomic, strong) Notification *invitationToRespond;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation NotificationViewController

-(NSArray *)notifications{
    if(!_notifications) _notifications = @[];
    return _notifications;
}

- (IBAction)doRefresh:(UIRefreshControl *)sender {
    [self fetch_notifications];
    [self.refreshControl endRefreshing];
}

-(void)fetch_notifications{
    
    NSMutableArray *tmpNots = [UserHttpClient getUserNotification:[UserHttpClient getCurrentUser].objectID].mutableCopy;
    
    NSMutableArray *dstArray = [[NSMutableArray alloc] init];
    
    self.unread = 0;
    for(Notification *notification in tmpNots){
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
        
        //NSLog(notification.read ? @"Notification Read\n" : @"Unread\n");
    }
    
    self.notifications = dstArray.copy;

    [self.tableView reloadData];
    [self updateUI];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.indicator = [[UIActivityIndicatorView alloc]
                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UIView *view = [[UIView alloc] initWithFrame:self.tableView.tableHeaderView.bounds];
    [view addSubview:self.indicator];
    self.tableView.tableHeaderView = view;
    
    [self.indicator startAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetch_notifications];
        [self.indicator stopAnimating];
    });
    
}

-(void)updateUI{
    if(self.unread){
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1]
         setBadgeValue: [NSString stringWithFormat:@"%tu", self.unread]];
    }else{
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1]
         setBadgeValue:nil];
    }
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
    const CGFloat fontSize = 14;
    
    if([notification.model isEqualToString:@"invites"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"invitesCell"];
        
        Invite *invite = [ActivityHttpClient getInvite:notification.modelId];
        UIImage *image = nil;
        if(invite.album){
            image = [MusicHttpClient getAlbumImage:invite.album.objectID];
        }else if(invite.project){
            image = [ProjectHttpClient getProjectImage:invite.project.objectID];
        }
        
        if(image){
            [(UIImageView *)[cell viewWithTag:101] setImage:image];
            [((UIImageView *)[cell viewWithTag:101]).layer setCornerRadius:5];
        }
        
        NSString *text = [NSString stringWithFormat:@"Invitation: %@", msg];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}
                                range: NSMakeRange(0, 11)];
        
        if(notification.read){
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }else{
            [attributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }
        
        [(UITextView *)[cell viewWithTag:102] setAttributedText:attributedText];
        [(UIButton *)[cell viewWithTag:103] setHidden:notification.read ? YES : NO];
    }else if([notification.model isEqualToString:@"albums"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"albumprojectCell"];
        
        UIImage *image = [MusicHttpClient getAlbumImage:notification.modelId];
        if(image){
            [(UIImageView *)[cell viewWithTag:101] setImage:image];
            [((UIImageView *)[cell viewWithTag:101]).layer setCornerRadius:5];
        }
        
        NSString *text = [NSString stringWithFormat:@"Album: %@", msg];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}
                                range: NSMakeRange(0, 6)];
        
        if(notification.read){
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }else{
            [attributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }
        
        [(UITextView *)[cell viewWithTag:102] setAttributedText:attributedText];
    }else if([notification.model isEqualToString:@"projects"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"albumprojectCell"];
        
        UIImage *image = [ProjectHttpClient getProjectImage:notification.modelId];
        if(image){
            [(UIImageView *)[cell viewWithTag:101] setImage:image];
            [((UIImageView *)[cell viewWithTag:101]).layer setCornerRadius:5];
        }
        
        NSString *text = [NSString stringWithFormat:@"Project: %@", msg];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}
                                range: NSMakeRange(0, 8)];
        
        if(notification.read){
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }else{
            [attributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }
        
        [(UITextView *)[cell viewWithTag:102] setAttributedText:attributedText];
    }else if([notification.model isEqualToString:@"followers"]){
        User* follower = [UserHttpClient getFollowerByModelId:notification.modelId];
        cell = [tableView dequeueReusableCellWithIdentifier:@"followersCell"];
        
        UIImage *image = [UserHttpClient getUserImage:follower.objectID];
        if(image){
            [(UIImageView *)[cell viewWithTag:101] setImage:image];
            [((UIImageView *)[cell viewWithTag:101]).layer setCornerRadius:5];
        }
        
        NSString *text = [NSString stringWithFormat:@"%@ %@", follower.username, msg];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];

        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}
                                range: NSMakeRange(0, follower.username.length)];
        
        if(notification.read){
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }else{
            [attributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontSize] range:NSMakeRange(0, attributedText.length)];
        }
        
        [(UITextView *)[cell viewWithTag:102] setAttributedText:attributedText];
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
    
    if(notification && notification.objectID){
        [cell setBackgroundColor: notification.read ? [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] :[UIColor whiteColor]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
    if([notification.model isEqualToString:@"invites"]){
        return 56.0;
    }else if([notification.model isEqualToString:@"albums"]){
        return 56.0;
    }else if([notification.model isEqualToString:@"projects"]){
        return 56.0;
    }else if([notification.model isEqualToString:@"followers"]){
        return 56.0;
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
    }else
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
            if(!notification.read) {
                [UserHttpClient readNotification:notification];
                
                [self.indicator startAnimating];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fetch_notifications];
                    [self.indicator stopAnimating];
                });
            }
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
            if(!notification.read) {
                [UserHttpClient readNotification:notification];
                
                [self.indicator startAnimating];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fetch_notifications];
                    [self.indicator stopAnimating];
                });
            }
        }
    } else if ([segue.identifier isEqualToString:@"inviteToAlbumProject"]){
        AlbumProjectViewController *vc = (AlbumProjectViewController *)segue.destinationViewController;
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        
        Notification *notification = [self.notifications objectAtIndex:[self.tableView indexPathForCell:cell].row];

        Invite *invite = [ActivityHttpClient getInvite:notification.modelId];
        
        if(invite.album != nil){
            vc.mode = ALBUM_DETAIL;
            vc.content = [MusicHttpClient getAlbum:invite.album.objectID];
        }else if(invite.project != nil){
            vc.mode = PROJECT_DETAIL;
            vc.content = [ProjectHttpClient getProject:invite.project.objectID];
        }
        
        vc.viewMode = YES;
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
                                                         message:[self htmlStr2Str:notification.message]
                                                        delegate:self
                                               cancelButtonTitle:@"Reject"
                                               otherButtonTitles: nil];
        [alert addButtonWithTitle:@"Accept"];
        [alert show];
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(self.invitationToRespond && !self.invitationToRespond.read){
        if (buttonIndex == 0){
            [ProjectHttpClient responseToInvite:self.invitationToRespond.modelId accept:NO];
            [UserHttpClient readNotification:self.invitationToRespond];
        }
        else if(buttonIndex == 1){
            [ProjectHttpClient responseToInvite:self.invitationToRespond.modelId accept:YES];
            [UserHttpClient readNotification:self.invitationToRespond];
        }
        
        [self.indicator startAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetch_notifications];
            [self.indicator stopAnimating];
        });
    }
}

@end
