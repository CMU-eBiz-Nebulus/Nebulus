//
//  TimelineViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/5/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()
@property (strong, nonatomic) NSArray *contents;
@end

@implementation TimelineViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 3;
    } else if (section == 1){
        return 4;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0){
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];

            [(UILabel *)[cell viewWithTag:102] setText:@"Bon Jovi"];
            [(UILabel *)[cell viewWithTag:103] setText:@"1 min ago"];
            [(UILabel *)[cell viewWithTag:104] setText:@"Shared a song"];
        } else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            UITextView *textView = (UITextView *)[cell viewWithTag:101];
            [textView setText:@"Rock the world"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"buttomCell"];
        }
    } else if (indexPath.section == 1){
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
            
            [(UILabel *)[cell viewWithTag:102] setText:@"Taylor Swift"];
            [(UILabel *)[cell viewWithTag:103] setText:@"5 min ago"];
            [(UILabel *)[cell viewWithTag:104] setText:@"Shared a clip"];
        } else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
            UITextView *textView = (UITextView *)[cell viewWithTag:101];
            [textView setText:@"Listen to this song!"];
        } else if(indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"audioPlayCell"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"buttomCell"];
        }
    }
    
    return cell;
}

#define HEIGHT_TOP_CELL     80.0
#define HEIGHT_BOTTOM_CELL  35.0
#define HEIGHT_TEXT_CELL    35.0
#define HEIGHT_PLAY_CELL    45.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if(indexPath.row == 0){
            return HEIGHT_TOP_CELL;
        } else if(indexPath.row == 1){
            return HEIGHT_TOP_CELL;
        } else {
            return HEIGHT_BOTTOM_CELL;
        }
    } else if (indexPath.section == 1){
        if(indexPath.row == 0){
            return HEIGHT_TOP_CELL;

        } else if(indexPath.row == 1){
            return HEIGHT_TEXT_CELL;
        } else if(indexPath.row == 2){
            return HEIGHT_PLAY_CELL;
        } else {
            return HEIGHT_BOTTOM_CELL;
        }
    }
    return 0.0;
}




@end
