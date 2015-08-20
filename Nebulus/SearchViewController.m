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
#import "ProjectHttpClient.h"
#import "OtherProfileViewController.h"
#import "AlbumProjectViewController.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource,
UITextFieldDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) NSArray *projects;

@property (atomic, strong) NSMutableArray *searchQueue;
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

@synthesize searchQueue = _searchQueue;
-(NSMutableArray *)searchQueue{
    if(!_searchQueue)_searchQueue = [[NSMutableArray alloc] init];
    return _searchQueue;
}

-(void)setSearchQueue:(NSMutableArray *)searchQueue{
    _searchQueue = searchQueue;
}

-(NSArray *)users{
    if(!_users) _users = @[];
    return _users;
}

-(NSArray *)albums{
    if(!_albums) _albums = @[];
    return _albums;
}

-(NSArray *)projects{
    if(!_projects)_projects = @[];
    return _projects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // textfield return keyboard by clicking return button
    self.searchBar.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    //self.searchForInvitation = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id subview in subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = subview;
            if ([subview isFirstResponder]) {
                [textField resignFirstResponder];
            }
        }
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector: @selector(timerActivated)
                                                userInfo: nil
                                                 repeats: YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)timerActivated{
    if([self.searchQueue count]){
        NSString *str= [self.searchQueue lastObject];
        [self.searchQueue removeAllObjects];
        
        if([str length] > 0){
            
            BOOL isLegal = YES;
            NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
            for (int i = 0; i < [str length]; i++){
                unichar c = [str characterAtIndex:i];
                if (![charSet characterIsMember:c]) {
                    isLegal =  NO;
                }
            }
            
            if (isLegal) {
                self.users = [UserHttpClient searchUser:str];
                if(!self.searchForInvitation){
                    self.albums = [MusicHttpClient searchAlbum:str];
                    self.projects = [self searchSelfProjectByWord:str];
                }
            }
        }
        [self.tableView reloadData];
    }
}


- (IBAction)changed:(UITextField *)sender {
    
    if([sender.text length] > 0){
        [self.searchQueue addObject:sender.text];
    } else {
        [self.searchQueue removeAllObjects];
        [self.tableView reloadData];
    }


//    if([sender.text length] > 0){
//        self.users = [UserHttpClient searchUser:sender.text];
//        self.albums = [MusicHttpClient searchAlbum:sender.text];
//    }
//    [self.tableView reloadData];

}


#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.searchForInvitation ? 1 : 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(![self.searchBar.text length]) return 0;
    
    if(section == 0)        return [self.users count] == 0 ? 1 : [self.users count];
    else if (section == 1)  return [self.albums count] == 0 ? 1 : [self.albums count];
    else if (section == 2)  return [self.projects count] == 0 ? 1 : [self.projects count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){ // result for searching users

        if([self.searchBar.text length] && [self.users count] == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            [cell.textLabel setText:@"No users found"];
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        User *user = [self.users objectAtIndex:indexPath.row];
        
        UIImage *image = [UserHttpClient getUserImage:user.objectID];
        if(image){
            [(UIImageView *)[cell viewWithTag:101] setImage: image];
            [(UIImageView *)[cell viewWithTag:101] setContentMode:UIViewContentModeScaleToFill];
        }
        [(UILabel *)[cell viewWithTag:102] setText:user.username];
        
        return cell;
    } else if(indexPath.section == 1){  // result for searching album
        
        if([self.searchBar.text length] && [self.albums count] == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            [cell.textLabel setText:@"No albums found"];
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCell"];
        Album *album = [self.albums objectAtIndex:indexPath.row];
        
        UIImage *image = [MusicHttpClient getAlbumImage:album.objectID];
        if(image){
            [(UIImageView *)[cell viewWithTag:101] setImage: image];
            [(UIImageView *)[cell viewWithTag:101] setContentMode:UIViewContentModeScaleToFill];
        }
        [(UILabel *)[cell viewWithTag:102] setText:album.name];
        
        return cell;
    } else if(indexPath.section == 2){  // result for searching project
        
        if([self.searchBar.text length] && [self.projects count] == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            [cell.textLabel setText:@"No projects found"];
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicCell"];
        Project *project = [self.projects objectAtIndex:indexPath.row];
        
        UIImage *image = [ProjectHttpClient getProjectImage:project.objectID];
        if (image) {
            [(UIImageView *)[cell viewWithTag:101] setImage: image];
            [(UIImageView *)[cell viewWithTag:101] setContentMode:UIViewContentModeScaleToFill];
        }
        [(UILabel *)[cell viewWithTag:102] setText:project.projectName];
        
        return cell;
    }
    
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if([self.searchBar.text length]){
        if      (section == 0) return @"Users";
        else if (section == 1) return @"Albums";
        else if (section == 2) return @"Projects";
    }
    
    return @"";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( (indexPath.section == 0 && [self.users count] == 0)
        || (indexPath.section == 1 && [self.albums count] == 0)
        || (indexPath.section == 2 && [self.projects count] == 0)){
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
            vc.invitation_mode = self.searchForInvitation;
            
            if(self.searchForInvitation){
                vc.mode = self.mode;
                vc.content = self.content;
            }
            
        }
    } else if([segue.identifier isEqualToString:@"searchAlbumProject"]){
        if ([segue.destinationViewController isKindOfClass:[AlbumProjectViewController class]]) {
            AlbumProjectViewController *vc = (AlbumProjectViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            if(indexPath.section == 1){
                Album *album = [self.albums objectAtIndex:[self.tableView indexPathForCell:cell].row];
                
                vc.mode = ALBUM_DETAIL;
                vc.content = album;
                vc.viewMode = YES;
            }else if(indexPath.section == 2){
                Project *project = [self.projects objectAtIndex:[self.tableView indexPathForCell:cell].row];
                
                vc.mode = PROJECT_DETAIL;
                vc.content = project;
                vc.viewMode = YES;
            }
        }
    }
}

#pragma mark - Closing keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField){
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - Search Projects
-(NSArray *) searchSelfProjectByWord:(NSString *)word{
    NSArray *allProjects = [ProjectHttpClient getProjectsByUser:[UserHttpClient getCurrentUser].objectID];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (Project *project in allProjects){
        if([project.projectName containsString:word]){
            [results addObject:project];
        }
    }
    
    return results.copy;
}

@end
