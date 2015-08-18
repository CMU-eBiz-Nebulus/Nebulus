//
//  CommentViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/17/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "PostCommentViewController.h"
#import "ActivityHttpClient.h"

@interface PostCommentViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addClip;
@property (weak, nonatomic) IBOutlet UILabel *clipName;
@property (weak, nonatomic) IBOutlet UIButton *deleteClip;
@end

@implementation PostCommentViewController

#pragma mark - View Controller
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[self.textView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.textView layer] setBorderWidth:0.5];
    [[self.textView layer] setCornerRadius:5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.textView.delegate = self;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.title = self.commentMode ? @"Comment" : @"New Post";
    
    [self.deleteClip setHidden:YES];
    [self.clipName setHidden:YES];
}

#pragma mark - Add comment done
-(void)doneAction{
    
    if(self.commentMode){
        Comment *comment = [[Comment alloc] init];
        comment.text = self.textView.text;
        comment.creator = self.currUser;
        
        comment = [ActivityHttpClient createComment:comment];
    }else{
        //TODO: create activity w/ text and w/o a clip
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - close keyboard
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id subview in subviews) {
        if ([subview isKindOfClass:[UITextView class]]) {
            UITextView *tv = subview;
            if ([subview isFirstResponder]) {
                [tv resignFirstResponder];
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
