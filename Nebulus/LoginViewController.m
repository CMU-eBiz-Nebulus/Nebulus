//
//  LoginViewController.m
//  Nebulus
//
//  Created by Jike on 7/20/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "HttpClient.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *indicatorButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, getter=isLoginMode) BOOL loginMode;

@end

@implementation LoginViewController

#define BUTTON_SIGN_IN @"Sign In"
#define BUTTON_SIGN_UP @"Sign Up"

#define INDICATOR_BUTTON_SIGN_IN @"Not have an account?"
#define INDICATOR_BUTTON_SIGN_UP @"Already have an account"

-(void)setLoginMode:(BOOL)loginMode{
    if (loginMode){
        self.emailLabel.hidden = YES;
        self.emailField.hidden = YES;
        [self.indicatorButton setTitle:INDICATOR_BUTTON_SIGN_IN forState:UIControlStateNormal];
        [self.loginButton setTitle:BUTTON_SIGN_IN forState:UIControlStateNormal];
        
        self.usernameField.text = @"test";
        self.passwordField.text = @"123456";
    } else {
        self.emailLabel.hidden = NO;
        self.emailField.hidden = NO;
        [self.indicatorButton setTitle:INDICATOR_BUTTON_SIGN_UP forState:UIControlStateNormal];
        [self.loginButton setTitle:BUTTON_SIGN_UP forState:UIControlStateNormal];
    }
    _loginMode = loginMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginMode = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login_resigter_triggered:(id)sender {
    if([self isLoginMode])
        [self login];
    else
        [self signup];
}

-(void)login{
    User *user = [HttpClient getUser:self.usernameField.text password:self.passwordField.text];
    if (user != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:user.username forKey:@"username"];
        [defaults synchronize];
        //        //[self dismissViewControllerAnimated:YES completion:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        [self presentViewController:tabBarController animated:NO completion:nil];
        NSLog(@"Logged in");
    } else {//Wrong username/password combination
        NSLog(@"Wrong password/username");
    }
}

-(void)signup{
    
    if([HttpClient registerUser:self.usernameField.text
                       password:self.passwordField.text
                          email:self.emailField.text]){
        
        [self login];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register failed"
                                                        message:@"Please check your input again!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)switchMode:(UIButton *)sender {
    self.loginMode = ![self isLoginMode];
}
@end
