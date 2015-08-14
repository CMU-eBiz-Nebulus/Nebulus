//
//  RecordSettingViewController.h
//  Nebulus
//
//  Created by jiayi on 8/13/15.
//  Copyright (c) 2015 CMU-eBiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordSettingViewController : UIViewController
- (IBAction)QualityChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Quality;
@property (weak, nonatomic) IBOutlet UITextView *Title;
@property (weak, nonatomic) IBOutlet UITextView *Value;

@end
