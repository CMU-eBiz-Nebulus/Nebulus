//
//  CollaboratorsViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/10/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "CollaboratorsViewController.h"
#import "User.h"
#import "SearchViewController.h"
#import "UserHttpClient.h"

@interface CollaboratorsViewController ()
@end

@implementation CollaboratorsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if(!self.viewMode){
        UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(performInvite)];
        
        self.navigationItem.rightBarButtonItem = inviteButton;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)performInvite{
    if(self.mode == ALBUM_DETAIL){
        SearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
        vc.mode = M_ALBUM;
        vc.content = self.content;
        vc.searchForInvitation = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(self.mode == PROJECT_DETAIL){
        SearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
        vc.mode = M_PROJECT;
        vc.content = self.content;
        vc.searchForInvitation = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //TODO: refresh data here
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) return 1;
    else {
        if(self.mode == ALBUM_DETAIL){
            return [((Album *)self.content).editors count];
        } else {  //  PROJECT_DETAIL
            return [((Project *)self.content).editors count];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editorCell"];
    
    NSString *name = @"";
    UIImage *image = nil;
    if(indexPath.section == 0){
        if(self.mode == ALBUM_DETAIL){
            name = ((Album *)self.content).creator.username;
            image = [UserHttpClient getUserImage:((Album *)self.content).creator.objectID];
        } else {  //  PROJECT_DETAIL
            name = ((Project *)self.content).creator.username;
            image = [UserHttpClient getUserImage:((Project *)self.content).creator.objectID];
        }
    } else {
        if(self.mode == ALBUM_DETAIL){
            name = ((User *)[((Album *)self.content).editors objectAtIndex:indexPath.row]).username;
            image = [UserHttpClient getUserImage:((User *)[((Album *)self.content).editors objectAtIndex:indexPath.row]).objectID];
        } else {  //  PROJECT_DETAIL
            name = ((User *)[((Project *)self.content).editors objectAtIndex:indexPath.row]).username;
            image = [UserHttpClient getUserImage:((User *)[((Project *)self.content).editors objectAtIndex:indexPath.row]).objectID];
        }
    }

    if(image)[((UIImageView *)[cell viewWithTag:101]) setImage:image];
    [((UILabel *)[cell viewWithTag:102]) setText:name];

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Creator";
    } else {// if (section == 1){
        return @"Editors";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


@end
