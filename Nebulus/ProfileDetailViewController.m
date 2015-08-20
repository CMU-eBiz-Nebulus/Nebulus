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
#import "ProjectHttpClient.h"
#import "PlayFileViewController.h"

@interface ProfileDetailViewController ()

@property (nonatomic, strong) NSArray *contents;
@property (strong, nonatomic) IBOutlet UITableView *currTableView;

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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    self.contents =  [RecordingHttpClient getClips:self.user.objectID];
    [self setTitle:[NSString stringWithFormat:@"%ld clips", [self.contents count]]];
}

-(void)fetch_albums{
    self.contents = [MusicHttpClient getAlbumsByUser:self.user.objectID];
}

-(void)fetch_projects{
    self.contents = [ProjectHttpClient getProjectsByUser:self.user.objectID];
}

-(UITableViewCell *)create_clip_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == CLIPS){
        Clip *clip = self.contents[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithoutPhoto"];
        [cell.textLabel setText:clip.name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Duration: %@", clip.duration.stringValue];
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
        [((UILabel *)[cell viewWithTag:3]) setText:[NSString stringWithFormat:@"%ld Songs", [album.projects count]]];
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
        [imageview setContentMode:UIViewContentModeScaleToFill];
        [imageview setImage:[ProjectHttpClient getProjectImage:project.objectID]];

        //[imageview sizeToFit];
        [((UILabel *)[cell viewWithTag:2]) setText:project.projectName];
        ((UILabel *)[cell viewWithTag:3]).hidden = YES;
        [cell sizeToFit];
    }
    return cell;
}

#pragma mark - delete clip

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.mode == CLIPS){
        if (editingStyle ==UITableViewCellEditingStyleDelete) {
            Clip *clip = [self.contents objectAtIndex: indexPath.row];
            [RecordingHttpClient deleteClip:clip];
            [self fetch_clips];
            [tableView reloadData];
            //[tableView deleteRowsAtIndexPaths:[NSArrayarrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
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
            if([self.user.objectID isEqualToString:[UserHttpClient getCurrentUser].objectID]){
                vc.viewMode = NO;
            }else{
                vc.viewMode = YES;
            }
        }
    }
    else if ([segue.identifier isEqualToString:@"playerView"]){
        if ([segue.destinationViewController isKindOfClass:[PlayFileViewController class]]) {
            PlayFileViewController *vc = (PlayFileViewController *)segue.destinationViewController;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Clip *clip = (Clip*)[self.contents objectAtIndex:indexPath.row];
            NSData *recording = [RecordingHttpClient getRecording:clip.recordingId];
//            [recording writeToURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
//                                                          [self applicationDocumentsDirectory],
//                                                          clip.name]]  atomically:YES];
            vc.filePath =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",
                                                 [self applicationDocumentsDirectory],
                                                 clip.name]];
        }
 
    }
}

- (NSString *)applicationDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
