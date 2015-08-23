//
//  AddProjectViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/23/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "AddProjectViewController.h"
#import "ProjectHttpClient.h"
#import "MusicHttpClient.h"

@interface AddProjectViewController ()
@property (nonatomic, strong) NSArray *projects; // of Project
@property (nonatomic, strong) NSMutableSet *projectSet;
@end

@implementation AddProjectViewController

#pragma mark - property

-(NSArray *)projects{
    if(!_projects) _projects = @[];
    return _projects;
}

#pragma mark - view controller

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    self.projects = [ProjectHttpClient getProjectsByUser:self.user.objectID];
    //self.projectSet = [[NSMutableSet alloc] init];
}

#pragma mark - table view source and delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.projects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self create_project_cell:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

-(UITableViewCell *)create_project_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row < self.projects.count){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithPhoto"];
        Project *project = self.projects[indexPath.row];
        
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:1];
        [imageview setContentMode:UIViewContentModeScaleToFill];
        [imageview setImage:[ProjectHttpClient getProjectImage:project.objectID]];
        
        //[imageview sizeToFit];
        [((UILabel *)[cell viewWithTag:2]) setText:project.projectName];
        ((UILabel *)[cell viewWithTag:3]).hidden = YES;
        [cell sizeToFit];
    }
    return cell;
}

#pragma mark - add projects action
- (IBAction)done:(UIBarButtonItem *)sender {
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    for(id index in selectedRows){
        NSIndexPath *indexPath = index;
        [projects addObject:self.projects[indexPath.row]];
    }
    self.album.projects = projects.copy;
    self.album = [MusicHttpClient updateAlbum:self.album];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
