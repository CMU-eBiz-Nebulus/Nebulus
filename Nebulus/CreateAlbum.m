//
//  CreateAlbum.m
//  Nebulus
//
//  Created by ballade on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateAlbum.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>


@interface CreateAlbum () <UIActionSheetDelegate>
@property (nonatomic) NSMutableArray *capturedImages;
//@property (nonatomic) UITabBarController *toolBar;
@property (nonatomic) IBOutlet UIView *overlayView;
@end

@implementation CreateAlbum

@synthesize imageView;
@synthesize add;
@synthesize textview3;
@synthesize textview2;
@synthesize textview1;
@synthesize picker;



- (void)viewDidLoad {
    [super viewDidLoad];
    [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [imageView.layer setBorderWidth: 0.5];
    [imageView.layer setCornerRadius:5];
    
    [[self.textview1 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.textview1 layer] setBorderWidth:0.5];
    [[self.textview1 layer] setCornerRadius:5];
    
    [[self.textview2 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.textview2 layer] setBorderWidth:0.5];
    [[self.textview2 layer] setCornerRadius:5];
    
    [[self.textview3 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.textview3 layer] setBorderWidth:0.5];
    [[self.textview3 layer] setCornerRadius:5];
    
    
    
    
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 1)];
    //    lineView.backgroundColor = [UIColor blackColor];
    //    [self.view addSubview:lineView];
    //[lineView release];
    //[[self.textview1 layer] setCornerRadius:15];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}





- (IBAction)add:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Add Project Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Photos", nil];
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"Item A Selected");
            
            picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            //picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
        case 1:
        {
            NSLog(@"Item B Selected");
            
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            break;
        }
            
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,kUTTypeImage, nil];
    imagePickerController.delegate = self;
    
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.picker = imagePickerController;
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker2
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        
    }
    
    // Handle a movied picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
//        NSString *moviePath = [[info objectForKey:
//                                UIImagePickerControllerMediaURL] path];
//        
        // Do something with the picked movie available at moviePath
        
        
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    [self.imageView setImage:originalImage];
    //[self.capturedImages addObject:originalImage];
    
    
    
    [picker2 dismissViewControllerAnimated:YES completion:NULL];
    
    // [self finishAndUpdate];
}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.picker = nil;
}




- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker3 {
    [picker3 dismissViewControllerAnimated:YES completion:NULL];
}




@end

