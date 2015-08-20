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

@interface CollaboratorsViewController ()
@end

@implementation CollaboratorsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if(!self.viewMode){
        UIBarButtonItem *Invite = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(performInvite)];
        self.navigationItem.rightBarButtonItem = Invite;
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
    if(indexPath.section == 0){
        if(self.mode == ALBUM_DETAIL){
            name = ((Album *)self.content).creator.username;
        } else {  //  PROJECT_DETAIL
            name = ((Project *)self.content).creator.username;
        }
    } else {
        if(self.mode == ALBUM_DETAIL){
            name = ((User *)[((Album *)self.content).editors objectAtIndex:indexPath.row]).username;
        } else {  //  PROJECT_DETAIL
            name = ((User *)[((Project *)self.content).editors objectAtIndex:indexPath.row]).username;
        }
    }

    [cell.textLabel setText: name];
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
