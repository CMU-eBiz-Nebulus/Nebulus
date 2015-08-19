//
//  CommentViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/17/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "PostCommentViewController.h"
#import "ActivityHttpClient.h"
#import "CommentClipPickerViewController.h"

@interface PostCommentViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *tagsField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addClip;

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
    
    if(self.commentMode){
        self.title = @"Comment";
        self.titleField.enabled = NO;
        self.titleField.text = @"Type in comment below";
        self.tagsField.hidden = YES;
    }else{
        self.title = @"New Post";
        self.titleField.delegate = self;
    }
    
    [self.deleteClip setHidden:YES];
    [self.clipName setHidden:YES];
    self.clip = nil;
}

#pragma mark - Add comment done
-(void)doneAction{
    
    if(self.commentMode){
        Comment *comment = [[Comment alloc] init];
        comment.text = self.textView.text;
        comment.creator = self.currUser;
        comment.modelId = self.activity.objectID;
        
        if(self.clip && self.clip.objectID){
            comment.clip = self.clip;
        }

        comment = [ActivityHttpClient createComment:comment];
    }else{
        Activity *post = [[Activity alloc] init];
        
        post.creator = self.currUser;
        post.text = self.textView.text;
        post.type = @"textShare";
        post.title = self.titleField.text;
        post.tags = @[self.tagsField.text];
        
        if(self.clip && self.clip.objectID){
            post.recordingId = self.clip.recordingId;
            post.recordingDuration = self.clip.duration;
            post.type = @"clipShare";
        }
        
        post = [ActivityHttpClient createActivity:post];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteClip:(UIButton *)sender {
    [self.deleteClip setHidden:YES];
    [self.clipName setHidden:YES];
    self.clip = nil;
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
        }else if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *tv = subview;
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

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"selectClip"]) {
        if ([segue.destinationViewController isKindOfClass:[CommentClipPickerViewController class]]) {
            CommentClipPickerViewController *vc = (CommentClipPickerViewController *)segue.destinationViewController;
            
            vc.backVC = self;
        }
    }
    
}

@end
