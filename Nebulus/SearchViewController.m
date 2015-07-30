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
#import "OtherProfileViewController.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

-(NSArray *)users{
    if(!_users) _users = @[];
    return _users;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.users count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    User *user = [self.users objectAtIndex:indexPath.row];
    [cell.textLabel setText: user.username];
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"searchSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[OtherProfileViewController class]]) {
            OtherProfileViewController *vc = (OtherProfileViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            

            vc.me = [UserHttpClient getCurrentUser];
            vc.other = [self.users objectAtIndex:[self.tableView indexPathForCell:cell].row];
        }
    }
}

@end
