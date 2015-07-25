//
//  ProfileDetailViewController.m
//  Nebulus
//
//  Created by Gang Wu on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ProfileDetailViewController.h"

@interface ProfileDetailViewController ()

@property (nonatomic, strong) NSArray *contents;

@end

@implementation ProfileDetailViewController


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
}


#pragma mark - CLIPS

-(void)fetch_clips{
    self.contents = @[@"clip 1", @"clip 2", @"clip 3", @"clip 4"];
}

-(void)fetch_albums{
    self.contents = @[@"album 1", @"album 2", @"album 3"];
}

-(void)fetch_projects{
    self.contents = @[@"project 1", @"project 2", @"project 3", @"project 4"];
}

-(UITableViewCell *)create_clip_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == CLIPS){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithoutPhoto"];
//        if(!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellWithoutPhoto"];
//        }
        [cell.textLabel setText:[self.contents objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = @"2015-07-24";
    }
    return cell;
}

-(UITableViewCell *)create_album_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == ALBUMS){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithPhoto"];
        UIImageView *imageview = [cell viewWithTag:1];
        [imageview setImage:[UIImage imageNamed:@"pic1"]];
        //[imageview setContentMode:UIViewContentModeScaleToFill];
        [imageview sizeToFit];
        [((UILabel *)[cell viewWithTag:2]) setText:[self.contents objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(UITableViewCell *)create_project_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == PROJECTS){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithPhoto"];
        UIImageView *imageview = [cell viewWithTag:1];
        [imageview setImage:[UIImage imageNamed:@"pic1"]];
        //[imageview setContentMode:UIViewContentModeScaleToFill];
        [imageview sizeToFit];
        [((UILabel *)[cell viewWithTag:2]) setText:[self.contents objectAtIndex:indexPath.row]];
    }
    return cell;
}

@end
