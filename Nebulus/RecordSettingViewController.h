//
//  RecordSettingViewController.h
//  Nebulus
//
//  Created by jiayi on 8/13/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SAMPLERATE_MEDIUM 22050
#define SAMPLERATE_LOW 11025
#define SAMPLERATE_HIGH 44100

#define BITDEPTH_LOW 8
#define BITDEPTH_MEDIUM 8
#define BITDEPTH_HIGH 16

#define BITRATE_LOW 12000
#define BITRATE_MEDIUM 64000
#define BITRATE_HIGH 128000

#define ESTIMATEDSIZE_LOW 0.1
#define ESTIMATEDSIZE_MEDIUM 0.5
#define ESTIMATEDSIZE_HIGH 1.0



@interface RecordSettingViewController : UIViewController
    
- (IBAction)QualityChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Quality;
@property (weak, nonatomic) IBOutlet UITextView *Title;
@property (weak, nonatomic) IBOutlet UITextView *Value;


@property NSInteger qualityValue;
@end
