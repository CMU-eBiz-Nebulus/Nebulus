//
//  ProfileDetailViewController.m
//  Nebulus
//
//  Created by Gang Wu on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "CreateProjectAlbumViewController.h"
#import "RecordViewController.h"
#import "MusicHttpClient.h"
#import "UserHttpClient.h"
#import "AlbumProjectViewController.h"
#import "RecordingHttpClient.h"

@interface ProfileDetailViewController ()

@property (nonatomic, strong) NSArray *contents;

@end

@implementation ProfileDetailViewController

-(IBAction)manualSegueForCreation:(UIBarButtonItem *)sender {
    
    if(self.mode == PROJECTS){
        CreateProjectAlbumViewController *cpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"createProjectOrAlbum"];
        cpvc.mode = PROJECT;
        cpvc.backVC = self;
        [self.navigationController pushViewController:cpvc animated:YES];
    } else if (self.mode == ALBUMS){
        CreateProjectAlbumViewController *cavc = [self.storyboard instantiateViewControllerWithIdentifier:@"createProjectOrAlbum"];
        cavc.mode = ALBUM;
        cavc.backVC = self;
        [self.navigationController pushViewController:cavc animated:YES];
    } else if (self.mode == CLIPS){
        RecordViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"recordViewController"];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

-(void)setContents:(NSArray *)contents{
    _contents = contents ? contents : nil;
}

#pragma mark - TableView

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetch_contents];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.contents = nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"Number of entries : %d", self.contents.count);
    return self.contents ? [self.contents count] : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.mode) {
        case CLIPS: return [self create_clip_cell:tableView cellForRowAtIndexPath:indexPath];
        case PROJECTS: return [self create_project_cell:tableView cellForRowAtIndexPath:indexPath];
        case ALBUMS: return [self create_album_cell:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mode == ALBUMS || self.mode == PROJECTS){
        return 100.0;
    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithoutPhoto"];
        return cell.frame.size.height;
    }
}

#pragma mark - Generic data

-(void)fetch_contents{
    switch (self.mode) {
        case CLIPS:
            [self fetch_clips];
            break;
        case PROJECTS:
            [self fetch_projects];
            break;
        case ALBUMS:
            [self fetch_albums];
            break;
    }
    [self.tableView reloadData];
}


#pragma mark - CLIPS

-(void)fetch_clips{
    self.contents =  [RecordingHttpClient getClips:[UserHttpClient getCurrentUser].objectID];
}

-(void)fetch_albums{
    self.contents = [MusicHttpClient getAlbumsByUser:[UserHttpClient getCurrentUser].objectID];
}

-(void)fetch_projects{
    self.contents = [MusicHttpClient getProjectsByUser:[UserHttpClient getCurrentUser].objectID];
}

-(UITableViewCell *)create_clip_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == CLIPS){
        Clip *clip = self.contents[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithoutPhoto"];
        [cell.textLabel setText:clip.name];
        cell.detailTextLabel.text = clip.duration.stringValue;
    }
    return cell;
}

-(UITableViewCell *)create_album_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == ALBUMS){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithPhoto"];
        Album *album = self.contents[indexPath.row];

        UIImageView *imageview = (UIImageView *)[cell viewWithTag:1];
        [imageview setContentMode:UIViewContentModeScaleToFill];
        [imageview setImage:[MusicHttpClient getAlbumImage:album.objectID]];
        //[imageview sizeToFit];
        [((UILabel *)[cell viewWithTag:2]) setText:album.name];
        [cell sizeToFit];
    }
    return cell;
}

-(UITableViewCell *)create_project_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == PROJECTS){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithPhoto"];
        Project *project = self.contents[indexPath.row];
        
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:1];
        [imageview setImage:[UIImage imageNamed:@"pic1"]];
        [imageview setContentMode:UIViewContentModeScaleToFill];
        //[imageview setImage:[MusicHttpClient getProjectImage:project.objectID]];

        //[imageview sizeToFit];
        [((UILabel *)[cell viewWithTag:2]) setText:project.projectName];
        [cell sizeToFit];
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detailAlbumProject"]) {
        if ([segue.destinationViewController isKindOfClass:[AlbumProjectViewController class]]) {
            AlbumProjectViewController *vc = (AlbumProjectViewController *)segue.destinationViewController;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            id content = [self.contents objectAtIndex:indexPath.row];
            if(self.mode == PROJECTS){
                vc.mode = PROJECT_DETAIL;
                vc.content = content;
            } else if (self.mode == ALBUMS){
                vc.mode = ALBUM_DETAIL;
                vc.content = content;
            }
        }
    }
}
@end
