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
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self fetch_contents];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Number of entries : %d", self.contents.count);
    return self.contents ? [self.contents count] : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.mode) {
        case CLIPS:
            return [self create_clip_cell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case PROJECTS:
            break;
        case ALBUMS:
            break;
        default:
            break;
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
            break;
        case ALBUMS:
            break;
        default:
            break;
    }
}


#pragma mark - CLIPS

-(void)fetch_clips{
    self.contents = @[@"clip1", @"clip2", @"clip3"];
}

-(UITableViewCell *)create_clip_cell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.mode == CLIPS){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithoutPhoto"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellWithoutPhoto"];
        }
        [cell.textLabel setText:[self.contents objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = @"time";
    }
    return cell;
}

@end
