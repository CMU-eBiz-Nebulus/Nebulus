//
//  CreateProject.h
//  Nebulus
//
//  Created by ballade on 7/24/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#ifndef Nebulus_CreateProject_h
#define Nebulus_CreateProject_h

#import <UIKit/UIKit.h>

@interface CreateProject : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UIButton *add;

@property (weak, nonatomic) IBOutlet UITextView *textview1;

@property (weak, nonatomic) IBOutlet UITextView *textview2;
@property (weak, nonatomic) IBOutlet UITextView *textview3;


@property (nonatomic) UIImagePickerController *picker;
@end

#endif
