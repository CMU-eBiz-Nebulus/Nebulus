//
//  CreateAlbum.m
//  Nebulus
//
//  Created by ballade on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateProjectAlbumViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
//#import <QuartzCore/QuartzCore.h>

#import "MusicHttpClient.h"
#import "Album.h"
#import "Project.h"
#import "UserHttpClient.h"
#import "ProjectHttpClient.h"


@interface CreateProjectAlbumViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tags;
@property (weak, nonatomic) IBOutlet UITextView *desc;

@property (strong, nonatomic) UIImagePickerController *picker;
@end

@implementation CreateProjectAlbumViewController

- (void)viewDidLoad {
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
    
    UIBarButtonItem *Done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(performDone)];
    self.navigationItem.rightBarButtonItem = Done;
}

-(void)performDone{
    if(self.mode == ALBUM){
        
        Album *album = [[Album alloc] init];
        album.name = self.name.text;
        album.albumDescription = [self.desc.textStorage string];
        album.tags = @[self.tags.text];
        album.creator = [UserHttpClient getCurrentUser];

        album = [MusicHttpClient createAlbum:album];

        if(self.imageView.image)
            [MusicHttpClient setAlbumImage:self.imageView.image AlbumId:album.objectID];

        
    }else { // PROJECT
        
        Project *project = [[Project alloc] init];
        project.projectName = self.name.text;
        project.tags = @[self.tags.text];
        project.projectDescription = [self.desc.textStorage string];
        project.creator = [UserHttpClient getCurrentUser];
        
        project = [ProjectHttpClient createProject:project];
        
        if(self.imageView.image)
            [ProjectHttpClient setProjectImage:self.imageView.image projectId:project.objectID];
        
    }
    
    [self.navigationController popToViewController:self.backVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:self.mode == PROJECT ? @"New Project" : @"New Album" ];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

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
        [self dismissViewControllerAnimated:NO completion:nil];
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
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}




@end

