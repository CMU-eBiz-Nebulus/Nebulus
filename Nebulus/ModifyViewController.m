//
//  ModifyAlbumProjectViewController.m
//  Nebulus
//
//  Created by Gang Wu on 8/7/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import "ModifyViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
//#import <QuartzCore/QuartzCore.h>

#import "MusicHttpClient.h"
#import "Album.h"
#import "Project.h"
#import "UserHttpClient.h"
#import "User.h"
#import "ProjectHttpClient.h"

@interface ModifyViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextViewDelegate,
UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tags;
@property (weak, nonatomic) IBOutlet UITextView *desc;

@property (nonatomic) BOOL changePic;

@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation ModifyViewController

#pragma mark - View Controller

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.mode == M_PROJECT){
        Project *project = (Project *)self.content;
        
        self.name.text = project.projectName;
        [self.tags setText:[project.tags componentsJoinedByString:@","]];
        [self.desc setText:project.projectDescription];
        
        self.imageView.image = self.image;
        
        [self setTitle:@"Edit Project"];
    } else if(self.mode == M_ALBUM) {        // ALBUM
        Album *album   = (Album *)self.content;

        self.name.text = album.name;
        [self.tags setText:[album.tags componentsJoinedByString:@","]];
        [self.desc setText:album.albumDescription];
        
        self.imageView.image = self.image;
        
        [self setTitle:@"Edit Album"];
    } else if(self.mode == M_PROFILE){
        User *user = (User *)self.content;
        
        self.name.text = user.name;
        [self.tags setText:[user.tags componentsJoinedByString:@","]];
        [self.desc setText:user.about];
        self.imageView.image = self.image;
        
        [self setTitle:user.username];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.imageView.layer setBorderWidth: 0.5];
    [self.imageView.layer setCornerRadius:5];
    
    [[self.desc layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.desc layer] setBorderWidth:0.5];
    [[self.desc layer] setCornerRadius:5];
    
    self.picker = [[UIImagePickerController alloc] init];
    [self.picker setDelegate:self];
    self.picker.allowsEditing = YES;
    
    self.name.delegate = self;
    self.tags.delegate = self;
    self.desc.delegate = self;
    
    ((UIScrollView *)self.view).contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.5);
    
    UIBarButtonItem *Done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(performDone)];
    self.navigationItem.rightBarButtonItem = Done;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id subview in subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = subview;
            if ([subview isFirstResponder]) {
                [textField resignFirstResponder];
            }
        } else if([subview isKindOfClass:[UITextView class]]){
            UITextView *textview = subview;
            if ([subview isFirstResponder]) {
                [textview resignFirstResponder];
            }
        }
    }
}

#pragma mark - Update Modification

-(void)performDone{
    if(self.mode == M_ALBUM){
        
        Album *album = (Album *)self.content;
        album.name = self.name.text;
        album.albumDescription = [self.desc.textStorage string];
        album.tags = @[self.tags.text];
        
        album = [MusicHttpClient updateAlbum:album];
    }else if(self.mode == M_PROJECT){ // PROJECT
        Project *project = (Project *)self.content;
        project.projectName = self.name.text;
        project.projectDescription = [self.desc.textStorage string];
        project.tags = @[self.tags.text];
        
        [ProjectHttpClient updateProject:project];
    }else if(self.mode == M_PROFILE) {
        User *user = (User *)self.content;
        
        user.name = self.name.text;
        user.about = [self.desc.textStorage string];
        user.tags = @[self.tags.text];
        
        user = [UserHttpClient updateUserInfo:user];
    }
    
    if (self.changePic == YES){
        if(self.mode == M_ALBUM){
            [MusicHttpClient setAlbumImage:self.image AlbumId:((Album *)self.content).objectID];
        }else if(self.mode == M_PROJECT){ // PROJECT
            [ProjectHttpClient setProjectImage:self.image projectId:((Project *)self.content).objectID];
        }else if(self.mode == M_PROFILE) {
            [UserHttpClient setUserImage:self.image userId:((User *)self.content).objectID];
        }
        
        self.changePic = NO;
    }
    
    [self.navigationController popToViewController:self.backVC animated:YES];
}

#pragma mark - Head photo

- (IBAction)add:(id)sender {
    
    // it is in simulator
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
        [actionSheet showInView:self.view];
        
    } else {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:NULL];
    } else {
        //[self dismissViewControllerAnimated:NO completion:nil];
    }
}


- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage   = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        [self.imageView setImage:imageToUse];
        
        self.image = imageToUse;
        self.changePic = YES;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField){
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
