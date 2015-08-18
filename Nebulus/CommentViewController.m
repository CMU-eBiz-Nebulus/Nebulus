//
//  CommentViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/17/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "CommentViewController.h"
#import "ActivityHttpClient.h"

@interface CommentViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UIButton *addClip;
@property (weak, nonatomic) IBOutlet UILabel *clipName;
@property (weak, nonatomic) IBOutlet UIButton *deleteClip;
@end

@implementation CommentViewController

#pragma mark - View Controller
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[self.commentText layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentText layer] setBorderWidth:0.5];
    [[self.commentText layer] setCornerRadius:5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.commentText.delegate = self;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.title = @"Comment";
    [self.deleteClip setHidden:YES];
    [self.clipName setHidden:YES];
}

#pragma mark - Add comment done
-(void)doneAction{
    Comment *comment = [[Comment alloc] init];
    comment.text = self.commentText.text;
    comment.creator = self.currUser;
    comment = [ActivityHttpClient createComment:comment];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - close keyboard
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id subview in subviews) {
        if ([subview isKindOfClass:[UITextView class]]) {
            UITextField *textField = subview;
            if ([subview isFirstResponder]) {
                [textField resignFirstResponder];
            }
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
