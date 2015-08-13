//
//  SearchViewController.m
//  Nebulus
//
//  Created by Gang Wu on 7/29/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "SearchViewController.h"
#import "User.h"
#import "UserHttpClient.h"
#import "MusicHttpClient.h"
#import "OtherProfileViewController.h"
#import "AlbumProjectViewController.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *albums;

@property (weak, nonatomic) IBOutlet UITextField *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

-(NSArray *)users{
    if(!_users) _users = @[];
    return _users;
}

-(NSArray *)albums{
    if(!_albums) _albums = @[];
    return _albums;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (IBAction)changed:(UITextField *)sender {
    
    if([sender.text length] > 0){
        self.users = [UserHttpClient searchUser:sender.text];
    }
    [self.tableView reloadData];

}


#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(![self.searchBar.text length]) return 0;
    
    if(section == 0)        return [self.users count] == 0 ? 1 : [self.users count];
    else if (section == 1)  return [self.albums count] == 0 ? 1 : [self.albums count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){

        if([self.searchBar.text length] && [self.users count] == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            [cell.textLabel setText:@"No users found"];
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        User *user = [self.users objectAtIndex:indexPath.row];
        
        [(UIImageView *)[cell viewWithTag:101] setImage: [UserHttpClient getUserImage:user.objectID]];
        [(UIImageView *)[cell viewWithTag:101] setContentMode:UIViewContentModeScaleToFill];
        [(UILabel *)[cell viewWithTag:102] setText:user.username];
        
        return cell;
    } else if(indexPath.section == 1){
        
        if([self.searchBar.text length] && [self.albums count] == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            [cell.textLabel setText:@"No albums found"];
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCell"];
        Album *album = [self.albums objectAtIndex:indexPath.row];
        
        [(UIImageView *)[cell viewWithTag:101] setImage: [MusicHttpClient getAlbumImage:album.objectID]];
        [(UIImageView *)[cell viewWithTag:101] setContentMode:UIViewContentModeScaleToFill];
        [(UILabel *)[cell viewWithTag:102] setText:album.name];
        
        return cell;
    }
    
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if([self.searchBar.text length]){
        if      (section == 0) return @"Users";
        else if (section == 1) return @"Albums";
    }
    
    return @"";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( (indexPath.section == 0 && [self.users count] == 0)
        || (indexPath.section == 1 && [self.albums count] == 0)){
        return 35.0;
    } else return 70.0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"searchUser"]) {
        if ([segue.destinationViewController isKindOfClass:[OtherProfileViewController class]]) {
            OtherProfileViewController *vc = (OtherProfileViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            

            vc.me = [UserHttpClient getCurrentUser];
            vc.other = [self.users objectAtIndex:[self.tableView indexPathForCell:cell].row];
            vc.invitation_mode = NO;
        }
    } else if([segue.identifier isEqualToString:@"searchAlbumProject"]){
        if ([segue.destinationViewController isKindOfClass:[AlbumProjectViewController class]]) {
            AlbumProjectViewController *vc = (AlbumProjectViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            
            
//            vc.me = [UserHttpClient getCurrentUser];
//            vc.other = [self.users objectAtIndex:[self.tableView indexPathForCell:cell].row];
        }
    }
}

@end
