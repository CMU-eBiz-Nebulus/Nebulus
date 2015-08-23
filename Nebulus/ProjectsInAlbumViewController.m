//
//  ProjectsInAlbumViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/23/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ProjectsInAlbumViewController.h"
#import "AddProjectViewController.h"
#import "AlbumProjectViewController.h"
#import "MusicHttpClient.h"
#import "ProjectHttpClient.h"

@interface ProjectsInAlbumViewController ()
@property (nonatomic, strong) NSArray *projects; // of Project
@end

@implementation ProjectsInAlbumViewController

#pragma mark - property

-(NSArray *)projects{
    if(!_projects) _projects = @[];
    return _projects;
}

#pragma mark - view controller

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated{
    NSArray *projectIDs = [MusicHttpClient getAlbum:self.album.objectID].projects;
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    
    for(NSString *objectId in projectIDs){
        [projects addObject:[ProjectHttpClient getProject:objectId]];
    }
    
    self.projects = projects.copy;
    [self.tableView reloadData];
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

#pragma mark - segue


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addProjects"]) {
        if ([segue.destinationViewController isKindOfClass:[AddProjectViewController class]]) {
            AddProjectViewController *vc = (AddProjectViewController *)segue.destinationViewController;
            
            vc.user = self.user;
            vc.album = self.album;
        }
    }else if ([segue.identifier isEqualToString:@"showProject"]) {
        if ([segue.destinationViewController isKindOfClass:[AlbumProjectViewController class]]) {
            AlbumProjectViewController *vc = (AlbumProjectViewController *)segue.destinationViewController;
            
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            vc.mode = PROJECT_DETAIL;
            vc.content = [self.projects objectAtIndex:indexPath.row];
            vc.viewMode = YES;
        }
    }
}

@end
